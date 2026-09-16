import type { Locale } from '$lib/i18n';

declare global {
	namespace App {
		interface Error {
			code?: string;
		}
		interface Locals {
			locale: Locale;
			timeZone: string;
		}
	}
}

export {};
