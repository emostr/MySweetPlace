class NoteSerializer < ApplicationSerializer
  def self.many(notes, with_place: false)
    notes = notes.to_a
    uploads = Upload.with_attached_file.where(id: notes.flat_map(&:image_ids)).index_by(&:id)
    notes.map { new(it, uploads:, with_place:).call }
  end

  def initialize(note, uploads: nil, with_place: false)
    @note = note
    @uploads = uploads || Upload.with_attached_file.where(id: note.image_ids).index_by(&:id)
    @with_place = with_place
  end

  def call
    json = {
      id: @note.id,
      body: @note.body,
      body_html: @note.body_html,
      pinned: @note.pinned,
      images: @uploads.values_at(*@note.image_ids).compact.map { upload_json(it) },
      created_at: @note.created_at,
      updated_at: @note.updated_at
    }
    json[:place] = PlaceCardSerializer.call(@note.place) if @with_place
    json
  end
end
