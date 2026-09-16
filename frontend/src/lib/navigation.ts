export function safeNext(value: string | null | undefined, fallback: string) {
	return value && value.startsWith('/') && !value.startsWith('//') ? value : fallback;
}
