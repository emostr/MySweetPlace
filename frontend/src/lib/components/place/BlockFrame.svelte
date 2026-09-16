<script lang="ts">
	import type { Snippet } from 'svelte';
	import EyeOff from '@lucide/svelte/icons/eye-off';
	import { blockTitle } from '$lib/blocks';
	import { getI18n } from '$lib/i18n';
	import { contrastInk } from '$lib/theme/style';
	import type { Block } from '$lib/types';

	let { block, children }: { block: Block; children: Snippet } = $props();
	const i18n = getI18n();

	const title = $derived(blockTitle(block, i18n));
	const plain = $derived(block.style.variant === 'plain');
	const accent = $derived(
		block.style.accent
			? `--p-accent: ${block.style.accent}; --p-accent-ink: ${contrastInk(block.style.accent)}`
			: undefined
	);
</script>

<section
	id="block-{block.id}"
	class="block kind-{block.kind}"
	class:half={block.style.width === 'half'}
	class:plain
	class:is-hidden={!block.visible}
	style={accent}
	aria-label={title}
>
	{#if !block.visible}
		<p class="hidden-note"><EyeOff size={13} /> {i18n.t.place.hiddenBlock}</p>
	{/if}
	{#if block.kind !== 'intro' && !block.style.hide_title}
		<h2 class="block-title">{title}</h2>
	{/if}
	{@render children()}
</section>

<style>
	.hidden-note {
		display: flex;
		gap: 6px;
		align-items: center;
		margin: -6px 0 10px;
		font-size: 0.78em;
		color: var(--p-muted);
	}
</style>
