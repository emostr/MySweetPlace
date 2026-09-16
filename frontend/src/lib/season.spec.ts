import { describe, expect, it } from 'vitest';
import { detectSeason } from './season';

describe('detectSeason', () => {
	it('snows in winter and celebrates around new year', () => {
		expect(detectSeason(new Date('2026-09-16'))).toBe('none');
		expect(detectSeason(new Date('2026-12-01'))).toBe('winter');
		expect(detectSeason(new Date('2026-12-31'))).toBe('festive');
		expect(detectSeason(new Date('2027-01-07'))).toBe('festive');
		expect(detectSeason(new Date('2027-02-20'))).toBe('winter');
	});

	it('can be overridden', () => {
		expect(detectSeason(new Date('2026-07-01'), 'winter')).toBe('winter');
		expect(detectSeason(new Date('2026-12-31'), 'none')).toBe('none');
		expect(detectSeason(new Date('2026-12-31'), 'summer')).toBe('festive');
	});
});
