class Api::My::NeighboursController < Api::My::BaseController
  def index
    neighbourships = @place.neighbourships.joins(:neighbour).merge(Place.active).includes(neighbour: { avatar_attachment: :blob })
    neighbour_of = Place.active.joins(:neighbourships).where(neighbourships: { neighbour_id: @place.id })
      .with_attached_avatar.order("neighbourships.created_at DESC")

    render json: {
      items: neighbourships.map { card(it) },
      neighbour_of: PlaceCardSerializer.many(neighbour_of)
    }
  end

  def create
    neighbour = Place.find_active!(params.require(:username))
    neighbourship = @place.neighbourships.find_or_create_by!(neighbour:) do |record|
      record.label = params[:label].to_s
    end
    @place.content_changed!
    render json: { item: card(neighbourship) }, status: :created
  end

  def update
    neighbourship = find_neighbourship
    neighbourship.update!(label: params[:label].to_s)
    render json: { item: card(neighbourship) }
  end

  def destroy
    find_neighbourship.destroy!
    @place.content_changed!
    head :no_content
  end

  def order
    usernames = Array(params.require(:usernames)).map { it.to_s.downcase }
    Neighbourship.transaction do
      usernames.each_with_index do |username, position|
        @place.neighbourships.joins(:neighbour).where(neighbour: { username: }).update_all(position:)
      end
    end
    head :no_content
  end

  private
    def find_neighbourship
      @place.neighbourships.joins(:neighbour).find_by!(neighbour: { username: params[:username].to_s.downcase })
    end

    def card(neighbourship)
      PlaceCardSerializer.call(neighbourship.neighbour).merge(label: neighbourship.label)
    end
end
