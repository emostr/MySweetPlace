class Place
  module Theme
    S = Schema

    PRESETS = %w[classic night paper sakura forest ocean terminal lilac cocoa mono].freeze

    FONTS = %w[
      georgia arial verdana trebuchet times courier system
      pt-serif pt-sans pt-mono lora merriweather playfair-display eb-garamond cormorant literata
      rubik nunito montserrat golos-text manrope unbounded comfortaa
      jetbrains-mono ibm-plex-mono fira-code
      caveat neucha marck-script amatic-sc lobster yeseva-one press-start-2p pixelify-sans
    ].freeze

    PATTERNS = %w[none dots grid lines diagonal checkers hearts stars waves crosses].freeze
    CARD_STYLES = %w[classic flat outline glass retro none].freeze

    SCHEMA = S.object(
      preset: S.enum(PRESETS),
      colors: S.object(
        background: S.color(default: "#e6e7e9"),
        surface: S.color(default: "#ffffff"),
        text: S.color(default: "#333333"),
        muted: S.color(default: "#6b6f76"),
        accent: S.color(default: "#7a2531"),
        border: S.color(default: "#dcdde0")
      ),
      font: S.enum(FONTS, default: "arial"),
      heading_font: S.enum(FONTS, default: "georgia"),
      font_size: S.enum(%w[normal small large]),
      background: S.object(
        {
          type: S.enum(%w[color gradient pattern image]),
          color2: S.color(default: "#c9ccd1"),
          angle: S.integer(min: 0, max: 360, default: 180),
          pattern: S.enum(PATTERNS),
          image_id: S.upload,
          image_mode: S.enum(%w[cover tile fixed])
        },
        validate: ->(background, path, ctx) {
          ctx.error(path + [ "image_id" ], :blank) if background["type"] == "image" && background["image_id"].nil?
        }
      ),
      cards: S.object(
        style: S.enum(CARD_STYLES),
        radius: S.integer(min: 0, max: 28, default: 4)
      ),
      layout: S.object(
        width: S.enum(%w[normal narrow wide])
      )
    )

    SETTINGS = S.object(
      noindex: S.boolean
    )
  end
end
