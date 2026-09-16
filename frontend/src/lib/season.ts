export type Season = 'none' | 'winter' | 'festive';

const SEASONS: Season[] = ['none', 'winter', 'festive'];

export function detectSeason(date: Date, override?: string | null): Season {
	if (SEASONS.includes(override as Season)) return override as Season;
	const month = date.getUTCMonth() + 1;
	const day = date.getUTCDate();
	if ((month === 12 && day >= 15) || (month === 1 && day <= 14)) return 'festive';
	if (month === 12 || month === 1 || month === 2) return 'winter';
	return 'none';
}
