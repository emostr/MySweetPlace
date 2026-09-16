import { defineConfig } from 'vitest/config';
import adapter from '@sveltejs/adapter-node';
import { sveltekit } from '@sveltejs/kit/vite';

const api = process.env.API_INTERNAL_URL ?? 'http://127.0.0.1:3000';
const proxy = { '/api': { target: api, changeOrigin: false } };

const embeds = [
	'https://www.youtube-nocookie.com',
	'https://open.spotify.com',
	'https://music.yandex.ru',
	'https://w.soundcloud.com',
	'https://embed.music.apple.com',
	'https://rutube.ru',
	'https://player.vimeo.com',
	'https://codepen.io',
	'https://vk.com',
	'https://vkvideo.ru'
];

export default defineConfig({
	plugins: [
		sveltekit({
			compilerOptions: {
				// Force runes mode for the project, except for libraries. Can be removed in svelte 6.
				runes: ({ filename }) =>
					filename.split(/[/\\]/).includes('node_modules') ? undefined : true
			},
			adapter: adapter({ precompress: true }),
			csp: {
				mode: 'auto',
				directives: {
					'default-src': ['self'],
					'script-src': ['self'],
					'style-src': ['self', 'unsafe-inline'],
					'img-src': ['self', 'data:', 'blob:'],
					'font-src': ['self', 'data:'],
					'connect-src': ['self'],
					'frame-src': embeds as never[],
					'object-src': ['none'],
					'base-uri': ['self'],
					'form-action': ['self'],
					'frame-ancestors': ['none']
				}
			}
		})
	],
	server: { proxy },
	preview: { proxy },
	test: {
		expect: { requireAssertions: true },
		projects: [
			{
				extends: './vite.config.ts',
				test: {
					name: 'server',
					environment: 'node',
					include: ['src/**/*.{test,spec}.{js,ts}'],
					exclude: ['src/**/*.svelte.{test,spec}.{js,ts}']
				}
			}
		]
	}
});
