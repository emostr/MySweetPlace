class Api::My::BaseController < ApplicationController
  before_action :require_authentication
  before_action :set_place

  private
    def set_place
      @place = Current.place
      render_error :not_found unless @place
    end

    def render_place
      render json: { place: PlaceSerializer.call(@place.reload, viewer: @place) }
    end
end
