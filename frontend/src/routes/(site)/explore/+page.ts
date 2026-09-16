import { api, query } from '$lib/api';
import type { Paginated, PlaceCard } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, url }) => {
	const interest = url.searchParams.get('interest') ?? '';
	const q = url.searchParams.get('q') ?? '';
	const page = Math.max(1, Number(url.searchParams.get('page')) || 1);

	const [places, interests] = await Promise.all([
		api.get<Paginated<PlaceCard> & { page: number }>(
			`/api/places${query({ interest, q, page })}`,
			fetch
		),
		api.get<{ items: { label: string; count: number }[] }>('/api/interests', fetch)
	]);
	return { places, interests: interests.items, interest, q, page };
};
