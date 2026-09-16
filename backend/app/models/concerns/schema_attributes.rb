module SchemaAttributes
  extend ActiveSupport::Concern

  included do
    validate :apply_schema_results
  end

  def cast_schema(attribute, schema, value)
    result = Schema.cast(schema, value)
    self[attribute] = result.value
    schema_results[attribute.to_s] = result
    result
  end

  private
    def schema_results = @schema_results ||= {}

    def schema_upload_scope = raise(NotImplementedError)

    def apply_schema_results
      results = schema_results.values
      ids = results.flat_map(&:upload_ids).uniq
      known = ids.any? ? schema_upload_scope.where(id: ids).pluck(:id).to_set : Set.new

      schema_results.each do |attribute, result|
        result.errors.each do |path, messages|
          key = path == "base" ? attribute : "#{attribute}.#{path}"
          messages.each { errors.add(key.to_sym, it) }
        end
        result.upload_refs.each do |path, id|
          errors.add(:"#{attribute}.#{path}", I18n.t("errors.messages.unknown_upload")) unless known.include?(id)
        end
      end
    end
end
