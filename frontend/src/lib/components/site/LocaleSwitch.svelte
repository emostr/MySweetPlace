<script lang="ts">
	import { invalidateAll } from '$app/navigation';
	import { api } from '$lib/api';
	import { getI18n, type Locale } from '$lib/i18n';

	let { signedIn = false, tone = 'dark' }: { signedIn?: boolean; tone?: 'dark' | 'light' } =
		$props();
	const i18n = getI18n();
	const next = $derived<Locale>(i18n.locale === 'ru' ? 'en' : 'ru');

	async function change() {
		const locale = next;
		document.cookie = `locale=${locale}; path=/; max-age=31536000; samesite=lax`;
		document.documentElement.lang = locale;
		if (signedIn) api.patch('/api/me', { locale }).catch(() => {});
		await invalidateAll();
	}
</script>

<button class="locale {tone}" onclick={change} aria-label={i18n.t.common.language} lang={next}>
	{next === 'en' ? 'EN' : 'RU'}
</button>

<style>
	.locale {
		padding: 2px 7px;
		font: bold 11px/1.6 var(--sans);
		letter-spacing: 1px;
		background: none;
		border: 1px solid;
		border-radius: 3px;
		cursor: pointer;
	}

	.dark {
		color: var(--bar-ink);
		border-color: rgba(255, 255, 255, 0.25);
	}

	.dark:hover {
		color: #fff;
		border-color: rgba(255, 255, 255, 0.6);
	}

	.light {
		color: inherit;
		border-color: currentColor;
		opacity: 0.75;
	}

	.light:hover {
		opacity: 1;
	}
</style>
