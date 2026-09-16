<script lang="ts">
	import type { Snippet } from 'svelte';
	import './place.css';
	import PlaceBar from './PlaceBar.svelte';
	import ThemeFonts from './ThemeFonts.svelte';
	import { setPlaceContext } from './context';
	import Footer from '$lib/components/site/Footer.svelte';
	import Garland from '$lib/components/season/Garland.svelte';
	import { themeStyle } from '$lib/theme/style';
	import type { Season } from '$lib/season';
	import type { Me, Place } from '$lib/types';

	let {
		place,
		me,
		motto = '',
		season = 'none',
		preview = false,
		refresh = async () => {},
		children
	}: {
		place: Place;
		me: Me;
		motto?: string;
		season?: Season;
		preview?: boolean;
		refresh?: () => Promise<void>;
		children: Snippet;
	} = $props();

	setPlaceContext({
		get preview() {
			return preview;
		},
		refresh: () => refresh()
	});
</script>

<ThemeFonts theme={place.theme} />

<div
	class="place"
	class:preview
	data-cards={place.theme.cards.style}
	style={themeStyle(place.theme, place.uploads)}
>
	{#if !preview}
		{#if season === 'festive'}<Garland />{/if}
		<PlaceBar {place} {me} />
	{/if}

	<main class="place-main">
		{@render children()}
	</main>

	{#if !preview}
		<Footer {motto} />
	{/if}
</div>

<style>
	.preview {
		min-height: 100%;
	}

	.place :global(.site-footer) {
		font-family: var(--sans);
	}
</style>
