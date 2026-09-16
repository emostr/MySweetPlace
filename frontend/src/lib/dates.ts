import type { Locale } from '$lib/i18n';

export function validTimeZone(zone: string | undefined | null) {
	if (!zone) return null;
	try {
		new Intl.DateTimeFormat('en', { timeZone: zone });
		return zone;
	} catch {
		return null;
	}
}

export function formatDate(
	value: string | Date,
	locale: Locale,
	timeZone: string,
	options: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'long', year: 'numeric' }
) {
	return new Intl.DateTimeFormat(locale, { timeZone, ...options }).format(new Date(value));
}

export function formatDateTime(value: string | Date, locale: Locale, timeZone: string) {
	return formatDate(value, locale, timeZone, {
		day: 'numeric',
		month: 'long',
		year: 'numeric',
		hour: '2-digit',
		minute: '2-digit'
	});
}

export function formatPartialDate(value: string, locale: Locale) {
	const [year, month, day] = value.split('-').map(Number);
	if (!year) return '';
	if (!month) return String(year);
	const date = new Date(Date.UTC(year, month - 1, day || 1));
	const options: Intl.DateTimeFormatOptions = day
		? { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' }
		: { month: 'long', year: 'numeric', timeZone: 'UTC' };
	return new Intl.DateTimeFormat(locale, options).format(date);
}

export function formatShortDate(value: string, locale: Locale, timeZone: string, withTime = true) {
	const date = new Date(value);
	const sameYear =
		new Intl.DateTimeFormat('en', { timeZone, year: 'numeric' }).format(date) ===
		new Intl.DateTimeFormat('en', { timeZone, year: 'numeric' }).format(new Date());
	return formatDate(value, locale, timeZone, {
		day: 'numeric',
		month: 'short',
		...(sameYear ? {} : { year: 'numeric' }),
		...(withTime && sameYear ? { hour: '2-digit', minute: '2-digit' } : {})
	});
}
