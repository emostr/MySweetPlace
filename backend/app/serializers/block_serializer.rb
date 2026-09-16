class BlockSerializer < ApplicationSerializer
  def initialize(block, place:, viewer:, owner:)
    @block = block
    @place = place
    @viewer = viewer
    @owner = owner
  end

  def call
    {
      id: @block.id,
      kind: @block.kind,
      position: @block.position,
      visible: @block.visible,
      title: @block.title,
      data: @block.data,
      style: @block.style,
      updated_at: @block.updated_at,
      content:
    }
  end

  private
    def content
      case @block.kind
      when "notes" then notes
      when "guestbook" then guestbook
      when "neighbours" then neighbours
      end
    end

    def notes
      scope = @place.notes
      { items: NoteSerializer.many(scope.feed.limit(@block.data["limit"] || 5)), total: scope.count }
    end

    def guestbook
      scope = @owner ? @place.guestbook_entries : @place.guestbook_entries.visible
      entries = scope.ordered.includes(author_place: { avatar_attachment: :blob }).limit(@block.data["limit"] || 10)
      {
        items: GuestbookEntrySerializer.many(entries, viewer: @viewer, owner: @owner),
        total: scope.count,
        can_write: GuestbookPolicy.new(@place, @viewer).can_write?,
        pending: @owner ? @place.guestbook_entries.pending.count : 0
      }
    end

    def neighbours
      neighbourships = @place.neighbourships.joins(:neighbour).merge(Place.active)
        .includes(neighbour: { avatar_attachment: :blob })
      { items: neighbourships.map { PlaceCardSerializer.call(it.neighbour).merge(label: it.label) } }
    end
end
