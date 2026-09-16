import { plural } from './plural';

const n = (count: number, forms: [string, string, string]) =>
	`${count} ${plural('ru', count, forms)}`;

export default {
	common: {
		save: 'Сохранить',
		saving: 'Сохраняю…',
		saved: 'Сохранено',
		cancel: 'Отмена',
		delete: 'Удалить',
		edit: 'Изменить',
		add: 'Добавить',
		remove: 'Убрать',
		close: 'Закрыть',
		back: 'Назад',
		more: 'Показать ещё',
		loading: 'Загрузка…',
		confirmDelete: 'Точно удалить?',
		up: 'Выше',
		down: 'Ниже',
		show: 'Показать',
		hide: 'Скрыть',
		pin: 'Закрепить',
		unpin: 'Открепить',
		optional: 'необязательно',
		error: 'Что-то пошло не так',
		network: 'Нет связи с сервером',
		upload: 'Загрузить',
		uploading: 'Загружаю…',
		replace: 'Заменить',
		open: 'Открыть',
		language: 'Язык',
		search: 'Поиск',
		unsaved: 'Есть несохранённые изменения',
		dragHint: 'Перетащите, чтобы поменять порядок',
		today: 'Сегодня'
	},
	site: {
		name: 'MySweetPlace',
		nav: {
			home: 'Главная',
			explore: 'Местечки',
			random: 'Куда-нибудь',
			about: 'О проекте',
			login: 'Войти',
			signup: 'Регистрация',
			myPlace: 'Моё местечко',
			edit: 'Обустроить',
			logout: 'Выйти'
		},
		takeMeSomewhere: 'Отправить меня куда-нибудь',
		footer: {
			source: 'Исходный код',
			license: 'Apache 2.0',
			toTop: 'Наверх ↑',
			rights: 'Уютные местечки в интернете'
		},
		mascotAlt: 'Ники слушает музыку, сидя на стопке дисков'
	},
	landing: {
		title: 'Добро пожаловать на MySweetPlace. Это ваше уютное местечко в интернете',
		lead: 'Спокойное пространство без лишнего шума: заметки, мысли, проекты и всё, к чему хочется возвращаться.',
		cta: 'Обустроить своё местечко',
		ctaMine: 'Перейти в своё местечко',
		features: [
			{
				title: 'Своё местечко',
				text: 'Страница по адресу mysweetplace.org/@username: о вас, ваших проектах, ссылках и увлечениях.'
			},
			{
				title: 'Обустраивайте как хочется',
				text: 'Фон, шрифты, цвета, карточки и порядок блоков. Местечко должно быть похоже на вас, а не на шаблон.'
			},
			{
				title: 'Соседи и гостевая книга',
				text: 'Вместо подписчиков — соседи. Вместо лайков — тёплые слова в гостевой книге.'
			}
		],
		newPlaces: 'Новые местечки',
		freshNotes: 'Свежие записи',
		quiet: 'Здесь пока тихо. Станьте первым жителем!',
		stats: (places: number, notes: number) =>
			`Уже ${n(places, ['местечко', 'местечка', 'местечек'])} и ${n(notes, ['запись', 'записи', 'записей'])}`
	},
	about: {
		title: 'О проекте',
		lead: 'MySweetPlace — персональное пространство в интернете, которое объединяет личную страницу, небольшой блог, портфолио, ссылки, интересы и тёплые социальные взаимодействия.',
		notSocial:
			'Это не соцсеть в привычном понимании и не конструктор сайтов. Идея проекта — дать человеку своё маленькое место в интернете, которое можно постепенно обустраивать, менять и наполнять своей жизнью.',
		principlesTitle: 'Принципы',
		principles: [
			{
				title: 'Местечко, а не профиль',
				text: 'У каждого есть своё пространство по адресу mysweetplace.org/@username. Его не заполняют, его обустраивают.'
			},
			{
				title: 'Кастомизация важнее шаблонов',
				text: 'Фон, шрифты, цвета, карточки, изображения и порядок блоков — каждое местечко должно ощущаться индивидуальным.'
			},
			{
				title: 'Соседи вместо подписчиков',
				text: 'Добавляйте в соседи местечки, которые вам близки. Соседство не обязано быть взаимным.'
			},
			{
				title: 'Без алгоритмов',
				text: 'Кнопка «Отправить меня куда-нибудь» просто открывает случайное местечко. Никаких рекомендаций и анализа интересов.'
			},
			{
				title: 'Сезоны',
				text: 'Зимой на страницах идёт лёгкий снег, а под Новый год появляются гирлянды.'
			}
		],
		openSourceTitle: 'Открытый код',
		openSource:
			'MySweetPlace развивается открыто под лицензией Apache 2.0. Исходный код, идеи и ошибки — на GitHub.'
	},
	auth: {
		loginTitle: 'Вход',
		loginLead: 'С возвращением домой.',
		email: 'Почта',
		password: 'Пароль',
		loginButton: 'Войти',
		noAccount: 'Ещё нет местечка?',
		createOne: 'Создать',
		forgot: 'Забыли пароль?',
		signupTitle: 'Новое местечко',
		signupLead: 'Пара полей — и у вас появится своё место в интернете.',
		username: 'Юзернейм',
		usernameHint: (username: string) =>
			`Латиница, цифры, _ и -. Адрес: mysweetplace.org/@${username || 'username'}`,
		passwordHint: 'Не меньше 8 символов',
		signupButton: 'Создать местечко',
		haveAccount: 'Уже есть местечко?',
		forgotTitle: 'Восстановление пароля',
		forgotLead: 'Укажите почту, и мы пришлём ссылку для нового пароля.',
		forgotButton: 'Прислать ссылку',
		forgotSent: 'Если такая почта у нас есть, письмо уже в пути.',
		resetTitle: 'Новый пароль',
		resetButton: 'Сохранить пароль',
		resetDone: 'Пароль обновлён, теперь можно войти.'
	},
	explore: {
		title: 'Местечки',
		lead: 'Все публичные местечки — от недавно обновлённых к давним. Без алгоритмов и рекомендаций.',
		search: 'Имя или юзернейм',
		interests: 'Интересы',
		all: 'Все',
		empty: 'Никого не нашлось',
		reset: 'Сбросить фильтры',
		interest: (label: string) => `Интерес: ${label}`
	},
	random: {
		empty: 'Пока некуда отправиться — других местечек ещё нет.'
	},
	place: {
		edit: 'Обустроить',
		addNeighbour: 'Добавить в соседи',
		isNeighbour: 'Вы соседи',
		removeNeighbour: 'Убрать из соседей',
		hiddenBlock: 'Скрытый блок — его видите только вы',
		emptyBlock: 'Блок пока пустой. Заполните его в редакторе.',
		neighbourOf: (count: number) =>
			`${n(count, ['местечко считает', 'местечка считают', 'местечек считают'])} это место соседним`,
		notFound: 'Такого местечка нет',
		notFoundText: 'Может, в адресе опечатка? Или отправьтесь куда-нибудь ещё.',
		updated: (date: string) => `обновлено ${date}`,
		neighboursOnly: 'Войдите, чтобы добавлять соседей'
	},
	blocks: {
		titles: {
			intro: 'Введение',
			links: 'Ссылки',
			projects: 'Проекты',
			notes: 'Записи',
			now: 'Сейчас',
			stack: 'Стек',
			interests: 'Интересы',
			music: 'Музыка',
			photos: 'Фото',
			guestbook: 'Гостевая книга',
			neighbours: 'Мой район',
			timeline: 'Таймлайн',
			text: 'Текст'
		},
		descriptions: {
			intro: 'Имя, аватар и пара слов о себе',
			links: 'Соцсети, сайты и всё, куда стоит заглянуть',
			projects: 'Личные проекты со статусами и стеком',
			notes: 'Микроблог: короткие записи, фото и код',
			now: 'Чем вы живёте прямо сейчас',
			stack: 'Языки, фреймворки и инструменты',
			interests: 'Увлечения — по ним вас найдут',
			music: 'Любимая музыка, текущий трек и плейлист',
			photos: 'Небольшая фотогалерея',
			guestbook: 'Место для тёплых слов от гостей',
			neighbours: 'Местечки, которые вам близки',
			timeline: 'Важные моменты вашей жизни',
			text: 'Свободный текст о чём угодно'
		},
		projects: {
			statuses: {
				in_progress: 'В работе',
				idea: 'Идея',
				done: 'Готов',
				paused: 'На паузе',
				archived: 'В архиве'
			},
			site: 'Сайт',
			repo: 'Код',
			present: 'по сей день'
		},
		notes: {
			all: (count: number) => `Все записи (${count})`,
			empty: 'Пока ни одной записи',
			pinned: 'Закреплено',
			permalink: 'Ссылка на запись'
		},
		now: {
			updated: (date: string) => `Обновлено ${date}`
		},
		music: {
			current: 'Сейчас играет',
			anthem: 'Песня в закрепе',
			artists: 'Любимые исполнители',
			albums: 'Любимые альбомы',
			playlist: 'Плейлист',
			listen: 'Слушать'
		},
		guestbook: {
			prompt: 'Оставьте пару тёплых слов :)',
			name: 'Ваше имя',
			message: 'Сообщение',
			send: 'Оставить запись',
			sending: 'Отправляю…',
			sent: 'Спасибо! Запись появилась в книге.',
			sentPending: 'Спасибо! Запись появится после проверки хозяином местечка.',
			closed: 'Гостевая книга закрыта',
			membersOnly: 'Писать здесь могут только жители MySweetPlace.',
			loginToWrite: 'Войти, чтобы написать',
			as: (username: string) => `Вы пишете как @${username}`,
			empty: 'Пока никто ничего не написал. Будьте первым!',
			statuses: { visible: 'Опубликована', pending: 'На проверке', hidden: 'Скрыта' },
			approve: 'Опубликовать',
			all: (count: number) => `Все записи (${count})`,
			pending: (count: number) =>
				n(count, ['запись ждёт', 'записи ждут', 'записей ждут']) + ' проверки'
		},
		neighbours: {
			empty: 'Соседей пока нет',
			emptyOwner: 'Добавляйте соседей кнопкой «Добавить в соседи» на их местечках.'
		}
	},
	notes: {
		placeholder: 'Что нового?',
		publish: 'Опубликовать',
		publishing: 'Публикую…',
		photos: 'Фото',
		markdown: 'Можно **жирный**, _курсив_, `код`, ссылки и ```блоки кода```',
		back: 'К местечку',
		deleteConfirm: 'Удалить запись?',
		tooManyImages: (max: number) => `Не больше ${max} фото`,
		title: (username: string) => `Запись @${username}`
	},
	stack: {
		categories: {
			languages: 'Языки',
			frontend: 'Фронтенд',
			backend: 'Бэкенд',
			mobile: 'Мобильная разработка',
			desktop: 'Десктоп',
			gamedev: 'Геймдев',
			databases: 'Базы данных',
			devops: 'DevOps и облака',
			os: 'Операционные системы',
			editors: 'Редакторы и IDE',
			tools: 'Инструменты',
			testing: 'Тестирование',
			data: 'Данные и ML',
			design: 'Дизайн',
			hardware: 'Железо',
			other: 'Другое'
		}
	},
	editor: {
		title: 'Обустройство',
		view: 'Посмотреть местечко',
		preview: 'Предпросмотр',
		tabs: {
			blocks: 'Блоки',
			profile: 'Введение',
			appearance: 'Оформление',
			notes: 'Записи',
			guestbook: 'Гостевая',
			neighbours: 'Соседи',
			settings: 'Настройки'
		},
		blocks: {
			add: 'Добавить блок',
			choose: 'Какой блок добавить?',
			already: 'уже есть',
			visible: 'Показан',
			hidden: 'Скрыт',
			delete: 'Удалить блок',
			deleteConfirm: (title: string) => `Удалить блок «${title}»? Его содержимое пропадёт.`,
			title: 'Заголовок',
			titlePlaceholder: (title: string) => `По умолчанию: ${title}`,
			hideTitle: 'Не показывать заголовок',
			width: 'Ширина',
			widths: { full: 'Во всю ширину', half: 'Половина' },
			variant: 'Вид',
			accent: 'Свой акцентный цвет',
			look: 'Внешний вид',
			content: 'Содержимое',
			variants: {
				side: 'Аватар сбоку',
				center: 'По центру',
				list: 'Списком',
				buttons: 'Кнопками',
				icons: 'Иконками',
				cards: 'Карточками',
				feed: 'Лентой',
				compact: 'Компактно',
				card: 'Карточкой',
				badges: 'Значками',
				grouped: 'По категориям',
				tags: 'Тегами',
				grid: 'Сеткой',
				polaroid: 'Полароидами',
				district: 'Районом',
				plain: 'Без рамки',
				default: 'Обычный'
			} as Record<string, string>
		},
		forms: {
			introHint: 'Имя, аватар и остальное заполняются во вкладке «Введение».',
			linkTitle: 'Название',
			linkUrl: 'Адрес',
			addLink: 'Добавить ссылку',
			addProject: 'Добавить проект',
			projectTitle: 'Название',
			projectDescription: 'Описание',
			projectStatus: 'Статус',
			projectStarted: 'Начало',
			projectFinished: 'Окончание',
			projectUrl: 'Сайт',
			projectRepo: 'Репозиторий',
			projectStack: 'Стек проекта',
			projectStackHint: 'Через запятую: ruby, rails, svelte',
			projectImages: 'Изображения',
			projectMeta: 'Дополнительно',
			metaKey: 'Поле',
			metaValue: 'Значение',
			addMeta: 'Добавить поле',
			monthHint: 'ГГГГ или ГГГГ-ММ',
			notesLimit: 'Сколько записей показывать',
			notesHint: 'Сами записи пишутся во вкладке «Записи» или прямо на странице местечка.',
			nowText: 'Пара слов о текущем',
			nowItems: 'Пункты',
			emoji: 'Эмодзи',
			text: 'Текст',
			addItem: 'Добавить пункт',
			updatedOn: 'Дата обновления',
			stackSearch: 'Найти технологию',
			stackSelected: (count: number) => `Выбрано: ${count}`,
			stackCustom: 'Своя технология',
			stackCustomName: 'Название',
			stackCustomColor: 'Цвет',
			stackNothing: 'Ничего не нашлось — добавьте свою',
			interestLabel: 'Интерес',
			interestPlaceholder: 'музыка, походы, пиксель-арт…',
			addInterest: 'Добавить интерес',
			trackTitle: 'Название',
			trackArtist: 'Исполнитель',
			trackUrl: 'Ссылка',
			musicCurrent: 'Сейчас играет',
			musicAnthem: 'Самая любимая песня (в закреп)',
			musicArtists: 'Любимые исполнители',
			musicArtistsHint: 'По одному на строку',
			musicAlbums: 'Любимые альбомы',
			albumTitle: 'Альбом',
			albumYear: 'Год',
			albumCover: 'Обложка',
			addAlbum: 'Добавить альбом',
			playlistTitle: 'Название плейлиста',
			playlistUrl: 'Ссылка на плейлист',
			playlistHint: 'Яндекс Музыка, Spotify, SoundCloud, YouTube или Apple Music — покажем плеер',
			addPhotos: 'Добавить фото',
			caption: 'Подпись',
			guestbookAccess: 'Кто может писать',
			guestbookAccessOptions: {
				everyone: 'Все, включая гостей',
				members: 'Только жители MySweetPlace',
				nobody: 'Никто — книга закрыта'
			},
			guestbookPremoderation: 'Показывать новые записи только после моей проверки',
			guestbookPrompt: 'Приглашение над формой',
			guestbookLimit: 'Сколько записей показывать',
			neighboursHint: 'Список соседей редактируется во вкладке «Соседи».',
			timelineOrder: 'Порядок',
			timelineOrders: { desc: 'Сначала новые', asc: 'Сначала старые' },
			timelineDate: 'Дата',
			timelineDateHint: 'ГГГГ, ГГГГ-ММ или ГГГГ-ММ-ДД',
			timelineTitle: 'Событие',
			addMoment: 'Добавить момент',
			textBody: 'Текст'
		},
		localized: {
			addEnglish: 'Добавить английскую версию',
			english: 'English'
		},
		profile: {
			avatar: 'Аватар',
			uploadAvatar: 'Загрузить аватар',
			removeAvatar: 'Убрать',
			name: 'Имя',
			tagline: 'Короткое описание',
			occupation: 'Род занятий',
			location: 'Местоположение',
			status: 'Статус',
			statusEmoji: 'Эмодзи',
			statusText: 'Текст статуса',
			about: 'О себе',
			username: 'Юзернейм',
			usernameHint: 'Если поменять юзернейм, старые ссылки на местечко перестанут работать.'
		},
		appearance: {
			presets: 'Готовые темы',
			presetNames: {
				classic: 'Классика',
				night: 'Ночь',
				paper: 'Бумага',
				sakura: 'Сакура',
				forest: 'Лес',
				ocean: 'Море',
				terminal: 'Терминал',
				lilac: 'Сирень',
				cocoa: 'Какао',
				mono: 'Монохром'
			},
			colors: 'Цвета',
			colorNames: {
				background: 'Фон',
				surface: 'Карточки',
				text: 'Текст',
				muted: 'Второстепенный текст',
				accent: 'Акцент',
				border: 'Рамки'
			},
			fonts: 'Шрифты',
			font: 'Основной текст',
			headingFont: 'Заголовки',
			fontSize: 'Размер текста',
			fontSizes: { small: 'Мелкий', normal: 'Обычный', large: 'Крупный' },
			fontGroups: {
				system: 'Системные',
				serif: 'С засечками',
				sans: 'Без засечек',
				mono: 'Моноширинные',
				display: 'Характерные'
			},
			background: 'Фон страницы',
			backgroundTypes: { color: 'Цвет', gradient: 'Градиент', pattern: 'Узор', image: 'Картинка' },
			color2: 'Второй цвет',
			angle: 'Угол',
			pattern: 'Узор',
			patternNames: {
				none: 'Без узора',
				dots: 'Горошек',
				grid: 'Клетка',
				lines: 'Линейка',
				diagonal: 'Диагональ',
				checkers: 'Шахматка',
				hearts: 'Сердечки',
				stars: 'Звёздочки',
				waves: 'Волны',
				crosses: 'Крестики'
			},
			image: 'Картинка',
			imageModes: { cover: 'Растянуть', tile: 'Плиткой', fixed: 'Закрепить' },
			cards: 'Карточки',
			cardStyles: {
				classic: 'Классика',
				flat: 'Плоские',
				outline: 'Контур',
				glass: 'Стекло',
				retro: 'Ретро',
				none: 'Без карточек'
			},
			radius: 'Скругление',
			layout: 'Ширина страницы',
			widths: { narrow: 'Узкая', normal: 'Обычная', wide: 'Широкая' },
			customCss: 'Свой CSS для продвинутых жителей появится позже.'
		},
		notes: {
			title: 'Записи',
			empty: 'Записей пока нет. Напишите первую!'
		},
		guestbook: {
			title: 'Гостевая книга',
			filters: { all: 'Все', visible: 'Опубликованные', pending: 'На проверке', hidden: 'Скрытые' },
			empty: 'Здесь пусто',
			settingsHint: 'Кто может писать и нужна ли проверка — в настройках блока «Гостевая книга».'
		},
		neighbours: {
			title: 'Соседи',
			add: 'Добавить',
			addPlaceholder: 'username',
			label: 'Подпись',
			labelPlaceholder: 'например, «друг с работы»',
			empty: 'Соседей пока нет. Добавьте кого-нибудь по юзернейму или кнопкой на их местечке.',
			neighbourOf: 'Считают вас соседом',
			nobody: 'Пока никто'
		},
		settings: {
			visibility: 'Видимость',
			listed: 'Показывать местечко в списке местечек и в случайных путешествиях',
			noindex: 'Просить поисковики не индексировать местечко',
			account: 'Аккаунт',
			email: 'Почта',
			language: 'Язык писем',
			newPassword: 'Новый пароль',
			currentPassword: 'Текущий пароль',
			changeEmail: 'Сменить почту',
			changePassword: 'Сменить пароль',
			passwordChanged: 'Пароль обновлён',
			logout: 'Выйти',
			danger: 'Опасная зона',
			deleteAccount: 'Удалить местечко и аккаунт',
			deleteText:
				'Это навсегда: записи, фото, гостевая книга и соседи пропадут. Введите пароль, чтобы подтвердить.'
		}
	},
	season: {
		snowOn: 'Включить снег',
		snowOff: 'Выключить снег'
	},
	errors: {
		notFound: 'Здесь ничего нет',
		notFoundText: 'Кажется, такой страницы не существует. Может, отправиться куда-нибудь ещё?',
		server: 'Что-то сломалось',
		serverText: 'Мы уже чиним. Попробуйте обновить страницу чуть позже.',
		home: 'На главную'
	}
};
