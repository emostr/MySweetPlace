import { ApiError } from '$lib/api';
import type { I18n } from '$lib/i18n';

export function errorMessage(error: unknown, i18n: I18n) {
	if (error instanceof ApiError) {
		if (error.code === 'network') return i18n.t.common.network;
		const first = Object.values(error.fields ?? {})[0]?.[0];
		return first ? `${error.message}: ${first}` : error.message;
	}
	return i18n.t.common.error;
}

export function fieldErrors(error: unknown): Record<string, string> {
	if (!(error instanceof ApiError)) return {};
	return Object.fromEntries(
		Object.entries(error.fields ?? {}).map(([key, messages]) => [key, messages[0]])
	);
}
