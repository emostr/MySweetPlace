<script lang="ts">
	import { fontUrls } from '$lib/theme/fonts';
	import type { Theme } from '$lib/types';

	let { theme }: { theme: Theme } = $props();
	const urls = $derived(fontUrls(theme.font, theme.heading_font));
</script>

<svelte:head>
	{#each urls as url (url)}
		<link rel="stylesheet" href={url} />
	{/each}
</svelte:head>
