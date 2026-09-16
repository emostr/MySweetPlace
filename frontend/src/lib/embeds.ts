export interface Embed {
	provider: string;
	src: string;
	ratio?: string;
	height?: number;
}

function parseUrl(raw: string) {
	try {
		const url = new URL(raw.trim());
		return ['http:', 'https:'].includes(url.protocol) ? url : null;
	} catch {
		return null;
	}
}

export function parseEmbed(raw: string): Embed | null {
	const url = parseUrl(raw);
	if (!url) return null;
	const host = url.hostname.replace(/^(www|m)\./, '');
	const path = url.pathname;

	if (host === 'youtube.com' || host === 'music.youtube.com' || host === 'youtu.be') {
		const id =
			host === 'youtu.be'
				? path.slice(1, 12)
				: (url.searchParams.get('v') ?? path.match(/^\/(?:shorts|embed|live)\/([\w-]{11})/)?.[1]);
		if (id && /^[\w-]{11}$/.test(id)) {
			return {
				provider: 'youtube',
				src: `https://www.youtube-nocookie.com/embed/${id}`,
				ratio: '16 / 9'
			};
		}
		const list = url.searchParams.get('list');
		if (list && /^[\w-]+$/.test(list)) {
			return {
				provider: 'youtube',
				src: `https://www.youtube-nocookie.com/embed/videoseries?list=${list}`,
				ratio: '16 / 9'
			};
		}
	}

	if (host === 'open.spotify.com') {
		const match = path.match(
			/^\/(?:intl-[a-z-]+\/)?(track|album|playlist|episode|show|artist)\/([A-Za-z0-9]+)/
		);
		if (match) {
			return {
				provider: 'spotify',
				src: `https://open.spotify.com/embed/${match[1]}/${match[2]}`,
				height: match[1] === 'track' ? 152 : 352
			};
		}
	}

	if (/^music\.yandex\.(ru|com|by|kz)$/.test(host)) {
		const track = path.match(/^\/album\/(\d+)\/track\/(\d+)/);
		if (track)
			return {
				provider: 'yandex',
				src: `https://music.yandex.ru/iframe/#track/${track[2]}/${track[1]}`,
				height: 180
			};
		const album = path.match(/^\/album\/(\d+)\/?$/);
		if (album)
			return {
				provider: 'yandex',
				src: `https://music.yandex.ru/iframe/#album/${album[1]}`,
				height: 450
			};
		const playlist = path.match(/^\/users\/([\w.-]+)\/playlists\/(\d+)/);
		if (playlist)
			return {
				provider: 'yandex',
				src: `https://music.yandex.ru/iframe/#playlist/${playlist[1]}/${playlist[2]}`,
				height: 450
			};
	}

	if (host === 'soundcloud.com' && path.split('/').filter(Boolean).length >= 2) {
		const set = path.includes('/sets/');
		return {
			provider: 'soundcloud',
			src: `https://w.soundcloud.com/player/?url=${encodeURIComponent(`https://soundcloud.com${path}`)}&visual=false&show_comments=false`,
			height: set ? 352 : 166
		};
	}

	if (host === 'music.apple.com' && /^\/[a-z]{2}\/(album|playlist|song)\//.test(path)) {
		const song = url.searchParams.has('i') || path.includes('/song/');
		return {
			provider: 'apple',
			src: `https://embed.music.apple.com${path}${url.search}`,
			height: song ? 175 : 450
		};
	}

	if (host === 'rutube.ru') {
		const id = path.match(/^\/video\/([a-f0-9]{32})/)?.[1];
		if (id)
			return { provider: 'rutube', src: `https://rutube.ru/play/embed/${id}`, ratio: '16 / 9' };
	}

	if (host === 'vimeo.com') {
		const id = path.match(/^\/(\d+)/)?.[1];
		if (id)
			return { provider: 'vimeo', src: `https://player.vimeo.com/video/${id}`, ratio: '16 / 9' };
	}

	if (host === 'codepen.io') {
		const match = path.match(/^\/([\w-]+)\/pen\/(\w+)/);
		if (match)
			return {
				provider: 'codepen',
				src: `https://codepen.io/${match[1]}/embed/${match[2]}?default-tab=result`,
				height: 400
			};
	}

	return null;
}

export function findEmbeds(text: string, limit = 3): Embed[] {
	const embeds: Embed[] = [];
	for (const line of text.split('\n')) {
		const candidate = line.trim();
		if (!/^https?:\/\/\S+$/.test(candidate)) continue;
		const embed = parseEmbed(candidate);
		if (embed && !embeds.some((existing) => existing.src === embed.src)) embeds.push(embed);
		if (embeds.length >= limit) break;
	}
	return embeds;
}
