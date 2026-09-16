class Api::MeController < ApplicationController
  before_action :require_authentication, only: %i[update destroy]

  def show
    render json: UserSerializer.call(Current.user)
  end

  def update
    user = Current.user
    attributes = params.permit(:locale, :email_address, :password)

    if (attributes.key?(:email_address) || attributes.key?(:password)) && !user.authenticate(params[:current_password].to_s)
      return render_invalid(current_password: [ I18n.t("api.invalid_password") ])
    end
    return render_invalid(password: [ I18n.t("errors.messages.blank") ]) if attributes.key?(:password) && attributes[:password].blank?

    user.update!(attributes)
    user.sessions.where.not(id: Current.session.id).delete_all if attributes.key?(:password)
    render json: UserSerializer.call(user)
  end

  def destroy
    return render_invalid(password: [ I18n.t("api.invalid_password") ]) unless Current.user.authenticate(params[:password].to_s)

    Current.user.destroy!
    cookies.delete(:session_id)
    head :no_content
  end
end
