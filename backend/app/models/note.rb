class Note < ApplicationRecord
  MAX_IMAGES = 4

  belongs_to :place

  normalizes :body, with: ->(body) { body.gsub(/\r\n?/, "\n").strip }

  validates :body, length: { maximum: 5000 }
  validate :body_or_images
  validate :images_belong_to_place

  before_save :render_body, if: :body_changed?
  after_save -> { place.content_changed! }
  after_destroy :destroy_orphan_images

  scope :feed, -> { order(pinned: :desc, created_at: :desc, id: :desc) }

  def image_ids=(ids)
    super(Array(ids).map(&:to_i).select(&:positive?).uniq)
  end

  private
    def render_body
      self.body_html = MarkdownRenderer.render(body)
    end

    def body_or_images
      errors.add(:body, :blank) if body.blank? && image_ids.empty?
    end

    def images_belong_to_place
      errors.add(:image_ids, :too_many_items, count: MAX_IMAGES) if image_ids.size > MAX_IMAGES
      return if image_ids.empty?
      errors.add(:image_ids, :unknown_upload) if place.uploads.where(id: image_ids).count != image_ids.size
    end

    def destroy_orphan_images
      place.uploads.where(id: image_ids).destroy_all
    end
end
