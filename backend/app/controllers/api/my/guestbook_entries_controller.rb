class Api::My::GuestbookEntriesController < Api::My::BaseController
  PER_PAGE = 30

  before_action :set_entry, only: %i[update destroy]

  def index
    scope = @place.guestbook_entries
    scope = scope.where(status: params[:status]) if GuestbookEntry.statuses.key?(params[:status])
    scope = scope.where(id: ...params[:before].to_i) if params[:before].present?
    entries = scope.order(id: :desc).includes(author_place: { avatar_attachment: :blob }).limit(PER_PAGE + 1).to_a

    render json: {
      items: GuestbookEntrySerializer.many(entries.first(PER_PAGE), viewer: @place, owner: true),
      has_more: entries.size > PER_PAGE,
      counts: @place.guestbook_entries.group(:status).count
    }
  end

  def update
    @entry.update!(params.permit(:status, :pinned))
    render json: { entry: GuestbookEntrySerializer.call(@entry, viewer: @place, owner: true) }
  rescue ArgumentError
    render_invalid(status: [ I18n.t("errors.messages.inclusion") ])
  end

  def destroy
    @entry.destroy!
    head :no_content
  end

  private
    def set_entry
      @entry = @place.guestbook_entries.find(params[:id])
    end
end
