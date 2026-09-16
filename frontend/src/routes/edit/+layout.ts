import { redirect } from '@sveltejs/kit';
import { api } from '$lib/api';
import type { Place } from '$lib/types';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async ({ parent, fetch }) => {
	const { me } = await parent();
	if (!me.user) redirect(303, '/login?next=/edit');
	const { place } = await api.get<{ place: Place }>('/api/my/place', fetch);
	return { place };
};
