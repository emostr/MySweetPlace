class Api::PasswordResetsController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create, with: :too_many_requests

  def create
    user = User.find_by(email_address: params[:email_address].to_s.strip.downcase)
    PasswordsMailer.reset(user).deliver_later if user
    head :accepted
  end

  def update
    user = User.find_by_password_reset_token!(params[:token])
    return render_invalid(password: [ I18n.t("errors.messages.blank") ]) if params[:password].blank?

    user.update!(password: params[:password])
    user.sessions.delete_all
    head :no_content
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render_error :unprocessable_content, code: :invalid_token
  end
end
