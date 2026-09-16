class GuestbookEntrySerializer < ApplicationSerializer
  def self.many(entries, viewer:, owner:) = entries.map { call(it, viewer:, owner:) }

  def initialize(entry, viewer:, owner:)
    @entry = entry
    @viewer = viewer
    @owner = owner
  end

  def call
    author = @entry.author_place
    {
      id: @entry.id,
      body: @entry.body,
      status: @entry.status,
      pinned: @entry.pinned,
      created_at: @entry.created_at,
      author: {
        name: author ? author.display_name : @entry.author_name,
        username: author&.username,
        avatar_url: author && file_url(author.avatar)
      },
      can_delete: @owner || @entry.written_by?(@viewer)
    }
  end
end
