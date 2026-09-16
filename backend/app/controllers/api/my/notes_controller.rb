class Api::My::NotesController < Api::My::BaseController
  before_action :set_note, only: %i[update destroy]

  def create
    note = @place.notes.create!(note_params)
    render json: { note: NoteSerializer.call(note) }, status: :created
  end

  def update
    previous_image_ids = @note.image_ids
    @note.update!(note_params)
    @place.uploads.where(id: previous_image_ids - @note.image_ids).destroy_all
    render json: { note: NoteSerializer.call(@note) }
  end

  def destroy
    @note.destroy!
    head :no_content
  end

  private
    def set_note
      @note = @place.notes.find(params[:id])
    end

    def note_params
      attributes = {}
      attributes[:body] = params[:body].to_s if params.key?(:body)
      attributes[:image_ids] = Array(params[:image_ids]) if params.key?(:image_ids)
      attributes[:pinned] = params[:pinned] if params.key?(:pinned)
      attributes
    end
end
