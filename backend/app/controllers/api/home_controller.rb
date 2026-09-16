class Api::HomeController < ApplicationController
  def show
    places = Place.discoverable.with_attached_avatar.order(created_at: :desc).limit(8)
    notes = Note.joins(place: :blocks).merge(Place.listed)
      .where(blocks: { kind: "notes", visible: true })
      .includes(place: { avatar_attachment: :blob })
      .order(created_at: :desc).limit(6)

    render json: {
      places: PlaceCardSerializer.many(places),
      notes: NoteSerializer.many(notes, with_place: true),
      stats: { places: Place.active.count, notes: Note.count }
    }
  end
end
