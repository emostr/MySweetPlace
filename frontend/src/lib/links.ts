const BRANDS: [RegExp, string][] = [
	[/^music\.youtube\.com$/, 'youtubemusic'],
	[/(^|\.)github\.com$/, 'github'],
	[/(^|\.)gitlab\.com$/, 'gitlab'],
	[/^codeberg\.org$/, 'codeberg'],
	[/^sr\.ht$|\.sr\.ht$/, 'sourcehut'],
	[/^(t\.me|telegram\.me)$/, 'telegram'],
	[/^(vk\.com|vk\.ru)$/, 'vk'],
	[/^ok\.ru$/, 'odnoklassniki'],
	[/^(x\.com|twitter\.com)$/, 'x'],
	[/^(youtube\.com|youtu\.be)$/, 'youtube'],
	[/^instagram\.com$/, 'instagram'],
	[/^threads\.(net|com)$/, 'threads'],
	[/^bsky\.app$/, 'bluesky'],
	[/(^|\.)(mastodon\.[a-z]+|mstdn\.[a-z]+|fosstodon\.org|mastodon\.social)$/, 'mastodon'],
	[/^twitch\.tv$/, 'twitch'],
	[/^tiktok\.com$/, 'tiktok'],
	[/(^|\.)pinterest\.[a-z.]+$/, 'pinterest'],
	[/^reddit\.com$/, 'reddit'],
	[/(^|\.)medium\.com$/, 'medium'],
	[/^dev\.to$/, 'devdotto'],
	[/^habr\.com$/, 'habr'],
	[/(^|\.)hashnode\.(com|dev)$/, 'hashnode'],
	[/(^|\.)substack\.com$/, 'substack'],
	[/(^|\.)wordpress\.com$/, 'wordpress'],
	[/(^|\.)tumblr\.com$/, 'tumblr'],
	[/^open\.spotify\.com$|^spotify\.com$/, 'spotify'],
	[/^soundcloud\.com$/, 'soundcloud'],
	[/^(last\.fm|lastfm\.ru)$/, 'lastdotfm'],
	[/^music\.apple\.com$/, 'applemusic'],
	[/(^|\.)bandcamp\.com$/, 'bandcamp'],
	[/^mixcloud\.com$/, 'mixcloud'],
	[/^deezer\.com$/, 'deezer'],
	[/^(tidal\.com|listen\.tidal\.com)$/, 'tidal'],
	[/^(steamcommunity\.com|store\.steampowered\.com)$/, 'steam'],
	[/(^|\.)itch\.io$/, 'itchdotio'],
	[/^behance\.net$/, 'behance'],
	[/^dribbble\.com$/, 'dribbble'],
	[/(^|\.)deviantart\.com$/, 'deviantart'],
	[/^artstation\.com$/, 'artstation'],
	[/^flickr\.com$/, 'flickr'],
	[/^unsplash\.com$/, 'unsplash'],
	[/^vimeo\.com$/, 'vimeo'],
	[/^patreon\.com$/, 'patreon'],
	[/^boosty\.to$/, 'boosty'],
	[/^ko-fi\.com$/, 'kofi'],
	[/^buymeacoffee\.com$/, 'buymeacoffee'],
	[/^liberapay\.com$/, 'liberapay'],
	[/^opencollective\.com$/, 'opencollective'],
	[/^rubygems\.org$/, 'rubygems'],
	[/^npmjs\.com$/, 'npm'],
	[/^wakatime\.com$/, 'wakatime'],
	[/^(signal\.me|signal\.org)$/, 'signal'],
	[/^(wa\.me|whatsapp\.com)$/, 'whatsapp'],
	[/^matrix\.to$/, 'matrix'],
	[/^keybase\.io$/, 'keybase'],
	[/^(discord\.gg|discord\.com)$/, 'discord'],
	[/^facebook\.com$/, 'facebook'],
	[/^letterboxd\.com$/, 'letterboxd'],
	[/^goodreads\.com$/, 'goodreads'],
	[/^anilist\.co$/, 'anilist'],
	[/^myanimelist\.net$/, 'myanimelist'],
	[/^shikimori\.(one|me|io)$/, 'shikimori'],
	[/^trakt\.tv$/, 'trakt'],
	[/^imdb\.com$/, 'imdb'],
	[/^chess\.com$/, 'chessdotcom'],
	[/^lichess\.org$/, 'lichess'],
	[/^strava\.com$/, 'strava'],
	[/^duolingo\.com$/, 'duolingo'],
	[/^leetcode\.(com|cn)$/, 'leetcode'],
	[/^hackerrank\.com$/, 'hackerrank'],
	[/^codewars\.com$/, 'codewars'],
	[/^kaggle\.com$/, 'kaggle'],
	[/^orcid\.org$/, 'orcid'],
	[/^researchgate\.net$/, 'researchgate'],
	[/^scholar\.google\.[a-z.]+$/, 'googlescholar']
];

export function linkHost(url: string) {
	try {
		const parsed = new URL(url);
		if (parsed.protocol === 'mailto:') return parsed.pathname;
		return parsed.hostname.replace(/^(www|m)\./, '');
	} catch {
		return url;
	}
}

export function linkBrand(url: string): string | null {
	if (url.startsWith('mailto:')) return null;
	const host = linkHost(url);
	return BRANDS.find(([pattern]) => pattern.test(host))?.[1] ?? null;
}

export function brandIcon(slug: string) {
	return `/icons/brands/${slug}.svg`;
}
