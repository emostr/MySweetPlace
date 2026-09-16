import { api } from '$lib/api';
import type { Me } from '$lib/types';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async ({ data, fetch, depends }) => {
	depends('app:me');
	const me = await api.get<Me>('/api/me', fetch).catch((): Me => ({ user: null, place: null }));
	return { ...data, me };
};
