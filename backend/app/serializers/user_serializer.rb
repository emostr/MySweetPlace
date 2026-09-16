class UserSerializer < ApplicationSerializer
  def initialize(user)
    @user = user
  end

  def call
    return { user: nil, place: nil } unless @user

    {
      user: @user.slice(:id, :email_address, :locale, :admin, :created_at),
      place: @user.place && PlaceCardSerializer.call(@user.place)
    }
  end
end
