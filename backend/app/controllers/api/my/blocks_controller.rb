class Api::My::BlocksController < Api::My::BaseController
  before_action :set_block, only: %i[update destroy]

  def create
    block = @place.blocks.new(kind: params.require(:kind).to_s, position: (@place.blocks.maximum(:position) || -1) + 1)
    block.visible = params[:visible] if params.key?(:visible)
    if Block::Kinds.names.include?(block.kind)
      block.assign_title(params[:title])
      block.assign_data(params[:data])
      block.assign_style(params[:style])
    end
    block.save!
    @place.content_changed!
    render json: { block_id: block.id, place: PlaceSerializer.call(@place.reload, viewer: @place) }, status: :created
  end

  def update
    @block.visible = params[:visible] if params.key?(:visible)
    @block.assign_title(params[:title]) if params.key?(:title)
    @block.assign_data(params[:data]) if params.key?(:data)
    @block.assign_style(params[:style]) if params.key?(:style)
    @block.save!
    @place.content_changed!
    render_place
  end

  def destroy
    @block.destroy!
    @place.content_changed!
    render_place
  end

  def order
    ids = Array(params.require(:ids)).map(&:to_i)
    Block.transaction do
      ids.each_with_index { |id, position| @place.blocks.where(id:).update_all(position:) }
    end
    render_place
  end

  private
    def set_block
      @block = @place.blocks.find(params[:id])
    end
end
