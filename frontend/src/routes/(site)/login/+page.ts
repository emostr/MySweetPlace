import { redirect } from '@sveltejs/kit';
import { safeNext } from '$lib/navigation';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ parent, url }) => {
	const { me } = await parent();
	if (me.user) redirect(303, safeNext(url.searchParams.get('next'), '/edit'));
};
