module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session
  end

  private
    def authenticated? = Current.session.present?

    def resume_session
      Current.session ||= Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def require_authentication
      render_error :unauthorized unless authenticated?
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent.to_s.first(255), ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed[:session_id] = {
          value: session.id, expires: 1.year, httponly: true, same_site: :lax, secure: Rails.env.production?
        }
      end
    end

    def terminate_session
      Current.session&.destroy
      Current.session = nil
      cookies.delete(:session_id)
    end
end
