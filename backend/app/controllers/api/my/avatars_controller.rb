class Api::My::AvatarsController < Api::My::BaseController
  def update
    @place.avatar = params.require(:file)
    @place.content_updated_at = Time.current
    @place.save!
    render_place
  end

  def destroy
    @place.avatar.purge
    render_place
  end
end
