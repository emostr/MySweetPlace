class PlaceCardSerializer < ApplicationSerializer
  def self.many(places) = places.map { call(it) }

  def initialize(place)
    @place = place
  end

  def call
    {
      id: @place.id,
      username: @place.username,
      name: @place.profile.fetch("name", {}),
      tagline: @place.profile.fetch("tagline", {}),
      avatar_url: file_url(@place.avatar),
      accent: @place.theme.dig("colors", "accent"),
      background: @place.theme.dig("colors", "background"),
      updated_at: @place.content_updated_at
    }
  end
end
