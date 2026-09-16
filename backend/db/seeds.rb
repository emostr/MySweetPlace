# db:prepare loads this file on the first deployment. Keep only the mascot here.
def seed_place(username, profile:, theme:, blocks:, notes: [], avatar: nil)
  user = User.find_or_initialize_by(email_address: "#{username}@example.com")
  return user.place if user.persisted?

  password = if Rails.env.production?
    ENV["NIKI_PASSWORD"].presence || SecureRandom.hex(32)
  else
    "password123"
  end
  user.update!(password:)
  place = Place.new(user:, username:)
  place.assign_profile(profile)
  place.assign_theme(Place::Theme::SCHEMA.empty.deep_merge(theme.deep_stringify_keys))
  place.content_updated_at = Time.current
  place.save!
  if avatar && File.exist?(avatar)
    place.avatar.attach(io: StringIO.new(File.binread(avatar)), filename: File.basename(avatar))
  end

  place.blocks.delete_all
  blocks.each_with_index do |(kind, data, style), position|
    block = place.blocks.new(kind: kind.to_s, position:)
    block.assign_title({})
    block.assign_data(data || {})
    block.assign_style(style || {})
    block.save!
  end
  place.refresh_interests!

  notes.each_with_index do |body, index|
    place.notes.create!(body:, created_at: (index * 26 + 3).hours.ago)
  end
  place
end

ActiveRecord::Base.transaction do
  seed_place "niki",
    avatar: Rails.root.join("../frontend/static/images/niki.png"),
    profile: {
      name: { ru: "Ники", en: "Niki" },
      tagline: { ru: "Маскот MySweetPlace. Слушаю музыку, сидя на стопке дисков", en: "MySweetPlace mascot. Listening to music on a stack of CDs" },
      occupation: { ru: "Хранитель уюта", en: "Keeper of coziness" },
      location: { ru: "Где-то между сервером и облаком", en: "Somewhere between a server and a cloud" },
      status: { emoji: "🎧", text: { ru: "слушаю музыку", en: "listening to music" } },
      about: { ru: "Привет! Я живу здесь с самого первого коммита. Заглядывайте в гостевую книгу и отправляйтесь куда-нибудь — вдруг найдёте соседей.", en: "Hi! I've lived here since the very first commit. Sign the guestbook and take a trip somewhere — maybe you'll find neighbours." }
    },
    theme: { preset: "lilac", colors: { background: "#e8e2f5", surface: "#faf8fe", text: "#3a3150", muted: "#827a99", accent: "#7453c2", border: "#3a3150" }, font: "manrope", heading_font: "unbounded", background: { type: "pattern", pattern: "dots" }, cards: { style: "retro", radius: 10 } },
    blocks: [
      [ :intro, {}, { variant: "center" } ],
      [ :now, { items: [ { emoji: "💿", text: { ru: "Разбираю стопку старых дисков", en: "Sorting an old stack of CDs" } }, { emoji: "🧣", text: { ru: "Готовлюсь к зиме и снегу на страницах", en: "Getting ready for winter and snow on the pages" } } ], updated_on: Date.current.iso8601 }, { width: "half" } ],
      [ :music, { current: { title: "Тёплый ламповый шум", artist: "Облака над городом" }, anthem: { title: "Песня про уютное местечко", artist: "Ники" }, artists: [ "Облака над городом", "Кассетный дождь", "Soft Static" ] }, { width: "half" } ],
      [ :notes, { limit: 5 } ],
      [ :interests, { items: [ { emoji: "🎧", label: "музыка" }, { emoji: "💿", label: "диски" }, { emoji: "👾", label: "пиксель-арт" }, { emoji: "☕", label: "чай" } ] }, { width: "half" } ],
      [ :links, { items: [ { title: "Исходный код MySweetPlace", url: "https://github.com/emostr/MySweetPlace" } ] }, { width: "half" } ],
      [ :guestbook, { access: "everyone" } ],
      [ :neighbours, {}, { variant: "district" } ]
    ],
    notes: [
      "сегодня первый снег :)",
      "наконец нормально настроил **nginx**\nненавижу nginx",
      "Небольшой сниппет, чтобы проверить подсветку:\n\n```ruby\nplace = Place.find_by(username: \"niki\")\nplace.neighbours.each { puts \"привет, @\#{it.username}!\" }\n```",
      "Если долго не знаете, куда пойти, — нажмите «Отправить меня куда-нибудь». Никаких алгоритмов, только случай."
    ]
end

unless Rails.env.test?
  puts "Mascot @niki is ready."
  puts "Development login: niki@example.com / password123" unless Rails.env.production?
end
