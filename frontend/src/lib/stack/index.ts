import { CATALOG, type StackCategory, type Tech } from './catalog';
import type { StackItem } from '$lib/types';

export { CATALOG, STACK_CATEGORIES, type StackCategory, type Tech } from './catalog';

export type TechCategory = StackCategory | 'other';
export type ResolvedTech = Omit<Tech, 'category'> & { category: TechCategory };

const byId = new Map(CATALOG.map((tech) => [tech.id, tech]));
const byName = new Map(CATALOG.map((tech) => [tech.name.toLowerCase(), tech]));

export function findTech(value: string): Tech | undefined {
	const key = value.trim().toLowerCase();
	return byId.get(key) ?? byName.get(key);
}

export function customTech(name: string, color?: string | null): ResolvedTech {
	return { id: name, name, category: 'other', color: color || '#6b6f76', icon: false };
}

export function resolveStackItem(item: Pick<StackItem, 'slug' | 'name' | 'color'>): ResolvedTech {
	return (item.slug && byId.get(item.slug)) || customTech(item.name || item.slug, item.color);
}

export function searchTech(query: string, limit = 40) {
	const q = query.trim().toLowerCase();
	if (!q) return [];
	return CATALOG.filter((tech) => tech.name.toLowerCase().includes(q) || tech.id.includes(q))
		.sort(
			(a, b) =>
				Number(!a.name.toLowerCase().startsWith(q)) - Number(!b.name.toLowerCase().startsWith(q))
		)
		.slice(0, limit);
}
