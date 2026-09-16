class Block < ApplicationRecord
  include SchemaAttributes

  belongs_to :place

  validates :kind, inclusion: { in: Kinds.names }
  validate :singleton_kind, on: :create

  after_commit :refresh_place_interests, if: -> { kind == "interests" }

  def definition = Kinds[kind]
  def singleton? = definition.singleton

  def assign_title(value) = cast_schema(:title, Schema.localized(max: 60), value)
  def assign_data(value) = cast_schema(:data, definition.data, value)
  def assign_style(value) = cast_schema(:style, definition.style, value)

  def apply_defaults!
    assign_title(title)
    assign_data(data)
    assign_style(style)
    save!
  end

  private
    def schema_upload_scope = place.uploads

    def singleton_kind
      return unless Kinds.names.include?(kind) && singleton?
      errors.add(:kind, :singleton_block) if place.blocks.where(kind:).where.not(id:).exists?
    end

    def refresh_place_interests
      place.refresh_interests! unless place.destroyed?
    end
end
