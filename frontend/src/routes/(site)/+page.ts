import { api } from '$lib/api';
import type { Note, PlaceCard } from '$lib/types';
import type { PageLoad } from './$types';

export interface Home {
	places: PlaceCard[];
	notes: Note[];
	stats: { places: number; notes: number };
}

export const load: PageLoad = async ({ fetch }) => {
	const home = await api
		.get<Home>('/api/home', fetch)
		.catch((): Home => ({ places: [], notes: [], stats: { places: 0, notes: 0 } }));
	return { home };
};
