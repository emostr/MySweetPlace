module Localization
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
  end

  private
    def switch_locale(&)
      I18n.with_locale(request_locale, &)
    end

    def request_locale
      @request_locale ||= begin
        available = I18n.available_locales.map(&:to_s)
        candidates = [ request.headers["X-Locale"], cookies[:locale] ]
        candidates += request.headers["Accept-Language"].to_s.scan(/(?:^|,)\s*([a-zA-Z]{2})/).flatten
        candidates.map { it.to_s.downcase }.find { available.include?(it) } || I18n.default_locale
      end
    end
end
