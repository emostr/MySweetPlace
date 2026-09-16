class Api::GuestbookEntriesController < ApplicationController
  PER_PAGE = 20

  rate_limit to: 5, within: 10.minutes, only: :create, with: :too_many_requests

  before_action :set_place

  def index
    owner = Current.place&.id == @place.id
    scope = owner ? @place.guestbook_entries : @place.guestbook_entries.visible
    scope = scope.where(id: ...params[:before].to_i) if params[:before].present?
    entries = scope.order(id: :desc).includes(author_place: { avatar_attachment: :blob }).limit(PER_PAGE + 1).to_a

    render json: {
      items: GuestbookEntrySerializer.many(entries.first(PER_PAGE), viewer: Current.place, owner:),
      has_more: entries.size > PER_PAGE
    }
  end

  def create
    policy = GuestbookPolicy.new(@place, Current.place)
    return render_error(:forbidden, code: policy.denial_reason) unless policy.can_write?
    return render(json: { entry: nil }, status: :created) if params[:website].present?

    author = Current.place
    entry = @place.guestbook_entries.create!(
      author_place: author,
      author_name: author ? author.username : params[:author_name].to_s,
      body: params[:body].to_s,
      status: policy.premoderated? ? "pending" : "visible"
    )
    render json: { entry: GuestbookEntrySerializer.call(entry, viewer: author, owner: author&.id == @place.id) }, status: :created
  end

  def destroy
    entry = @place.guestbook_entries.find(params[:id])
    return render_error(:forbidden) unless Current.place && (entry.written_by?(Current.place) || Current.place.id == @place.id)

    entry.destroy!
    head :no_content
  end

  private
    def set_place
      @place = Place.find_active!(params[:place_username])
    end
end
