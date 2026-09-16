import { error } from '@sveltejs/kit';
import { api, ApiError } from '$lib/api';
import type { Note, Paginated, Place } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params, url, depends }) => {
	depends('app:place');
	const username = params.username.toLowerCase();
	const before = Number(url.searchParams.get('before')) || null;
	try {
		const [place, notes] = await Promise.all([
			api.get<Place>(`/api/places/${username}?shell=1`, fetch),
			api.get<Paginated<Note>>(
				`/api/places/${username}/notes${before ? `?before=${before}` : ''}`,
				fetch
			)
		]);
		return { place, notes, before };
	} catch (e) {
		if (e instanceof ApiError && e.status === 404)
			error(404, { message: 'notes', code: 'not_found' });
		throw e;
	}
};
