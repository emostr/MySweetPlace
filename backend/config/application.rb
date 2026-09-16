require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MySweetPlace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies

    config.time_zone = "UTC"

    config.i18n.available_locales = %i[ru en]
    config.i18n.default_locale = :ru
    config.i18n.fallbacks = [ :ru ]

    config.active_storage.routes_prefix = "/api/storage"
    config.active_storage.resolve_model_to_route = :rails_storage_proxy

    # images are resized in the browser, no libvips needed
    config.active_storage.variant_processor = :disabled
    config.active_storage.analyzers = []

    config.active_job.queue_adapter = :async

    config.x.app_origin = ENV.fetch("APP_ORIGIN", "http://localhost:5173")
  end
end
