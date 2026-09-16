class Block
  module Kinds
    S = Schema

    Kind = Data.define(:singleton, :variants, :data) do
      def style
        S.object(
          variant: S.enum(variants),
          width: S.enum(%w[full half]),
          hide_title: S.boolean,
          accent: S.color
        )
      end
    end

    STACK_SLUG = /\A[a-z0-9][a-z0-9_.+-]{0,59}\z/
    TRACK = S.object(title: S.string(max: 120), artist: S.string(max: 120), url: S.url)

    ALL = {
      "intro" => Kind.new(singleton: true, variants: %w[side center], data: S.object),

      "links" => Kind.new(singleton: false, variants: %w[list buttons icons], data: S.object(
        items: S.array(max: 50, of: S.object({
          title: S.string(max: 80),
          url: S.url(schemes: %w[http https mailto], required: true)
        }, id: true))
      )),

      "projects" => Kind.new(singleton: false, variants: %w[cards list], data: S.object(
        items: S.array(max: 30, of: S.object({
          title: S.localized(max: 80, required: true),
          description: S.localized(max: 600, multiline: true),
          status: S.enum(%w[in_progress idea done paused archived]),
          started: S.date(precision: %i[year month]),
          finished: S.date(precision: %i[year month]),
          url: S.url,
          repo: S.url,
          stack: S.array(max: 20, of: S.string(max: 40)),
          image_ids: S.array(max: 6, of: S.upload),
          meta: S.array(max: 10, of: S.object(key: S.string(max: 40), value: S.string(max: 160)))
        }, id: true))
      )),

      "notes" => Kind.new(singleton: true, variants: %w[feed compact], data: S.object(
        limit: S.integer(min: 1, max: 20, default: 5)
      )),

      "now" => Kind.new(singleton: true, variants: %w[list card], data: S.object(
        text: S.localized(max: 1000, multiline: true),
        items: S.array(max: 12, of: S.object({ emoji: S.string(max: 16), text: S.localized(max: 160) }, id: true)),
        updated_on: S.date(precision: :day)
      )),

      "stack" => Kind.new(singleton: true, variants: %w[badges icons grouped], data: S.object(
        items: S.array(max: 150, of: S.object(
          { slug: S.string(max: 60, format: STACK_SLUG), name: S.string(max: 40), color: S.color },
          id: true,
          validate: ->(item, path, ctx) { ctx.error(path + [ "name" ], :blank) if item["slug"].blank? && item["name"].blank? }
        ))
      )),

      "interests" => Kind.new(singleton: true, variants: %w[tags list], data: S.object(
        items: S.array(max: 50, of: S.object({ emoji: S.string(max: 16), label: S.string(max: 40, required: true) }, id: true))
      )),

      "music" => Kind.new(singleton: true, variants: %w[default], data: S.object(
        current: TRACK,
        anthem: TRACK,
        artists: S.array(max: 30, of: S.string(max: 80)),
        albums: S.array(max: 12, of: S.object({
          title: S.string(max: 120, required: true),
          artist: S.string(max: 120),
          year: S.date(precision: :year),
          cover_id: S.upload,
          url: S.url
        }, id: true)),
        playlist: S.object(title: S.string(max: 120), url: S.url)
      )),

      "photos" => Kind.new(singleton: false, variants: %w[grid polaroid], data: S.object(
        items: S.array(max: 30, of: S.object({ image_id: S.upload(required: true), caption: S.localized(max: 140) }, id: true))
      )),

      "guestbook" => Kind.new(singleton: true, variants: %w[default], data: S.object(
        access: S.enum(%w[everyone members nobody]),
        premoderation: S.boolean,
        prompt: S.localized(max: 140),
        limit: S.integer(min: 1, max: 50, default: 10)
      )),

      "neighbours" => Kind.new(singleton: true, variants: %w[list district], data: S.object),

      "timeline" => Kind.new(singleton: true, variants: %w[default], data: S.object(
        order: S.enum(%w[desc asc]),
        items: S.array(max: 100, of: S.object({
          date: S.date(required: true),
          emoji: S.string(max: 16),
          title: S.localized(max: 120, required: true),
          text: S.localized(max: 500, multiline: true)
        }, id: true))
      )),

      "text" => Kind.new(singleton: false, variants: %w[card plain], data: S.object(
        body: S.localized(max: 5000, multiline: true)
      ))
    }.freeze

    def self.[](name) = ALL.fetch(name.to_s)
    def self.names = ALL.keys
  end
end
