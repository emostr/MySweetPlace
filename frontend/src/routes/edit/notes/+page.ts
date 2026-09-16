import { api } from '$lib/api';
import type { Note, Paginated } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, parent, url, depends }) => {
	depends('app:editor-notes');
	const { place } = await parent();
	const before = Number(url.searchParams.get('before')) || null;
	const notes = await api.get<Paginated<Note>>(
		`/api/places/${place.username}/notes${before ? `?before=${before}` : ''}`,
		fetch
	);
	return { notes, before };
};
