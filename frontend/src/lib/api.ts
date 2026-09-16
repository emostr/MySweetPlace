export type Fetch = typeof fetch;

export class ApiError extends Error {
	constructor(
		public status: number,
		public code: string,
		message: string,
		public fields: Record<string, string[]> = {}
	) {
		super(message);
	}

	field(name: string): string | undefined {
		return this.fields[name]?.[0];
	}
}

async function request<T>(method: string, path: string, body?: unknown, fetchFn: Fetch = fetch) {
	const headers: Record<string, string> = { accept: 'application/json' };
	const init: RequestInit = { method, headers, credentials: 'same-origin' };

	if (body instanceof FormData) {
		init.body = body;
	} else if (body !== undefined) {
		headers['content-type'] = 'application/json';
		init.body = JSON.stringify(body);
	}

	let response: Response;
	try {
		response = await fetchFn(path, init);
	} catch {
		throw new ApiError(0, 'network', 'Network error');
	}

	if (response.status === 204) return undefined as T;
	const data = await response.json().catch(() => ({}));
	if (!response.ok) {
		throw new ApiError(
			response.status,
			data.error ?? 'error',
			data.message ?? response.statusText,
			data.fields
		);
	}
	return data as T;
}

export const api = {
	get: <T>(path: string, fetchFn?: Fetch) => request<T>('GET', path, undefined, fetchFn),
	post: <T>(path: string, body?: unknown, fetchFn?: Fetch) =>
		request<T>('POST', path, body, fetchFn),
	patch: <T>(path: string, body?: unknown) => request<T>('PATCH', path, body),
	put: <T>(path: string, body?: unknown) => request<T>('PUT', path, body),
	delete: <T = void>(path: string, body?: unknown) => request<T>('DELETE', path, body)
};

export function query(params: Record<string, string | number | null | undefined>) {
	const search = new URLSearchParams();
	for (const [key, value] of Object.entries(params)) {
		if (value !== null && value !== undefined && value !== '') search.set(key, String(value));
	}
	const string = search.toString();
	return string ? `?${string}` : '';
}
