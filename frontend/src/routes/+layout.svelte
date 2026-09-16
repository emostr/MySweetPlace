<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';
	import { createI18n, setI18n } from '$lib/i18n';
	import Snow from '$lib/components/season/Snow.svelte';

	let { data, children } = $props();

	setI18n(
		createI18n(
			() => data.locale,
			() => data.timeZone
		)
	);

	onMount(() => {
		const zone = Intl.DateTimeFormat().resolvedOptions().timeZone;
		if (zone && zone !== data.timeZone) {
			document.cookie = `tz=${encodeURIComponent(zone)}; path=/; max-age=31536000; samesite=lax`;
		}
	});
</script>

{@render children()}

{#if data.season !== 'none'}
	<Snow />
{/if}
