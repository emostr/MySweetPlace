class Neighbourship < ApplicationRecord
  belongs_to :place
  belongs_to :neighbour, class_name: "Place"

  normalizes :label, with: ->(label) { label.squish }

  validates :neighbour_id, uniqueness: { scope: :place_id }
  validates :label, length: { maximum: 60 }
  validate :not_self
  validate :limit, on: :create

  before_create -> { self.position = (place.neighbourships.maximum(:position) || -1) + 1 }

  private
    def not_self
      errors.add(:neighbour, I18n.t("api.neighbour_self")) if neighbour_id == place_id
    end

    def limit
      errors.add(:base, :too_many_items, count: Place::MAX_NEIGHBOURS) if place.neighbourships.count >= Place::MAX_NEIGHBOURS
    end
end
