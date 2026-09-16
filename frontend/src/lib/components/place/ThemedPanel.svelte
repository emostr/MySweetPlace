<script lang="ts">
	import type { Snippet } from 'svelte';
	import './place.css';
	import ThemeFonts from './ThemeFonts.svelte';
	import { themeStyle } from '$lib/theme/style';
	import type { Theme, Upload } from '$lib/types';

	let {
		theme,
		uploads,
		children
	}: { theme: Theme; uploads: Record<string, Upload>; children: Snippet } = $props();
</script>

<ThemeFonts {theme} />

<div class="place themed-panel" data-cards={theme.cards.style} style={themeStyle(theme, uploads)}>
	<section class="block">
		{@render children()}
	</section>
</div>

<style>
	.themed-panel {
		min-height: 0;
		padding: 18px;
		border-radius: 4px;
		box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.08);
	}
</style>
