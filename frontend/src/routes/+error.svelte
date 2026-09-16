<script lang="ts">
	import { page } from '$app/state';
	import Header from '$lib/components/site/Header.svelte';
	import Footer from '$lib/components/site/Footer.svelte';
	import { getI18n } from '$lib/i18n';
	import type { Me } from '$lib/types';

	const i18n = getI18n();
	const me = $derived((page.data.me as Me | undefined) ?? { user: null, place: null });
	const missing = $derived(page.status === 404);
	const placeMissing = $derived(page.error?.code === 'place_not_found');

	const title = $derived(
		placeMissing ? i18n.t.place.notFound : missing ? i18n.t.errors.notFound : i18n.t.errors.server
	);
	const text = $derived(
		placeMissing
			? i18n.t.place.notFoundText
			: missing
				? i18n.t.errors.notFoundText
				: i18n.t.errors.serverText
	);
</script>

<svelte:head><title>{title} — MySweetPlace</title></svelte:head>

<div class="wrapper">
	<Header {me} />
	<main class="error">
		<img src="/images/niki.png" alt={i18n.t.site.mascotAlt} width="200" height="150" />
		<p class="status">{page.status}</p>
		<h1>{title}</h1>
		<p class="muted">{text}</p>
		<p class="row">
			<a class="btn" href="/">{i18n.t.errors.home}</a>
			<a class="btn btn-light" href="/random" data-sveltekit-preload-data="off"
				>{i18n.t.site.takeMeSomewhere}</a
			>
		</p>
	</main>
	<Footer motto={(page.data.motto as string | undefined) ?? ''} />
</div>

<style>
	.wrapper {
		display: flex;
		flex-direction: column;
		width: var(--wrapper);
		max-width: 100%;
		min-height: 100vh;
		margin: 0 auto;
		background: var(--paper);
		box-shadow: 0 0 6px rgba(0, 0, 0, 0.15);
	}

	.error {
		flex: 1;
		display: grid;
		align-content: center;
		justify-items: center;
		gap: 6px;
		padding: 60px 16px;
		text-align: center;
	}

	.status {
		margin: 0;
		font: bold 12px var(--sans);
		letter-spacing: 3px;
		color: var(--accent);
	}

	h1 {
		font-size: 28px;
	}

	.row {
		justify-content: center;
		margin-top: 10px;
	}
</style>
