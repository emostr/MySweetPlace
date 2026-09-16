class User < ApplicationRecord
  LOCALES = %w[ru en].freeze

  has_secure_password
  has_many :sessions, dependent: :delete_all
  has_one :place, dependent: :destroy

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 254 },
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :locale, inclusion: { in: LOCALES }
end
