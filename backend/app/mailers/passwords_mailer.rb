class PasswordsMailer < ApplicationMailer
  def reset(user)
    @url = "#{Rails.configuration.x.app_origin}/reset-password/#{user.password_reset_token}"
    I18n.with_locale(user.locale) do
      mail subject: t(".subject"), to: user.email_address
    end
  end
end
