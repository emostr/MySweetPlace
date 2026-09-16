import { getContext, setContext } from 'svelte';
import type { LocalizedText } from '$lib/types';
import ru from './ru';
import en from './en';

export const LOCALES = ['ru', 'en'] as const;
export type Locale = (typeof LOCALES)[number];
export type Messages = typeof ru;

const dictionaries: Record<Locale, Messages> = { ru, en };

export function isLocale(value: unknown): value is Locale {
	return LOCALES.includes(value as Locale);
}

export function detectLocale(cookie?: string | null, acceptLanguage?: string | null): Locale {
	if (isLocale(cookie)) return cookie;
	for (const part of (acceptLanguage ?? '').split(',')) {
		const code = part.trim().slice(0, 2).toLowerCase();
		if (isLocale(code)) return code;
	}
	return 'ru';
}

export interface I18n {
	readonly locale: Locale;
	readonly t: Messages;
	readonly timeZone: string;
	pick(text: LocalizedText | undefined | null): string;
}

const key = Symbol('i18n');

export function createI18n(getLocale: () => Locale, getTimeZone: () => string): I18n {
	return {
		get locale() {
			return getLocale();
		},
		get t() {
			return dictionaries[getLocale()];
		},
		get timeZone() {
			return getTimeZone();
		},
		pick(text) {
			return pickLocalized(text, getLocale());
		}
	};
}

export function setI18n(i18n: I18n) {
	return setContext(key, i18n);
}

export function getI18n(): I18n {
	return getContext(key);
}

export function pickLocalized(text: LocalizedText | undefined | null, locale: Locale) {
	if (!text) return '';
	return text[locale] || text.ru || text.en || '';
}

export { plural } from './plural';
