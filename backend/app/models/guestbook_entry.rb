class GuestbookEntry < ApplicationRecord
  belongs_to :place
  belongs_to :author_place, class_name: "Place", optional: true

  enum :status, { visible: "visible", hidden: "hidden", pending: "pending" }, default: "visible", validate: true

  normalizes :author_name, with: ->(name) { name.squish }
  normalizes :body, with: ->(body) { body.gsub(/\r\n?/, "\n").gsub(/\n{3,}/, "\n\n").strip }

  validates :author_name, presence: true, length: { maximum: 40 }
  validates :body, presence: true, length: { maximum: 500 }

  scope :ordered, -> { order(pinned: :desc, created_at: :desc, id: :desc) }

  def written_by?(place) = place.present? && author_place_id == place.id
end
