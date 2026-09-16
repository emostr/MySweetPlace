import { describe, expect, it } from 'vitest';
import { findEmbeds, parseEmbed } from './embeds';

describe('parseEmbed', () => {
	it('understands youtube links', () => {
		expect(parseEmbed('https://www.youtube.com/watch?v=dQw4w9WgXcQ')?.src).toBe(
			'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ'
		);
		expect(parseEmbed('https://youtu.be/dQw4w9WgXcQ?t=10')?.src).toBe(
			'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ'
		);
	});

	it('understands music services', () => {
		expect(parseEmbed('https://music.yandex.ru/album/123/track/456')?.src).toBe(
			'https://music.yandex.ru/iframe/#track/456/123'
		);
		expect(
			parseEmbed('https://open.spotify.com/intl-ru/track/4uLU6hMCjMI75M1A2tKUQC')
		).toMatchObject({ provider: 'spotify', height: 152 });
		expect(parseEmbed('https://soundcloud.com/artist/song')?.provider).toBe('soundcloud');
	});

	it('ignores unknown and unsafe urls', () => {
		expect(parseEmbed('https://example.com/video')).toBeNull();
		expect(parseEmbed('javascript:alert(1)')).toBeNull();
		expect(parseEmbed('not a url')).toBeNull();
	});
});

describe('findEmbeds', () => {
	it('takes only bare links on their own line', () => {
		const text =
			'послушайте:\nhttps://youtu.be/dQw4w9WgXcQ\nи ещё https://youtu.be/aaaaaaaaaaa в тексте';
		expect(findEmbeds(text)).toHaveLength(1);
	});
});
