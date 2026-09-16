import { redirect } from '@sveltejs/kit';
import { api, query } from '$lib/api';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ fetch, url, setHeaders }) => {
	setHeaders({ 'cache-control': 'no-store' });
	const result = await api
		.get<{ username: string }>(
			`/api/places/random${query({ except: url.searchParams.get('from') })}`,
			fetch
		)
		.catch(() => null);
	if (result) redirect(303, `/@${result.username}`);
	return {};
};
