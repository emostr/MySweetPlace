import { env } from '$env/dynamic/private';
import { detectSeason } from '$lib/season';
import { randomMotto } from '$lib/mottos';
import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = async ({ locals, url }) => {
	return {
		locale: locals.locale,
		timeZone: locals.timeZone,
		season: detectSeason(new Date(), url.searchParams.get('season') ?? env.SEASON),
		motto: randomMotto()
	};
};
