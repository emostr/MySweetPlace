import { describe, expect, it } from 'vitest';
import { contrastInk, pageBackground } from './style';
import { defaultTheme } from './presets';

describe('theme style', () => {
	it('picks readable ink for accents', () => {
		expect(contrastInk('#7a2531')).toBe('#ffffff');
		expect(contrastInk('#39ff14')).toBe('#111111');
	});

	it('builds page backgrounds', () => {
		const theme = defaultTheme();
		expect(pageBackground(theme, {})).toBe('#e6e7e9');

		theme.background = { ...theme.background, type: 'image', image_id: 7, image_mode: 'tile' };
		expect(
			pageBackground(theme, { 7: { id: 7, url: '/api/storage/a"b.png', width: 1, height: 1 } })
		).toBe('url("/api/storage/a%22b.png") repeat #e6e7e9');
		expect(pageBackground(theme, {})).toBe('#e6e7e9');
	});
});
