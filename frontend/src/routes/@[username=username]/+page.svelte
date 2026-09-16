<script lang="ts">
	import { invalidate } from '$app/navigation';
	import { page } from '$app/state';
	import PlaceView from '$lib/components/place/PlaceView.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();

	const place = $derived(data.place);
	const name = $derived(i18n.pick(place.profile.name) || place.username);
	const description = $derived(
		i18n.pick(place.profile.tagline) || i18n.pick(place.profile.about).slice(0, 200)
	);
	const avatar = $derived(
		place.avatar_url ? new URL(place.avatar_url, page.url.origin).href : null
	);
</script>

<svelte:head>
	<title>{name} (@{place.username}) — MySweetPlace</title>
	{#if description}<meta name="description" content={description} />{/if}
	<meta property="og:type" content="profile" />
	<meta property="og:site_name" content="MySweetPlace" />
	<meta property="og:title" content="{name} (@{place.username})" />
	{#if description}<meta property="og:description" content={description} />{/if}
	{#if avatar}<meta property="og:image" content={avatar} />{/if}
	<meta name="theme-color" content={place.theme.colors.background} />
	{#if place.settings.noindex}<meta name="robots" content="noindex" />{/if}
</svelte:head>

<PlaceView
	{place}
	me={data.me}
	motto={data.motto}
	season={data.season}
	refresh={() => invalidate('app:place')}
/>
