import type { Theme, Upload } from '$lib/types';
import { getFont } from './fonts';
import { patternImage } from './patterns';

const SIZES = { small: '14px', normal: '15px', large: '17px' };
const WIDTHS = { narrow: '700px', normal: '920px', wide: '1140px' };

export function contrastInk(hex: string) {
	const value = parseInt(hex.slice(1), 16);
	const [r, g, b] = [(value >> 16) & 255, (value >> 8) & 255, value & 255].map((channel) => {
		const c = channel / 255;
		return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
	});
	return 0.2126 * r + 0.7152 * g + 0.0722 * b > 0.45 ? '#111111' : '#ffffff';
}

function cssUrl(url: string) {
	return `url("${url.replace(/["\\\n]/g, (char) => encodeURIComponent(char))}")`;
}

export function pageBackground(theme: Theme, uploads: Record<string, Upload>) {
	const { colors, background } = theme;
	switch (background.type) {
		case 'gradient':
			return `linear-gradient(${background.angle}deg, ${colors.background}, ${background.color2}) fixed`;
		case 'pattern': {
			const image = patternImage(background.pattern, colors.text);
			return image ? `${image} ${colors.background}` : colors.background;
		}
		case 'image': {
			const upload = background.image_id ? uploads[background.image_id] : null;
			if (!upload) return colors.background;
			if (background.image_mode === 'tile')
				return `${cssUrl(upload.url)} repeat ${colors.background}`;
			const attachment = background.image_mode === 'fixed' ? ' fixed' : '';
			return `${cssUrl(upload.url)} center / cover no-repeat${attachment} ${colors.background}`;
		}
		default:
			return colors.background;
	}
}

export function themeStyle(theme: Theme, uploads: Record<string, Upload>) {
	const { colors } = theme;
	const vars: Record<string, string> = {
		'--p-bg': colors.background,
		'--p-surface': colors.surface,
		'--p-text': colors.text,
		'--p-muted': colors.muted,
		'--p-accent': colors.accent,
		'--p-accent-ink': contrastInk(colors.accent),
		'--p-border': colors.border,
		'--p-font': getFont(theme.font).stack,
		'--p-heading': getFont(theme.heading_font).stack,
		'--p-size': SIZES[theme.font_size] ?? SIZES.normal,
		'--p-radius': `${theme.cards.radius}px`,
		'--p-width': WIDTHS[theme.layout.width] ?? WIDTHS.normal,
		'--p-page': pageBackground(theme, uploads)
	};
	return Object.entries(vars)
		.map(([key, value]) => `${key}: ${value}`)
		.join('; ');
}
