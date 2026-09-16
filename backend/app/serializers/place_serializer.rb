class PlaceSerializer < ApplicationSerializer
  def initialize(place, viewer: nil, blocks: true)
    @place = place
    @viewer = viewer
    @owner = viewer.present? && viewer.id == place.id
    @with_blocks = blocks
  end

  def call
    blocks = @with_blocks ? visible_blocks : []
    {
      id: @place.id,
      username: @place.username,
      profile: @place.profile,
      theme: @place.theme,
      settings: @place.settings,
      listed: @place.listed,
      avatar_url: file_url(@place.avatar),
      created_at: @place.created_at,
      updated_at: @place.content_updated_at,
      owner: @owner,
      neighbour: @viewer.present? && !@owner && @viewer.neighbourships.exists?(neighbour_id: @place.id),
      neighbour_of_count: @place.reverse_neighbourships.count,
      blocks: blocks.map { BlockSerializer.call(it, place: @place, viewer: @viewer, owner: @owner) },
      uploads: uploads(blocks)
    }
  end

  private
    def visible_blocks
      blocks = @place.blocks.to_a
      @owner ? blocks : blocks.select(&:visible)
    end

    def uploads(blocks)
      ids = blocks.flat_map { collect_ids(it.data) } << @place.theme.dig("background", "image_id")
      @place.uploads.with_attached_file.where(id: ids.compact.uniq).to_h { [ it.id, upload_json(it) ] }
    end

    def collect_ids(value)
      case value
      when Hash then value.flat_map { |key, item| key.to_s.match?(/\A(image|cover)_ids?\z/) ? Array(item) : collect_ids(item) }
      when Array then value.flat_map { collect_ids(it) }
      else []
      end
    end
end
