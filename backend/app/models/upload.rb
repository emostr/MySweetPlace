class Upload < ApplicationRecord
  PURPOSES = %w[photo project album background note].freeze

  belongs_to :place
  has_one_attached :file

  validates :purpose, inclusion: { in: PURPOSES }
  validates :width, :height, numericality: { only_integer: true, in: 1..20_000 }, allow_nil: true
  validates :file, presence: true, image: true
end
