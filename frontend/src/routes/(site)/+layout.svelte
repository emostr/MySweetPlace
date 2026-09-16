<script lang="ts">
	import Header from '$lib/components/site/Header.svelte';
	import Footer from '$lib/components/site/Footer.svelte';
	import Garland from '$lib/components/season/Garland.svelte';

	let { data, children } = $props();
</script>

<div id="top" class="wrapper">
	{#if data.season === 'festive'}<Garland />{/if}
	<Header me={data.me} />
	<main>
		{@render children()}
	</main>
	<Footer motto={data.motto} />
</div>

<style>
	.wrapper {
		position: relative;
		display: flex;
		flex-direction: column;
		width: var(--wrapper);
		max-width: 100%;
		min-height: 100vh;
		margin: 0 auto;
		background: var(--paper);
		box-shadow: 0 0 6px rgba(0, 0, 0, 0.15);
	}

	main {
		flex: 1;
	}
</style>
