# Casts untrusted JSON into a clean structure for jsonb columns.
module Schema
  class Context
    attr_reader :errors, :upload_refs

    def initialize
      @errors = {}
      @upload_refs = []
    end

    def error(path, key, **options)
      message = I18n.t("errors.messages.#{key}", **options)
      (@errors[path.join(".").presence || "base"] ||= []) << message
    end
  end

  Result = Struct.new(:value, :errors, :upload_refs) do
    def valid? = errors.empty?
    def upload_ids = upload_refs.map(&:last).uniq
  end

  class Type
    def initialize(required: false, default: nil)
      @required = required
      @default = default
    end

    def cast(value, path, ctx)
      if blank?(value)
        ctx.error(path, :blank) if @required
        return empty
      end
      cast_value(value, path, ctx)
    end

    def empty = @default.dup

    private
      def blank?(value) = value.nil? || (value.respond_to?(:empty?) && value.empty?) || (value.is_a?(::String) && value.strip.empty?)
  end

  class String < Type
    CONTROL_CHARS = /[[:cntrl:]&&[^\n]]/

    def initialize(max:, multiline: false, format: nil, required: false, default: "")
      super(required:, default:)
      @max = max
      @multiline = multiline
      @format = format
    end

    private
      def cast_value(value, path, ctx)
        unless value.is_a?(::String) || value.is_a?(Numeric)
          ctx.error(path, :invalid)
          return empty
        end

        string = value.to_s.unicode_normalize(:nfc).gsub(/\r\n?/, "\n").tr("\t", " ").gsub(CONTROL_CHARS, "")
        string = @multiline ? string.gsub(/\n{3,}/, "\n\n") : string.tr("\n", " ")
        string = string.strip

        ctx.error(path, :too_long, count: @max) if string.length > @max
        ctx.error(path, :invalid) if @format && string.present? && !string.match?(@format)
        string
      end
  end

  class Localized < Type
    LOCALES = %w[ru en].freeze

    def initialize(max:, multiline: false, required: false)
      super(required:, default: {})
      @string = String.new(max:, multiline:)
    end

    private
      def cast_value(value, path, ctx)
        value = { "ru" => value } if value.is_a?(::String)
        value = value.to_unsafe_h if value.is_a?(ActionController::Parameters)
        unless value.is_a?(Hash)
          ctx.error(path, :invalid)
          return empty
        end

        value = value.stringify_keys
        result = LOCALES.each_with_object({}) do |locale, hash|
          string = @string.cast(value[locale], path + [ locale ], ctx)
          hash[locale] = string if string.present?
        end
        ctx.error(path, :blank) if @required && result.empty?
        result
      end
  end

  class Integer < Type
    def initialize(min: nil, max: nil, required: false, default: nil)
      super(required:, default:)
      @min = min
      @max = max
    end

    private
      def cast_value(value, path, ctx)
        number = case value
        when ::Integer then value
        when ::String then value.strip.match?(/\A-?\d+\z/) ? value.to_i : nil
        when Float then value.to_i
        end

        if number.nil?
          ctx.error(path, :not_an_integer)
          return empty
        end
        if @min && number < @min
          ctx.error(path, :greater_than_or_equal_to, count: @min)
          return empty
        end
        if @max && number > @max
          ctx.error(path, :less_than_or_equal_to, count: @max)
          return empty
        end
        number
      end
  end

  class Boolean < Type
    TRUE = [ true, 1, "1", "true", "on" ].freeze
    FALSE = [ false, 0, "0", "false", "off" ].freeze

    def initialize(default: false)
      super(default:)
    end

    def cast(value, path, ctx)
      return true if TRUE.include?(value)
      return false if FALSE.include?(value)
      ctx.error(path, :invalid) unless value.nil?
      empty
    end
  end

  class Enum < Type
    def initialize(values, default: values.first)
      super(default:)
      @values = values.map(&:to_s)
    end

    private
      def cast_value(value, path, ctx)
        return value.to_s if @values.include?(value.to_s)
        ctx.error(path, :inclusion)
        empty
      end
  end

  class Color < Type
    FORMAT = /\A#(?:\h{3}|\h{6})\z/

    private
      def cast_value(value, path, ctx)
        color = value.to_s.strip.downcase
        unless color.match?(FORMAT)
          ctx.error(path, :invalid)
          return empty
        end
        color.length == 4 ? "##{color[1..].chars.map { it * 2 }.join}" : color
      end
  end

  class Url < Type
    def initialize(schemes: %w[http https], required: false, default: "")
      super(required:, default:)
      @schemes = schemes
    end

    private
      def cast_value(value, path, ctx)
        url = value.to_s.strip
        url = "https://#{url}" if !url.match?(/\A[a-z][a-z0-9+.-]*:/i) && url.match?(/\A[^\s\/]+\.[^\s\/]+/)

        uri = URI.parse(url)
        valid = uri.scheme && @schemes.include?(uri.scheme.downcase) && url.length <= 2048 && !url.match?(/\s/)
        valid &&= uri.host.present? if uri.scheme.to_s.downcase.start_with?("http")

        if valid
          url
        else
          ctx.error(path, :invalid)
          empty
        end
      rescue URI::InvalidURIError
        ctx.error(path, :invalid)
        empty
      end
  end

  class Date < Type
    PATTERNS = {
      year: /\A(\d{4})\z/,
      month: /\A(\d{4})-(\d{2})\z/,
      day: /\A(\d{4})-(\d{2})-(\d{2})\z/
    }.freeze

    def initialize(precision: %i[year month day], required: false)
      super(required:, default: "")
      @patterns = PATTERNS.slice(*Array(precision))
    end

    private
      def cast_value(value, path, ctx)
        string = value.to_s.strip
        match = @patterns.values.lazy.filter_map { string.match(it) }.first
        year, month, day = match&.captures&.map(&:to_i)
        valid = match && year.between?(1, 9999) && (month.nil? || month.between?(1, 12)) && (day.nil? || ::Date.valid_date?(year, month, day))

        if valid
          string
        else
          ctx.error(path, :invalid)
          empty
        end
      end
  end

  class UploadRef < Type
    private
      def cast_value(value, path, ctx)
        id = value.is_a?(::Integer) ? value : (value.to_s.match?(/\A\d+\z/) ? value.to_i : nil)
        if id.nil? || id <= 0
          ctx.error(path, :invalid)
          return empty
        end
        ctx.upload_refs << [ path.join("."), id ]
        id
      end
  end

  class Array < Type
    def initialize(of:, max:, required: false)
      super(required:, default: [])
      @of = of
      @max = max
    end

    private
      def cast_value(value, path, ctx)
        value = value.values if value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
        unless value.is_a?(::Array)
          ctx.error(path, :invalid)
          return empty
        end
        ctx.error(path, :too_many_items, count: @max) if value.size > @max

        value.first(@max).each_with_index.map { |item, index| @of.cast(item, path + [ index ], ctx) }
      end
  end

  class Object < Type
    ID_FORMAT = /\A[A-Za-z0-9_-]{1,32}\z/

    def initialize(fields, id: false, validate: nil, required: false)
      super(required:, default: nil)
      @fields = fields
      @id = id
      @validate = validate
    end

    def empty = cast_value({}, [], Context.new)

    private
      def cast_value(value, path, ctx)
        value = value.to_unsafe_h if value.is_a?(ActionController::Parameters)
        unless value.is_a?(Hash)
          ctx.error(path, :invalid)
          return empty
        end

        value = value.stringify_keys
        result = {}
        if @id
          id = value["id"].to_s
          result["id"] = id.match?(ID_FORMAT) ? id : SecureRandom.alphanumeric(10)
        end
        @fields.each { |name, type| result[name.to_s] = type.cast(value[name.to_s], path + [ name ], ctx) }
        @validate&.call(result, path, ctx)
        result
      end
  end

  module_function

  def string(**) = String.new(**)
  def localized(**) = Localized.new(**)
  def integer(**) = Integer.new(**)
  def boolean(**) = Boolean.new(**)
  def enum(values, **) = Enum.new(values, **)
  def color(**) = Color.new(**)
  def url(**) = Url.new(**)
  def date(**) = Date.new(**)
  def upload(**) = UploadRef.new(**)
  def array(**) = Array.new(**)
  def object(fields = {}, **rest)
    types, options = rest.partition { |_, value| value.is_a?(Type) }.map(&:to_h)
    Object.new(fields.merge(types), **options)
  end

  def cast(type, value)
    ctx = Context.new
    result = type.cast(value, [], ctx)
    Result.new(result, ctx.errors, ctx.upload_refs)
  end
end
