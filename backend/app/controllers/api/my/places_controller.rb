class Api::My::PlacesController < Api::My::BaseController
  def show
    render_place
  end

  def update
    @place.username = params[:username].to_s if params.key?(:username)
    @place.listed = params[:listed] if params.key?(:listed)
    @place.assign_profile(params[:profile]) if params.key?(:profile)
    @place.assign_theme(params[:theme]) if params.key?(:theme)
    @place.assign_settings(params[:settings]) if params.key?(:settings)
    @place.content_updated_at = Time.current if params.key?(:profile) || params.key?(:theme)
    @place.save!
    render_place
  end
end
