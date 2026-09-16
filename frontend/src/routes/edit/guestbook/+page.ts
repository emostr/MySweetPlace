import { api, query } from '$lib/api';
import type { GuestbookEntry, Paginated } from '$lib/types';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, url, depends }) => {
	depends('app:editor-guestbook');
	const status = url.searchParams.get('status') ?? '';
	const before = url.searchParams.get('before') ?? '';
	const result = await api.get<Paginated<GuestbookEntry> & { counts: Record<string, number> }>(
		`/api/my/guestbook${query({ status, before })}`,
		fetch
	);
	return { ...result, status };
};
