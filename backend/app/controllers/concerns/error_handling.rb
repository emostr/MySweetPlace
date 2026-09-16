module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: -> { render_error :not_found }
    rescue_from ActiveRecord::RecordInvalid, with: ->(error) { render_invalid error.record }
    rescue_from ActionController::ParameterMissing, with: -> { render_error :bad_request }
  end

  private
    def render_error(status, message = nil, code: status)
      I18n.with_locale(request_locale) do
        render json: { error: code.to_s, message: message || I18n.t("api.#{code}") }, status:
      end
    end

    def render_invalid(record_or_fields)
      I18n.with_locale(request_locale) do
        fields = record_or_fields.respond_to?(:errors) ? record_or_fields.errors.to_hash : record_or_fields
        render json: { error: "validation_failed", message: I18n.t("api.validation_failed"), fields: }, status: :unprocessable_content
      end
    end

    def too_many_requests
      render_error :too_many_requests
    end
end
