<script lang="ts">
	import Header from '$lib/components/site/Header.svelte';
	import Footer from '$lib/components/site/Footer.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
</script>

<div class="wrapper">
	<Header me={data.me} />
	<main class="empty">
		<img src="/images/niki.png" alt="" width="200" height="150" />
		<p>{i18n.t.random.empty}</p>
		<a class="btn" href="/">{i18n.t.errors.home}</a>
	</main>
	<Footer motto={data.motto} />
</div>

<style>
	.wrapper {
		width: var(--wrapper);
		max-width: 100%;
		margin: 0 auto;
		background: var(--paper);
	}

	.empty {
		display: grid;
		gap: 12px;
		justify-items: center;
		padding: 80px 16px;
		text-align: center;
	}
</style>
