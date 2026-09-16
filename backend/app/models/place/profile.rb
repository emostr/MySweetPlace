class Place
  module Profile
    S = Schema

    SCHEMA = S.object(
      name: S.localized(max: 60),
      tagline: S.localized(max: 140),
      occupation: S.localized(max: 80),
      location: S.localized(max: 80),
      status: S.object(emoji: S.string(max: 16), text: S.localized(max: 80)),
      about: S.localized(max: 1000, multiline: true)
    )
  end
end
