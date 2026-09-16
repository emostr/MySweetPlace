import type { Handle, HandleFetch } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';
import { detectLocale } from '$lib/i18n';
import { validTimeZone } from '$lib/dates';

const apiOrigin = () => env.API_INTERNAL_URL || 'http://127.0.0.1:3000';

export const handle: Handle = async ({ event, resolve }) => {
	const locale = detectLocale(
		event.cookies.get('locale'),
		event.request.headers.get('accept-language')
	);
	event.locals.locale = locale;
	event.locals.timeZone = validTimeZone(event.cookies.get('tz')) ?? 'Europe/Moscow';

	const response = await resolve(event, {
		transformPageChunk: ({ html }) => html.replace('%lang%', locale)
	});
	response.headers.set('x-content-type-options', 'nosniff');
	response.headers.set('referrer-policy', 'strict-origin-when-cross-origin');
	return response;
};

export const handleFetch: HandleFetch = async ({ event, request, fetch }) => {
	const url = new URL(request.url);
	if (url.origin !== event.url.origin || !url.pathname.startsWith('/api/')) return fetch(request);

	const headers = new Headers(request.headers);
	const cookie = event.request.headers.get('cookie');
	if (cookie) headers.set('cookie', cookie);
	headers.set('x-locale', event.locals.locale);
	headers.set('x-forwarded-for', event.getClientAddress());

	return fetch(
		new Request(new URL(url.pathname + url.search, apiOrigin()), {
			method: request.method,
			headers,
			body: request.body,
			redirect: 'manual',
			duplex: 'half'
		} as RequestInit)
	);
};
