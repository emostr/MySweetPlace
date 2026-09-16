def seed_place(username, profile:, theme:, blocks:, notes: [], avatar: nil)
  user = User.find_or_initialize_by(email_address: "#{username}@example.com")
  return user.place if user.persisted?

  user.update!(password: "password123")
  place = Place.new(user:, username:)
  place.assign_profile(profile)
  place.assign_theme(Place::Theme::SCHEMA.empty.deep_merge(theme.deep_stringify_keys))
  place.content_updated_at = Time.current
  place.save!
  place.avatar.attach(io: File.open(avatar), filename: File.basename(avatar)) if avatar && File.exist?(avatar)

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

niki = seed_place "niki",
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

alex = seed_place "alex",
  profile: {
    name: { ru: "Алексей", en: "Alex" },
    tagline: { ru: "Бэкенд-разработчик. Люблю Ruby, Linux и терминалы", en: "Backend developer. Into Ruby, Linux and terminals" },
    occupation: { ru: "Разработчик", en: "Developer" },
    location: { ru: "Пенза, Россия", en: "Penza, Russia" },
    status: { emoji: "🛠", text: { ru: "чиню прод", en: "fixing prod" } }
  },
  theme: { preset: "terminal", colors: { background: "#0b0f0b", surface: "#0f150f", text: "#b6f2ae", muted: "#5e9657", accent: "#39ff14", border: "#1f3a1c" }, font: "jetbrains-mono", heading_font: "press-start-2p", font_size: "small", background: { type: "pattern", pattern: "grid" }, cards: { style: "outline", radius: 0 } },
  blocks: [
    [ :intro ],
    [ :stack, { items: %w[ruby rubyonrails postgresql redis nginx docker linux debian neovim git go typescript svelte].map { { slug: it } } + [ { name: "1С", color: "#ffd200" } ] }, { variant: "badges" } ],
    [ :projects, { items: [
      { title: { ru: "MySweetPlace", en: "MySweetPlace" }, description: { ru: "Уютные местечки в интернете. Помогаю с бэкендом.", en: "Cozy places on the internet. Helping with the backend." }, status: "in_progress", started: "2026-09", repo: "https://github.com/emostr/MySweetPlace", stack: %w[ruby rubyonrails svelte postgresql] },
      { title: { ru: "dotfiles", en: "dotfiles" }, description: { ru: "Мои настройки neovim, tmux и zsh.", en: "My neovim, tmux and zsh setup." }, status: "done", started: "2019", stack: %w[neovim tmux zsh] }
    ] } ],
    [ :notes, { limit: 3 }, { width: "half" } ],
    [ :links, { items: [ { title: "GitHub", url: "https://github.com" }, { title: "Telegram", url: "https://t.me/example" }, { title: "Почта", url: "mailto:alex@example.com" } ] }, { variant: "list", width: "half" } ],
    [ :guestbook, { access: "members" } ],
    [ :neighbours ]
  ],
  notes: [ "Перевёл домашний сервер на Debian. Тишина и покой.", "`rm -rf node_modules` — лучшая медитация" ]

sasha = seed_place "sasha",
  profile: {
    name: { ru: "Саша", en: "Sasha" },
    tagline: { ru: "Пишу заметки, собираю пластинки, веду таймлайн жизни", en: "Writing notes, collecting records, keeping a life timeline" },
    location: { ru: "Санкт-Петербург", en: "Saint Petersburg" }
  },
  theme: { preset: "paper", colors: { background: "#f1e9da", surface: "#fbf7ef", text: "#3b3226", muted: "#857760", accent: "#9c4a1a", border: "#dccfb7" }, font: "lora", heading_font: "playfair-display", background: { type: "pattern", pattern: "lines" }, cards: { style: "outline", radius: 2 }, layout: { width: "narrow" } },
  blocks: [
    [ :intro ],
    [ :text, { body: { ru: "Это моё маленькое место: немного о жизни, немного о книгах и много о музыке. Спасибо, что заглянули!", en: "This is my little place: a bit about life, a bit about books and a lot about music. Thanks for stopping by!" } }, { variant: "plain", hide_title: true } ],
    [ :timeline, { items: [
      { date: "2015", emoji: "🎓", title: { ru: "Поступила в университет", en: "Started university" } },
      { date: "2019-06", emoji: "📚", title: { ru: "Написала первую статью", en: "Wrote my first article" } },
      { date: "2023-12-31", emoji: "🎄", title: { ru: "Переехала в Петербург", en: "Moved to Saint Petersburg" }, text: { ru: "Самый снежный Новый год", en: "The snowiest New Year" } },
      { date: Date.current.strftime("%Y-%m"), emoji: "🏡", title: { ru: "Обустроила местечко", en: "Settled into my place" } }
    ] } ],
    [ :interests, { items: [ { emoji: "📚", label: "книги" }, { emoji: "🎧", label: "музыка" }, { emoji: "🌿", label: "растения" } ] }, { variant: "list", width: "half" } ],
    [ :now, { text: { ru: "Читаю «Мастера и Маргариту» в третий раз.", en: "Reading “The Master and Margarita” for the third time." } }, { width: "half" } ],
    [ :guestbook, { premoderation: true } ],
    [ :neighbours ]
  ]

kate = seed_place "kate",
  profile: {
    name: { ru: "Катя", en: "Kate" },
    tagline: { ru: "Иллюстратор и дизайнер. Рисую котиков и интерфейсы", en: "Illustrator and designer. Drawing cats and interfaces" },
    occupation: { ru: "Дизайнер", en: "Designer" }
  },
  theme: { preset: "sakura", colors: { background: "#fbe7ee", surface: "#fffafb", text: "#4a2f38", muted: "#9a7482", accent: "#d2557f", border: "#f2cbd7" }, font: "nunito", heading_font: "comfortaa", background: { type: "pattern", pattern: "hearts" }, cards: { style: "classic", radius: 16 } },
  blocks: [
    [ :intro, {}, { variant: "center" } ],
    [ :links, { items: [ { title: "Behance", url: "https://behance.net/example" }, { title: "Dribbble", url: "https://dribbble.com/example" }, { title: "Telegram-канал", url: "https://t.me/example" } ] }, { variant: "buttons" } ],
    [ :stack, { items: %w[figma krita blender inkscape].map { { slug: it } } }, { variant: "icons" } ],
    [ :guestbook ],
    [ :neighbours ]
  ]

[ [ niki, [ alex, sasha, kate ] ], [ alex, [ niki, kate ] ], [ sasha, [ niki ] ], [ kate, [ niki, sasha ] ] ].each do |place, neighbours|
  neighbours.each { place.neighbourships.find_or_create_by!(neighbour: it) }
end

if niki.guestbook_entries.none?
  niki.guestbook_entries.create!(author_name: "гость", body: "уютно тут :)", pinned: true)
  niki.guestbook_entries.create!(author_place: kate, author_name: "kate", body: "классный проект!")
  niki.guestbook_entries.create!(author_place: alex, author_name: "alex", body: "Ники, спасибо за снег на страницах ❄️")
  sasha.guestbook_entries.create!(author_name: "путник", body: "Какой красивый таймлайн", status: "pending")
end

puts "Seeded #{Place.count} places. Sign in as niki@example.com / password123" unless Rails.env.test?
