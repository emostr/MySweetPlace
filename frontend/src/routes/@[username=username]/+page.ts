import { error } from '@sveltejs/kit';
import { api, ApiError } from '$lib/api';
import type { Place } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params, depends }) => {
	depends('app:place');
	try {
		const place = await api.get<Place>(`/api/places/${params.username.toLowerCase()}`, fetch);
		return { place };
	} catch (e) {
		if (e instanceof ApiError && e.status === 404)
			error(404, { message: 'place', code: 'place_not_found' });
		throw e;
	}
};
