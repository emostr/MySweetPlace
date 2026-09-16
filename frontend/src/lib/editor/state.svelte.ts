import { getContext, setContext } from 'svelte';
import { api } from '$lib/api';
import type { Block, BlockStyle, LocalizedText, Place, Profile, Theme, Upload } from '$lib/types';

export interface BlockDraft {
	title: LocalizedText;
	data: Block['data'];
	style: BlockStyle;
}

export class EditorState {
	place = $state() as Place;
	blockDrafts = $state<Record<number, BlockDraft>>({});
	profile = $state<Profile | null>(null);
	theme = $state<Theme | null>(null);
	uploads = $state<Record<string, Upload>>({});

	preview = $derived.by((): Place => ({
		...this.place,
		profile: this.profile ?? this.place.profile,
		theme: this.theme ?? this.place.theme,
		blocks: this.place.blocks.map((block) => {
			const draft = this.blockDrafts[block.id];
			return draft ? ({ ...block, ...draft } as Block) : block;
		}),
		uploads: { ...this.place.uploads, ...this.uploads }
	}));

	constructor(place: Place) {
		this.place = place;
	}

	remember(upload: Upload) {
		this.uploads[upload.id] = upload;
	}

	async reload() {
		const { place } = await api.get<{ place: Place }>('/api/my/place');
		this.place = place;
	}

	async mutate(request: Promise<{ place: Place }>) {
		const { place } = await request;
		this.place = place;
		return place;
	}
}

const key = Symbol('editor');

export function setEditor(state: EditorState) {
	return setContext(key, state);
}

export function getEditor(): EditorState {
	return getContext(key);
}

export function clone<T>(value: T): T {
	return JSON.parse(JSON.stringify(value));
}

export function uid() {
	return Math.random().toString(36).slice(2, 12);
}
