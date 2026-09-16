class GuestbookPolicy
  def initialize(place, viewer)
    @place = place
    @viewer = viewer
    @block = place.guestbook_block
  end

  def can_write? = denial_reason.nil?

  def denial_reason
    return :guestbook_closed if @block.nil? || !@block.visible || @block.data["access"] == "nobody"
    :guestbook_members_only if @block.data["access"] == "members" && @viewer.nil?
  end

  def premoderated? = @block.data["premoderation"] && @viewer != @place
end
