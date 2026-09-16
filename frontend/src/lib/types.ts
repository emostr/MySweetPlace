import type { Locale } from '$lib/i18n';

export type LocalizedText = Partial<Record<Locale, string>>;

export interface User {
	id: number;
	email_address: string;
	locale: Locale;
	admin: boolean;
	created_at: string;
}

export interface PlaceCard {
	id: number;
	username: string;
	name: LocalizedText;
	tagline: LocalizedText;
	avatar_url: string | null;
	accent: string;
	background: string;
	updated_at: string | null;
	label?: string | null;
}

export interface Me {
	user: User | null;
	place: PlaceCard | null;
}

export interface Profile {
	name: LocalizedText;
	tagline: LocalizedText;
	occupation: LocalizedText;
	location: LocalizedText;
	status: { emoji: string; text: LocalizedText };
	about: LocalizedText;
}

export const THEME_PRESETS = [
	'classic',
	'night',
	'paper',
	'sakura',
	'forest',
	'ocean',
	'terminal',
	'lilac',
	'cocoa',
	'mono'
] as const;
export type ThemePreset = (typeof THEME_PRESETS)[number];

export const PATTERNS = [
	'none',
	'dots',
	'grid',
	'lines',
	'diagonal',
	'checkers',
	'hearts',
	'stars',
	'waves',
	'crosses'
] as const;
export type PatternId = (typeof PATTERNS)[number];

export const CARD_STYLES = ['classic', 'flat', 'outline', 'glass', 'retro', 'none'] as const;
export type CardStyle = (typeof CARD_STYLES)[number];

export interface ThemeColors {
	background: string;
	surface: string;
	text: string;
	muted: string;
	accent: string;
	border: string;
}

export interface Theme {
	preset: ThemePreset;
	colors: ThemeColors;
	font: string;
	heading_font: string;
	font_size: 'normal' | 'small' | 'large';
	background: {
		type: 'color' | 'gradient' | 'pattern' | 'image';
		color2: string;
		angle: number;
		pattern: PatternId;
		image_id: number | null;
		image_mode: 'cover' | 'tile' | 'fixed';
	};
	cards: { style: CardStyle; radius: number };
	layout: { width: 'normal' | 'narrow' | 'wide' };
}

export interface Upload {
	id: number;
	url: string;
	width: number | null;
	height: number | null;
}

export interface BlockStyle {
	variant: string;
	width: 'full' | 'half';
	hide_title: boolean;
	accent: string | null;
}

export interface LinkItem {
	id: string;
	title: string;
	url: string;
}

export const PROJECT_STATUSES = ['in_progress', 'idea', 'done', 'paused', 'archived'] as const;
export type ProjectStatus = (typeof PROJECT_STATUSES)[number];

export interface ProjectItem {
	id: string;
	title: LocalizedText;
	description: LocalizedText;
	status: ProjectStatus;
	started: string;
	finished: string;
	url: string;
	repo: string;
	stack: string[];
	image_ids: number[];
	meta: { key: string; value: string }[];
}

export interface StackItem {
	id: string;
	slug: string;
	name: string;
	color: string | null;
}

export interface Track {
	title: string;
	artist: string;
	url: string;
}

export interface Album {
	id: string;
	title: string;
	artist: string;
	year: string;
	cover_id: number | null;
	url: string;
}

export interface TimelineItem {
	id: string;
	date: string;
	emoji: string;
	title: LocalizedText;
	text: LocalizedText;
}

export interface BlockDataMap {
	intro: Record<string, never>;
	links: { items: LinkItem[] };
	projects: { items: ProjectItem[] };
	notes: { limit: number };
	now: {
		text: LocalizedText;
		items: { id: string; emoji: string; text: LocalizedText }[];
		updated_on: string;
	};
	stack: { items: StackItem[] };
	interests: { items: { id: string; emoji: string; label: string }[] };
	music: {
		current: Track;
		anthem: Track;
		artists: string[];
		albums: Album[];
		playlist: { title: string; url: string };
	};
	photos: { items: { id: string; image_id: number; caption: LocalizedText }[] };
	guestbook: {
		access: 'everyone' | 'members' | 'nobody';
		premoderation: boolean;
		prompt: LocalizedText;
		limit: number;
	};
	neighbours: Record<string, never>;
	timeline: { order: 'desc' | 'asc'; items: TimelineItem[] };
	text: { body: LocalizedText };
}

export type BlockKind = keyof BlockDataMap;

export interface Note {
	id: number;
	body: string;
	body_html: string;
	pinned: boolean;
	images: Upload[];
	created_at: string;
	updated_at: string;
	place?: PlaceCard;
}

export interface GuestbookEntry {
	id: number;
	body: string;
	status: 'visible' | 'hidden' | 'pending';
	pinned: boolean;
	created_at: string;
	author: { name: string; username: string | null; avatar_url: string | null };
	can_delete: boolean;
}

export interface BlockContentMap {
	notes: { items: Note[]; total: number };
	guestbook: { items: GuestbookEntry[]; total: number; can_write: boolean; pending: number };
	neighbours: { items: PlaceCard[] };
}

export type Block = {
	[K in BlockKind]: {
		id: number;
		kind: K;
		position: number;
		visible: boolean;
		title: LocalizedText;
		data: BlockDataMap[K];
		style: BlockStyle;
		updated_at: string;
		content: K extends keyof BlockContentMap ? BlockContentMap[K] : null;
	};
}[BlockKind];

export type BlockOf<K extends BlockKind> = Extract<Block, { kind: K }>;

export interface Place {
	id: number;
	username: string;
	profile: Profile;
	theme: Theme;
	settings: { noindex: boolean };
	listed: boolean;
	avatar_url: string | null;
	created_at: string;
	updated_at: string | null;
	owner: boolean;
	neighbour: boolean;
	neighbour_of_count: number;
	blocks: Block[];
	uploads: Record<string, Upload>;
}

export interface Paginated<T> {
	items: T[];
	has_more: boolean;
}
