import { api } from '$lib/api';
import type { PlaceCard } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, depends }) => {
	depends('app:editor-neighbours');
	return await api.get<{ items: PlaceCard[]; neighbour_of: PlaceCard[] }>(
		'/api/my/neighbours',
		fetch
	);
};
