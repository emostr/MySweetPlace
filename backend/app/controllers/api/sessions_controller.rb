class Api::SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create, with: :too_many_requests

  def create
    user = User.authenticate_by(email_address: params[:email_address].to_s.strip, password: params[:password].to_s)
    if user
      start_new_session_for(user)
      render json: UserSerializer.call(user)
    else
      render_error :unauthorized, code: :invalid_credentials
    end
  end

  def destroy
    terminate_session
    head :no_content
  end
end
