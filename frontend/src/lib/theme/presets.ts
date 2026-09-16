import type { Theme, ThemePreset } from '$lib/types';

type PresetLook = Omit<Theme, 'preset' | 'background'> & {
	background: Omit<Theme['background'], 'image_id' | 'image_mode'>;
};

export const PRESETS: Record<ThemePreset, PresetLook> = {
	classic: {
		colors: {
			background: '#e6e7e9',
			surface: '#ffffff',
			text: '#333333',
			muted: '#6b6f76',
			accent: '#7a2531',
			border: '#dcdde0'
		},
		font: 'arial',
		heading_font: 'georgia',
		font_size: 'normal',
		background: { type: 'color', color2: '#c9ccd1', angle: 180, pattern: 'none' },
		cards: { style: 'classic', radius: 4 },
		layout: { width: 'normal' }
	},
	night: {
		colors: {
			background: '#15171c',
			surface: '#1f232b',
			text: '#e3e5e8',
			muted: '#9097a3',
			accent: '#e0a458',
			border: '#2e333d'
		},
		font: 'pt-sans',
		heading_font: 'pt-serif',
		font_size: 'normal',
		background: { type: 'pattern', color2: '#0b0c10', angle: 180, pattern: 'stars' },
		cards: { style: 'flat', radius: 10 },
		layout: { width: 'normal' }
	},
	paper: {
		colors: {
			background: '#f1e9da',
			surface: '#fbf7ef',
			text: '#3b3226',
			muted: '#857760',
			accent: '#9c4a1a',
			border: '#dccfb7'
		},
		font: 'lora',
		heading_font: 'playfair-display',
		font_size: 'normal',
		background: { type: 'pattern', color2: '#e6dcc8', angle: 180, pattern: 'lines' },
		cards: { style: 'outline', radius: 2 },
		layout: { width: 'narrow' }
	},
	sakura: {
		colors: {
			background: '#fbe7ee',
			surface: '#fffafb',
			text: '#4a2f38',
			muted: '#9a7482',
			accent: '#d2557f',
			border: '#f2cbd7'
		},
		font: 'nunito',
		heading_font: 'comfortaa',
		font_size: 'normal',
		background: { type: 'pattern', color2: '#f7d5e1', angle: 160, pattern: 'hearts' },
		cards: { style: 'classic', radius: 16 },
		layout: { width: 'normal' }
	},
	forest: {
		colors: {
			background: '#dde5d3',
			surface: '#f7f9f3',
			text: '#2f3a2c',
			muted: '#6a7763',
			accent: '#4f7a3a',
			border: '#c6d2b9'
		},
		font: 'pt-sans',
		heading_font: 'eb-garamond',
		font_size: 'normal',
		background: { type: 'gradient', color2: '#b9c9a8', angle: 170, pattern: 'none' },
		cards: { style: 'classic', radius: 6 },
		layout: { width: 'normal' }
	},
	ocean: {
		colors: {
			background: '#d5eaf1',
			surface: '#f6fbfd',
			text: '#1f3440',
			muted: '#5b7481',
			accent: '#1d7896',
			border: '#b9d7e2'
		},
		font: 'rubik',
		heading_font: 'rubik',
		font_size: 'normal',
		background: { type: 'gradient', color2: '#8fc3d6', angle: 180, pattern: 'waves' },
		cards: { style: 'glass', radius: 14 },
		layout: { width: 'normal' }
	},
	terminal: {
		colors: {
			background: '#0b0f0b',
			surface: '#0f150f',
			text: '#b6f2ae',
			muted: '#5e9657',
			accent: '#39ff14',
			border: '#1f3a1c'
		},
		font: 'jetbrains-mono',
		heading_font: 'press-start-2p',
		font_size: 'small',
		background: { type: 'pattern', color2: '#000000', angle: 180, pattern: 'grid' },
		cards: { style: 'outline', radius: 0 },
		layout: { width: 'normal' }
	},
	lilac: {
		colors: {
			background: '#e8e2f5',
			surface: '#faf8fe',
			text: '#3a3150',
			muted: '#827a99',
			accent: '#7453c2',
			border: '#3a3150'
		},
		font: 'manrope',
		heading_font: 'unbounded',
		font_size: 'normal',
		background: { type: 'pattern', color2: '#d9cff0', angle: 180, pattern: 'dots' },
		cards: { style: 'retro', radius: 10 },
		layout: { width: 'normal' }
	},
	cocoa: {
		colors: {
			background: '#2a201b',
			surface: '#372a23',
			text: '#f0e2d0',
			muted: '#b39c86',
			accent: '#e8a87c',
			border: '#4b3a30'
		},
		font: 'literata',
		heading_font: 'yeseva-one',
		font_size: 'normal',
		background: { type: 'color', color2: '#1f1814', angle: 180, pattern: 'none' },
		cards: { style: 'classic', radius: 6 },
		layout: { width: 'narrow' }
	},
	mono: {
		colors: {
			background: '#f4f4f4',
			surface: '#ffffff',
			text: '#111111',
			muted: '#6e6e6e',
			accent: '#111111',
			border: '#111111'
		},
		font: 'ibm-plex-mono',
		heading_font: 'ibm-plex-mono',
		font_size: 'small',
		background: { type: 'pattern', color2: '#e5e5e5', angle: 180, pattern: 'crosses' },
		cards: { style: 'retro', radius: 0 },
		layout: { width: 'wide' }
	}
};

export function applyPreset(theme: Theme, preset: ThemePreset): Theme {
	const look = structuredClone(PRESETS[preset]);
	return {
		...look,
		preset,
		background: {
			...look.background,
			image_id: theme.background.image_id,
			image_mode: theme.background.image_mode
		}
	};
}

export function defaultTheme(): Theme {
	return applyPreset({ background: { image_id: null, image_mode: 'cover' } } as Theme, 'classic');
}
