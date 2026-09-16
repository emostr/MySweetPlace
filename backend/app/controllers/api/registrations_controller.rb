class Api::RegistrationsController < ApplicationController
  rate_limit to: 10, within: 1.hour, only: :create, with: :too_many_requests

  def create
    user = User.new(email_address: params[:email_address].to_s, password: params[:password].to_s, locale: I18n.locale.to_s)
    place = Place.new(user:, username: params[:username].to_s)

    user_valid = user.valid?
    place_valid = place.valid?
    return render_invalid(user.errors.to_hash.merge(place.errors.to_hash.except(:user))) unless user_valid && place_valid

    ActiveRecord::Base.transaction do
      user.save!
      place.save!
    end
    start_new_session_for(user)
    render json: UserSerializer.call(user), status: :created
  rescue ActiveRecord::RecordNotUnique
    render_invalid(username: [ I18n.t("errors.messages.taken") ])
  end
end
