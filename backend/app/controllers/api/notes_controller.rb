class Api::NotesController < ApplicationController
  PER_PAGE = 20

  before_action :set_place

  def index
    scope = @place.notes.order(id: :desc)
    scope = scope.where(id: ...params[:before].to_i) if params[:before].present?
    notes = scope.limit(PER_PAGE + 1).to_a
    render json: { items: NoteSerializer.many(notes.first(PER_PAGE)), has_more: notes.size > PER_PAGE }
  end

  def show
    note = @place.notes.find(params[:id])
    render json: { note: NoteSerializer.call(note), place: PlaceSerializer.call(@place, viewer: Current.place, blocks: false) }
  end

  private
    def set_place
      @place = Place.find_active!(params[:place_username])
      owner = Current.place&.id == @place.id
      raise ActiveRecord::RecordNotFound unless owner || @place.blocks.exists?(kind: "notes", visible: true)
    end
end
