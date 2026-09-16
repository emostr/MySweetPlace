import { describe, expect, it } from 'vitest';
import { linkBrand, linkHost } from './links';

describe('links', () => {
	it('detects brands', () => {
		expect(linkBrand('https://github.com/emostr')).toBe('github');
		expect(linkBrand('https://t.me/example')).toBe('telegram');
		expect(linkBrand('https://music.youtube.com/playlist?list=1')).toBe('youtubemusic');
		expect(linkBrand('https://www.youtube.com/@channel')).toBe('youtube');
		expect(linkBrand('https://example.com')).toBeNull();
		expect(linkBrand('mailto:me@example.com')).toBeNull();
	});

	it('shows short hosts', () => {
		expect(linkHost('https://www.habr.com/ru/users/me')).toBe('habr.com');
		expect(linkHost('mailto:me@example.com')).toBe('me@example.com');
	});
});
