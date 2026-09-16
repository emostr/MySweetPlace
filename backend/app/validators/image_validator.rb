class ImageValidator < ActiveModel::EachValidator
  CONTENT_TYPES = %w[image/jpeg image/png image/webp image/gif image/avif].freeze

  def validate_each(record, attribute, value)
    return unless value.attached?

    blob = value.blob
    max_size = options.fetch(:max_size, 10.megabytes)
    record.errors.add(attribute, :not_an_image) unless CONTENT_TYPES.include?(blob.content_type)
    record.errors.add(attribute, :file_too_big, count: max_size / 1.megabyte) if blob.byte_size > max_size
  end
end
