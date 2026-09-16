const urls = import.meta.glob<string>('./fonts/*.css', {
	query: '?url',
	import: 'default',
	eager: true
});

export type FontGroup = 'system' | 'serif' | 'sans' | 'mono' | 'display';

export interface Font {
	id: string;
	name: string;
	group: FontGroup;
	stack: string;
	url: string | null;
}

const SERIF = "Georgia, 'Times New Roman', serif";
const SANS = 'Arial, Helvetica, sans-serif';
const MONO = "'Courier New', monospace";

const definitions: [string, string, FontGroup, string][] = [
	['georgia', 'Georgia', 'system', SERIF],
	['arial', 'Arial', 'system', SANS],
	['verdana', 'Verdana', 'system', 'Verdana, Geneva, sans-serif'],
	['trebuchet', 'Trebuchet MS', 'system', "'Trebuchet MS', 'Lucida Grande', sans-serif"],
	['times', 'Times New Roman', 'system', "'Times New Roman', Times, serif"],
	['courier', 'Courier New', 'system', "'Courier New', Courier, monospace"],
	['system', 'System UI', 'system', "system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif"],
	['pt-serif', 'PT Serif', 'serif', `'PT Serif', ${SERIF}`],
	['lora', 'Lora', 'serif', `Lora, ${SERIF}`],
	['merriweather', 'Merriweather', 'serif', `Merriweather, ${SERIF}`],
	['playfair-display', 'Playfair Display', 'serif', `'Playfair Display', ${SERIF}`],
	['eb-garamond', 'EB Garamond', 'serif', `'EB Garamond', ${SERIF}`],
	['cormorant', 'Cormorant', 'serif', `Cormorant, ${SERIF}`],
	['literata', 'Literata', 'serif', `Literata, ${SERIF}`],
	['pt-sans', 'PT Sans', 'sans', `'PT Sans', ${SANS}`],
	['rubik', 'Rubik', 'sans', `Rubik, ${SANS}`],
	['nunito', 'Nunito', 'sans', `Nunito, ${SANS}`],
	['montserrat', 'Montserrat', 'sans', `Montserrat, ${SANS}`],
	['golos-text', 'Golos Text', 'sans', `'Golos Text', ${SANS}`],
	['manrope', 'Manrope', 'sans', `Manrope, ${SANS}`],
	['unbounded', 'Unbounded', 'sans', `Unbounded, ${SANS}`],
	['comfortaa', 'Comfortaa', 'sans', `Comfortaa, ${SANS}`],
	['pt-mono', 'PT Mono', 'mono', `'PT Mono', ${MONO}`],
	['jetbrains-mono', 'JetBrains Mono', 'mono', `'JetBrains Mono', ${MONO}`],
	['ibm-plex-mono', 'IBM Plex Mono', 'mono', `'IBM Plex Mono', ${MONO}`],
	['fira-code', 'Fira Code', 'mono', `'Fira Code', ${MONO}`],
	['caveat', 'Caveat', 'display', `Caveat, cursive`],
	['neucha', 'Neucha', 'display', `Neucha, cursive`],
	['marck-script', 'Marck Script', 'display', `'Marck Script', cursive`],
	['amatic-sc', 'Amatic SC', 'display', `'Amatic SC', cursive`],
	['lobster', 'Lobster', 'display', `Lobster, cursive`],
	['yeseva-one', 'Yeseva One', 'display', `'Yeseva One', ${SERIF}`],
	['press-start-2p', 'Press Start 2P', 'display', `'Press Start 2P', ${MONO}`],
	['pixelify-sans', 'Pixelify Sans', 'display', `'Pixelify Sans', ${SANS}`]
];

export const FONTS: Font[] = definitions.map(([id, name, group, stack]) => ({
	id,
	name,
	group,
	stack,
	url: urls[`./fonts/${id}.css`] ?? null
}));

export const FONT_GROUPS: FontGroup[] = ['system', 'serif', 'sans', 'mono', 'display'];

const byId = new Map(FONTS.map((font) => [font.id, font]));

export function getFont(id: string) {
	return byId.get(id) ?? byId.get('arial')!;
}

export function fontUrls(...ids: string[]) {
	return [...new Set(ids.map((id) => getFont(id).url).filter((url): url is string => !!url))];
}
