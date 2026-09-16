import type { PatternId } from '$lib/types';

type Tile = { width: number; height: number; body: (color: string) => string; opacity?: number };

const tiles: Record<Exclude<PatternId, 'none'>, Tile> = {
	dots: { width: 18, height: 18, body: (c) => `<circle cx='9' cy='9' r='1.6' fill='${c}'/>` },
	grid: {
		width: 24,
		height: 24,
		body: (c) => `<path d='M24 .5H.5V24' fill='none' stroke='${c}'/>`
	},
	lines: { width: 28, height: 28, body: (c) => `<path d='M0 27.5h28' stroke='${c}'/>` },
	diagonal: {
		width: 12,
		height: 12,
		body: (c) => `<path d='M-3 3l6-6M0 12L12 0M9 15l6-6' stroke='${c}' stroke-width='1.2'/>`
	},
	checkers: {
		width: 32,
		height: 32,
		opacity: 0.05,
		body: (c) => `<path d='M0 0h16v16H0zM16 16h16v16H16z' fill='${c}'/>`
	},
	hearts: {
		width: 36,
		height: 36,
		body: (c) =>
			`<path d='M18 25s-7-4.4-7-9.2a3.8 3.8 0 0 1 7-1.8 3.8 3.8 0 0 1 7 1.8c0 4.8-7 9.2-7 9.2z' fill='${c}'/>`
	},
	stars: {
		width: 44,
		height: 44,
		body: (c) =>
			`<path d='M22 12l1.8 8.2L32 22l-8.2 1.8L22 32l-1.8-8.2L12 22l8.2-1.8z' fill='${c}'/><circle cx='6' cy='38' r='1.2' fill='${c}'/>`
	},
	waves: {
		width: 40,
		height: 20,
		body: (c) => `<path d='M0 10q10-8 20 0t20 0' fill='none' stroke='${c}' stroke-width='1.2'/>`
	},
	crosses: {
		width: 24,
		height: 24,
		body: (c) => `<path d='M12 8v8M8 12h8' stroke='${c}' stroke-width='1.4'/>`
	}
};

export function patternImage(pattern: PatternId, color: string) {
	if (pattern === 'none') return null;
	const tile = tiles[pattern];
	const svg = `<svg xmlns='http://www.w3.org/2000/svg' width='${tile.width}' height='${tile.height}'><g opacity='${tile.opacity ?? 0.13}'>${tile.body(color)}</g></svg>`;
	return `url("data:image/svg+xml,${encodeURIComponent(svg)}")`;
}
