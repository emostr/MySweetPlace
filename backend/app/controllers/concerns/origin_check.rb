module OriginCheck
  extend ActiveSupport::Concern

  included do
    before_action :verify_origin, unless: -> { request.get? || request.head? }
  end

  private
    def verify_origin
      origin = request.headers["Origin"]
      return if origin.nil? || allowed_origins.include?(origin)
      render_error :forbidden, I18n.t("api.bad_origin")
    end

    def allowed_origins
      origins = [ Rails.configuration.x.app_origin ]
      origins += %w[http://localhost:5173 http://127.0.0.1:5173 http://localhost:4173] if Rails.env.development?
      origins
    end
end
