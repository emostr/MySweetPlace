import type { ParamMatcher } from '@sveltejs/kit';

export const match: ParamMatcher = (param) => /^[A-Za-z0-9][A-Za-z0-9_-]{1,29}$/.test(param);
