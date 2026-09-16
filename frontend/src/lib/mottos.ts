export const MOTTOS = [
	'Pale skin so cold to the touch\nLike a rose in bloom when we blush',
	'We’re all alone until we turn back to dust'
];

export function randomMotto() {
	const filled = MOTTOS.filter((motto) => motto.trim() !== '');
	return filled[Math.floor(Math.random() * filled.length)] ?? '';
}
