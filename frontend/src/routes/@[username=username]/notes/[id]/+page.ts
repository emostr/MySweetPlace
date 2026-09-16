import { error } from '@sveltejs/kit';
import { api, ApiError } from '$lib/api';
import type { Note, Place } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params, depends }) => {
	depends('app:place');
	if (!/^\d+$/.test(params.id)) error(404, { message: 'note', code: 'not_found' });
	try {
		return await api.get<{ note: Note; place: Place }>(
			`/api/places/${params.username.toLowerCase()}/notes/${params.id}`,
			fetch
		);
	} catch (e) {
		if (e instanceof ApiError && e.status === 404)
			error(404, { message: 'note', code: 'not_found' });
		throw e;
	}
};
