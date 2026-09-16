import type { Messages } from '$lib/i18n';
import { plural } from './plural';

const n = (count: number, forms: [string, string, string]) =>
	`${count} ${plural('en', count, forms)}`;

const en: Messages = {
	common: {
		save: 'Save',
		saving: 'Saving…',
		saved: 'Saved',
		cancel: 'Cancel',
		delete: 'Delete',
		edit: 'Edit',
		add: 'Add',
		remove: 'Remove',
		close: 'Close',
		back: 'Back',
		more: 'Show more',
		loading: 'Loading…',
		confirmDelete: 'Delete for sure?',
		up: 'Move up',
		down: 'Move down',
		show: 'Show',
		hide: 'Hide',
		pin: 'Pin',
		unpin: 'Unpin',
		optional: 'optional',
		error: 'Something went wrong',
		network: 'Can’t reach the server',
		upload: 'Upload',
		uploading: 'Uploading…',
		replace: 'Replace',
		open: 'Open',
		language: 'Language',
		search: 'Search',
		unsaved: 'You have unsaved changes',
		dragHint: 'Drag to reorder',
		today: 'Today'
	},
	site: {
		name: 'MySweetPlace',
		nav: {
			home: 'Home',
			explore: 'Places',
			random: 'Somewhere',
			about: 'About',
			login: 'Sign in',
			signup: 'Sign up',
			myPlace: 'My place',
			edit: 'Decorate',
			logout: 'Sign out'
		},
		takeMeSomewhere: 'Take me somewhere',
		footer: {
			source: 'Source code',
			license: 'Apache 2.0',
			toTop: 'Back to top ↑',
			rights: 'Cozy little places on the internet'
		},
		mascotAlt: 'Niki listening to music on a stack of CDs'
	},
	landing: {
		title: 'Welcome to MySweetPlace. This is your cozy little place on the internet',
		lead: 'A calm space without the noise: notes, thoughts, projects and everything you want to come back to.',
		cta: 'Make your own place',
		ctaMine: 'Go to my place',
		features: [
			{
				title: 'A place of your own',
				text: 'A page at mysweetplace.org/@username: about you, your projects, links and interests.'
			},
			{
				title: 'Decorate it your way',
				text: 'Background, fonts, colors, cards and block order. Your place should look like you, not like a template.'
			},
			{
				title: 'Neighbours and a guestbook',
				text: 'Neighbours instead of followers. Kind words in a guestbook instead of likes.'
			}
		],
		newPlaces: 'New places',
		freshNotes: 'Fresh notes',
		quiet: 'It’s quiet here for now. Become the first resident!',
		stats: (places: number, notes: number) =>
			`${n(places, ['place', 'places', 'places'])} and ${n(notes, ['note', 'notes', 'notes'])} already`
	},
	about: {
		title: 'About',
		lead: 'MySweetPlace is a personal space on the internet that brings together a home page, a small blog, a portfolio, links, interests and warm social interactions.',
		notSocial:
			'It is not a social network in the usual sense and not a website builder. The idea is to give everyone a small place on the internet that they can slowly decorate, change and fill with their life.',
		principlesTitle: 'Principles',
		principles: [
			{
				title: 'A place, not a profile',
				text: 'Everyone gets their own space at mysweetplace.org/@username. You don’t fill it in, you settle in.'
			},
			{
				title: 'Customization over templates',
				text: 'Background, fonts, colors, cards, images and block order — every place should feel personal.'
			},
			{
				title: 'Neighbours instead of followers',
				text: 'Add places you feel close to as your neighbours. It doesn’t have to be mutual.'
			},
			{
				title: 'No algorithms',
				text: 'The “Take me somewhere” button just opens a random place. No recommendations, no interest tracking.'
			},
			{
				title: 'Seasons',
				text: 'In winter light snow falls on the pages, and garlands show up around New Year.'
			}
		],
		openSourceTitle: 'Open source',
		openSource:
			'MySweetPlace is developed in the open under the Apache 2.0 license. Source code, ideas and bugs live on GitHub.'
	},
	auth: {
		loginTitle: 'Sign in',
		loginLead: 'Welcome back home.',
		email: 'Email',
		password: 'Password',
		loginButton: 'Sign in',
		noAccount: 'No place yet?',
		createOne: 'Create one',
		forgot: 'Forgot your password?',
		signupTitle: 'A new place',
		signupLead: 'A couple of fields and you’ll have your own place on the internet.',
		username: 'Username',
		usernameHint: (username: string) =>
			`Latin letters, digits, _ and -. Address: mysweetplace.org/@${username || 'username'}`,
		passwordHint: 'At least 8 characters',
		signupButton: 'Create my place',
		haveAccount: 'Already have a place?',
		forgotTitle: 'Password reset',
		forgotLead: 'Enter your email and we’ll send you a link to set a new password.',
		forgotButton: 'Send the link',
		forgotSent: 'If we know this email, the letter is on its way.',
		resetTitle: 'New password',
		resetButton: 'Save password',
		resetDone: 'Password updated, you can sign in now.'
	},
	explore: {
		title: 'Places',
		lead: 'All public places, from recently updated to long forgotten. No algorithms, no recommendations.',
		search: 'Name or username',
		interests: 'Interests',
		all: 'All',
		empty: 'Nobody found',
		reset: 'Reset filters',
		interest: (label: string) => `Interest: ${label}`
	},
	random: {
		empty: 'Nowhere to go yet — there are no other places.'
	},
	place: {
		edit: 'Decorate',
		addNeighbour: 'Add as neighbour',
		isNeighbour: 'Neighbours',
		removeNeighbour: 'Remove from neighbours',
		hiddenBlock: 'Hidden block — only you can see it',
		emptyBlock: 'This block is empty. Fill it in the editor.',
		neighbourOf: (count: number) =>
			`${n(count, ['place considers', 'places consider', 'places consider'])} this place a neighbour`,
		notFound: 'There is no such place',
		notFoundText: 'Maybe there’s a typo in the address? Or go somewhere else.',
		updated: (date: string) => `updated ${date}`,
		neighboursOnly: 'Sign in to add neighbours'
	},
	blocks: {
		titles: {
			intro: 'Intro',
			links: 'Links',
			projects: 'Projects',
			notes: 'Notes',
			now: 'Now',
			stack: 'Stack',
			interests: 'Interests',
			music: 'Music',
			photos: 'Photos',
			guestbook: 'Guestbook',
			neighbours: 'My neighbourhood',
			timeline: 'Timeline',
			text: 'Text'
		},
		descriptions: {
			intro: 'Your name, avatar and a few words about you',
			links: 'Socials, websites and everything worth a visit',
			projects: 'Personal projects with statuses and stack',
			notes: 'A microblog: short notes, photos and code',
			now: 'What you’re living right now',
			stack: 'Languages, frameworks and tools',
			interests: 'Hobbies — people can find you by them',
			music: 'Favourite music, current track and a playlist',
			photos: 'A small photo gallery',
			guestbook: 'A spot for kind words from visitors',
			neighbours: 'Places you feel close to',
			timeline: 'Important moments of your life',
			text: 'Free text about anything'
		},
		projects: {
			statuses: {
				in_progress: 'In progress',
				idea: 'Idea',
				done: 'Done',
				paused: 'Paused',
				archived: 'Archived'
			},
			site: 'Website',
			repo: 'Code',
			present: 'present'
		},
		notes: {
			all: (count: number) => `All notes (${count})`,
			empty: 'No notes yet',
			pinned: 'Pinned',
			permalink: 'Link to the note'
		},
		now: {
			updated: (date: string) => `Updated ${date}`
		},
		music: {
			current: 'Now playing',
			anthem: 'Pinned song',
			artists: 'Favourite artists',
			albums: 'Favourite albums',
			playlist: 'Playlist',
			listen: 'Listen'
		},
		guestbook: {
			prompt: 'Leave a few kind words :)',
			name: 'Your name',
			message: 'Message',
			send: 'Sign the guestbook',
			sending: 'Sending…',
			sent: 'Thank you! Your entry is in the book.',
			sentPending: 'Thank you! Your entry will appear once the owner approves it.',
			closed: 'The guestbook is closed',
			membersOnly: 'Only MySweetPlace residents can write here.',
			loginToWrite: 'Sign in to write',
			as: (username: string) => `Writing as @${username}`,
			empty: 'Nobody has written anything yet. Be the first!',
			statuses: { visible: 'Published', pending: 'Awaiting approval', hidden: 'Hidden' },
			approve: 'Publish',
			all: (count: number) => `All entries (${count})`,
			pending: (count: number) => `${n(count, ['entry', 'entries', 'entries'])} awaiting approval`
		},
		neighbours: {
			empty: 'No neighbours yet',
			emptyOwner: 'Add neighbours with the “Add as neighbour” button on their places.'
		}
	},
	notes: {
		placeholder: 'What’s new?',
		publish: 'Publish',
		publishing: 'Publishing…',
		photos: 'Photos',
		markdown: 'You can use **bold**, _italic_, `code`, links and ```code blocks```',
		back: 'Back to the place',
		deleteConfirm: 'Delete this note?',
		tooManyImages: (max: number) => `No more than ${max} photos`,
		title: (username: string) => `A note by @${username}`
	},
	stack: {
		categories: {
			languages: 'Languages',
			frontend: 'Frontend',
			backend: 'Backend',
			mobile: 'Mobile',
			desktop: 'Desktop',
			gamedev: 'Gamedev',
			databases: 'Databases',
			devops: 'DevOps & cloud',
			os: 'Operating systems',
			editors: 'Editors & IDEs',
			tools: 'Tools',
			testing: 'Testing',
			data: 'Data & ML',
			design: 'Design',
			hardware: 'Hardware',
			other: 'Other'
		}
	},
	editor: {
		title: 'Decorating',
		view: 'View my place',
		preview: 'Preview',
		tabs: {
			blocks: 'Blocks',
			profile: 'Intro',
			appearance: 'Appearance',
			notes: 'Notes',
			guestbook: 'Guestbook',
			neighbours: 'Neighbours',
			settings: 'Settings'
		},
		blocks: {
			add: 'Add a block',
			choose: 'Which block to add?',
			already: 'already added',
			visible: 'Shown',
			hidden: 'Hidden',
			delete: 'Delete block',
			deleteConfirm: (title: string) => `Delete the “${title}” block? Its content will be lost.`,
			title: 'Title',
			titlePlaceholder: (title: string) => `Default: ${title}`,
			hideTitle: 'Don’t show the title',
			width: 'Width',
			widths: { full: 'Full width', half: 'Half' },
			variant: 'Look',
			accent: 'Custom accent color',
			look: 'Appearance',
			content: 'Content',
			variants: {
				side: 'Avatar on the side',
				center: 'Centered',
				list: 'List',
				buttons: 'Buttons',
				icons: 'Icons',
				cards: 'Cards',
				feed: 'Feed',
				compact: 'Compact',
				card: 'Card',
				badges: 'Badges',
				grouped: 'By category',
				tags: 'Tags',
				grid: 'Grid',
				polaroid: 'Polaroids',
				district: 'Neighbourhood',
				plain: 'No frame',
				default: 'Default'
			} as Record<string, string>
		},
		forms: {
			introHint: 'Name, avatar and the rest are filled in on the “Intro” tab.',
			linkTitle: 'Title',
			linkUrl: 'URL',
			addLink: 'Add a link',
			addProject: 'Add a project',
			projectTitle: 'Title',
			projectDescription: 'Description',
			projectStatus: 'Status',
			projectStarted: 'Started',
			projectFinished: 'Finished',
			projectUrl: 'Website',
			projectRepo: 'Repository',
			projectStack: 'Project stack',
			projectStackHint: 'Comma separated: ruby, rails, svelte',
			projectImages: 'Images',
			projectMeta: 'Extra',
			metaKey: 'Field',
			metaValue: 'Value',
			addMeta: 'Add a field',
			monthHint: 'YYYY or YYYY-MM',
			notesLimit: 'How many notes to show',
			notesHint: 'Notes themselves are written on the “Notes” tab or right on your place.',
			nowText: 'A few words about now',
			nowItems: 'Items',
			emoji: 'Emoji',
			text: 'Text',
			addItem: 'Add an item',
			updatedOn: 'Updated on',
			stackSearch: 'Find a technology',
			stackSelected: (count: number) => `Selected: ${count}`,
			stackCustom: 'Custom technology',
			stackCustomName: 'Name',
			stackCustomColor: 'Color',
			stackNothing: 'Nothing found — add your own',
			interestLabel: 'Interest',
			interestPlaceholder: 'music, hiking, pixel art…',
			addInterest: 'Add an interest',
			trackTitle: 'Title',
			trackArtist: 'Artist',
			trackUrl: 'Link',
			musicCurrent: 'Now playing',
			musicAnthem: 'Your favourite song (pinned)',
			musicArtists: 'Favourite artists',
			musicArtistsHint: 'One per line',
			musicAlbums: 'Favourite albums',
			albumTitle: 'Album',
			albumYear: 'Year',
			albumCover: 'Cover',
			addAlbum: 'Add an album',
			playlistTitle: 'Playlist title',
			playlistUrl: 'Playlist link',
			playlistHint:
				'Yandex Music, Spotify, SoundCloud, YouTube or Apple Music — we’ll show a player',
			addPhotos: 'Add photos',
			caption: 'Caption',
			guestbookAccess: 'Who can write',
			guestbookAccessOptions: {
				everyone: 'Everyone, including guests',
				members: 'Only MySweetPlace residents',
				nobody: 'Nobody — the book is closed'
			},
			guestbookPremoderation: 'Show new entries only after I approve them',
			guestbookPrompt: 'Invitation above the form',
			guestbookLimit: 'How many entries to show',
			neighboursHint: 'The list of neighbours is edited on the “Neighbours” tab.',
			timelineOrder: 'Order',
			timelineOrders: { desc: 'Newest first', asc: 'Oldest first' },
			timelineDate: 'Date',
			timelineDateHint: 'YYYY, YYYY-MM or YYYY-MM-DD',
			timelineTitle: 'Moment',
			addMoment: 'Add a moment',
			textBody: 'Text'
		},
		localized: {
			addEnglish: 'Add an English version',
			english: 'English'
		},
		profile: {
			avatar: 'Avatar',
			uploadAvatar: 'Upload avatar',
			removeAvatar: 'Remove',
			name: 'Name',
			tagline: 'Short description',
			occupation: 'Occupation',
			location: 'Location',
			status: 'Status',
			statusEmoji: 'Emoji',
			statusText: 'Status text',
			about: 'About me',
			username: 'Username',
			usernameHint: 'If you change your username, old links to your place will stop working.'
		},
		appearance: {
			presets: 'Ready-made themes',
			presetNames: {
				classic: 'Classic',
				night: 'Night',
				paper: 'Paper',
				sakura: 'Sakura',
				forest: 'Forest',
				ocean: 'Ocean',
				terminal: 'Terminal',
				lilac: 'Lilac',
				cocoa: 'Cocoa',
				mono: 'Monochrome'
			},
			colors: 'Colors',
			colorNames: {
				background: 'Background',
				surface: 'Cards',
				text: 'Text',
				muted: 'Secondary text',
				accent: 'Accent',
				border: 'Borders'
			},
			fonts: 'Fonts',
			font: 'Body text',
			headingFont: 'Headings',
			fontSize: 'Text size',
			fontSizes: { small: 'Small', normal: 'Normal', large: 'Large' },
			fontGroups: {
				system: 'System',
				serif: 'Serif',
				sans: 'Sans serif',
				mono: 'Monospace',
				display: 'Display'
			},
			background: 'Page background',
			backgroundTypes: { color: 'Color', gradient: 'Gradient', pattern: 'Pattern', image: 'Image' },
			color2: 'Second color',
			angle: 'Angle',
			pattern: 'Pattern',
			patternNames: {
				none: 'No pattern',
				dots: 'Polka dots',
				grid: 'Grid',
				lines: 'Ruled',
				diagonal: 'Diagonal',
				checkers: 'Checkers',
				hearts: 'Hearts',
				stars: 'Stars',
				waves: 'Waves',
				crosses: 'Crosses'
			},
			image: 'Image',
			imageModes: { cover: 'Cover', tile: 'Tile', fixed: 'Fixed' },
			cards: 'Cards',
			cardStyles: {
				classic: 'Classic',
				flat: 'Flat',
				outline: 'Outline',
				glass: 'Glass',
				retro: 'Retro',
				none: 'No cards'
			},
			radius: 'Corner radius',
			layout: 'Page width',
			widths: { narrow: 'Narrow', normal: 'Normal', wide: 'Wide' },
			customCss: 'Custom CSS for advanced residents is coming later.'
		},
		notes: {
			title: 'Notes',
			empty: 'No notes yet. Write the first one!'
		},
		guestbook: {
			title: 'Guestbook',
			filters: { all: 'All', visible: 'Published', pending: 'Awaiting', hidden: 'Hidden' },
			empty: 'Nothing here',
			settingsHint:
				'Who can write and whether entries need approval is set in the “Guestbook” block settings.'
		},
		neighbours: {
			title: 'Neighbours',
			add: 'Add',
			addPlaceholder: 'username',
			label: 'Label',
			labelPlaceholder: 'e.g. “friend from work”',
			empty: 'No neighbours yet. Add someone by username or with the button on their place.',
			neighbourOf: 'Consider you a neighbour',
			nobody: 'Nobody yet'
		},
		settings: {
			visibility: 'Visibility',
			listed: 'Show my place in the list of places and in random trips',
			noindex: 'Ask search engines not to index my place',
			account: 'Account',
			email: 'Email',
			language: 'Email language',
			newPassword: 'New password',
			currentPassword: 'Current password',
			changeEmail: 'Change email',
			changePassword: 'Change password',
			passwordChanged: 'Password updated',
			logout: 'Sign out',
			danger: 'Danger zone',
			deleteAccount: 'Delete my place and account',
			deleteText:
				'This is forever: notes, photos, the guestbook and neighbours will be gone. Enter your password to confirm.'
		}
	},
	season: {
		snowOn: 'Turn snow on',
		snowOff: 'Turn snow off'
	},
	errors: {
		notFound: 'Nothing here',
		notFoundText: 'Looks like this page doesn’t exist. Maybe go somewhere else?',
		server: 'Something broke',
		serverText: 'We’re fixing it. Try refreshing the page a bit later.',
		home: 'Home'
	}
};

export default en;
