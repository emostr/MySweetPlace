import { getContext, setContext } from 'svelte';

export interface PlaceContext {
	readonly preview: boolean;
	refresh(): Promise<void>;
}

const key = Symbol('place');

export function setPlaceContext(context: PlaceContext) {
	return setContext(key, context);
}

export function getPlaceContext(): PlaceContext {
	return getContext(key) ?? { preview: false, refresh: async () => {} };
}
