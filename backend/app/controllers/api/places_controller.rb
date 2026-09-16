class Api::PlacesController < ApplicationController
  PER_PAGE = 24

  def index
    scope = Place.discoverable.with_attached_avatar
    scope = scope.with_interest(params[:interest]) if params[:interest].present?
    if params[:q].present?
      query = "%#{Place.sanitize_sql_like(params[:q].to_s.strip)}%"
      scope = scope.where("places.username ILIKE :query OR places.profile->'name'->>'ru' ILIKE :query OR places.profile->'name'->>'en' ILIKE :query", query:)
    end

    page = [ params[:page].to_i, 1 ].max
    places = scope.order(content_updated_at: :desc, id: :desc).offset((page - 1) * PER_PAGE).limit(PER_PAGE + 1).to_a
    render json: { items: PlaceCardSerializer.many(places.first(PER_PAGE)), page:, has_more: places.size > PER_PAGE }
  end

  def show
    place = Place.active.includes(:blocks).with_attached_avatar.find_by!(username: params[:username].to_s.downcase)
    render json: PlaceSerializer.call(place, viewer: Current.place, blocks: params[:shell].blank?)
  end

  def random
    scope = Place.discoverable
    scope = scope.where.not(id: Current.place.id) if Current.place
    scope = scope.where.not(username: params[:except].to_s.downcase) if params[:except].present?
    place = scope.order(Arel.sql("RANDOM()")).first
    place ? render(json: { username: place.username }) : render_error(:not_found)
  end
end
