class Place < ApplicationRecord
  include SchemaAttributes

  USERNAME_FORMAT = /\A[a-z0-9][a-z0-9_-]{1,29}\z/
  RESERVED_USERNAMES = %w[
    about admin administrator api app assets edit explore guestbook help login logout me msp
    mysweetplace neighbours notes null official place places random register root settings signin
    signup static storage support system team undefined www
  ].freeze
  DEFAULT_BLOCKS = %w[intro now links notes projects guestbook neighbours].freeze
  MAX_NEIGHBOURS = 200

  belongs_to :user
  has_many :blocks, -> { order(:position, :id) }, dependent: :delete_all, inverse_of: :place
  has_many :uploads, dependent: :destroy
  has_many :notes, dependent: :delete_all
  has_many :guestbook_entries, dependent: :delete_all
  has_many :written_guestbook_entries, class_name: "GuestbookEntry", foreign_key: :author_place_id, dependent: :nullify
  has_many :neighbourships, -> { order(:position, :id) }, dependent: :delete_all
  has_many :neighbours, through: :neighbourships
  has_many :reverse_neighbourships, class_name: "Neighbourship", foreign_key: :neighbour_id, dependent: :delete_all
  has_one_attached :avatar

  normalizes :username, with: ->(username) { username.strip.delete_prefix("@").downcase }

  validates :username, presence: true, uniqueness: true, format: { with: USERNAME_FORMAT }
  validates :username, exclusion: { in: RESERVED_USERNAMES, message: :reserved }
  validates :avatar, image: { max_size: 5.megabytes }

  scope :active, -> { where(suspended_at: nil) }
  scope :listed, -> { active.where(listed: true) }
  scope :discoverable, -> { listed.where.not(content_updated_at: nil) }
  scope :with_interest, ->(interest) { where("? = ANY(interests)", interest.to_s.strip.downcase) }

  before_validation :apply_defaults, on: :create
  after_create :create_default_blocks

  def self.find_active!(username) = active.find_by!(username: username.to_s.downcase)

  def assign_profile(value) = cast_schema(:profile, Profile::SCHEMA, value)
  def assign_theme(value) = cast_schema(:theme, Theme::SCHEMA, value)
  def assign_settings(value) = cast_schema(:settings, Theme::SETTINGS, value)

  def display_name(locale = I18n.locale)
    name = profile.fetch("name", {})
    name[locale.to_s].presence || name.values.first.presence || username
  end

  def guestbook_block = blocks.find { it.kind == "guestbook" }

  def refresh_interests!
    block = blocks.reload.find { it.kind == "interests" && it.visible }
    labels = block ? block.data.fetch("items", []).map { it["label"].to_s.strip.downcase }.compact_blank.uniq : []
    update_columns(interests: labels) if labels != interests
  end

  def content_changed!
    update_columns(content_updated_at: Time.current)
  end

  def upload_ids_in_use
    ids = blocks.flat_map { collect_upload_ids(it.data) }
    ids << theme.dig("background", "image_id")
    ids.concat(notes.pluck(:image_ids).flatten)
    ids.compact.map(&:to_i).uniq
  end

  private
    def schema_upload_scope = uploads

    def apply_defaults
      assign_profile(profile) if profile.blank?
      assign_theme(theme) if theme.blank?
      assign_settings(settings) if settings.blank?
    end

    def create_default_blocks
      DEFAULT_BLOCKS.each_with_index do |kind, position|
        blocks.create!(kind:, position:, visible: true).tap(&:apply_defaults!)
      end
    end

    def collect_upload_ids(value)
      case value
      when Hash then value.flat_map { |key, item| key.to_s.match?(/\A(image|cover)_ids?\z/) ? Array(item) : collect_upload_ids(item) }
      when Array then value.flat_map { collect_upload_ids(it) }
      else []
      end
    end
end
