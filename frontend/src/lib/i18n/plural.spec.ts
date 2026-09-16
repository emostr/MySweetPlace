import { describe, expect, it } from 'vitest';
import { plural } from './plural';

const forms: [string, string, string] = ['запись', 'записи', 'записей'];

describe('plural', () => {
	it('follows russian rules', () => {
		expect([1, 2, 5, 11, 21, 22, 25, 111, 1001].map((n) => plural('ru', n, forms))).toEqual([
			'запись',
			'записи',
			'записей',
			'записей',
			'запись',
			'записи',
			'записей',
			'записей',
			'запись'
		]);
	});

	it('follows english rules', () => {
		expect(plural('en', 1, ['note', 'notes', 'notes'])).toBe('note');
		expect(plural('en', 21, ['note', 'notes', 'notes'])).toBe('notes');
	});
});
