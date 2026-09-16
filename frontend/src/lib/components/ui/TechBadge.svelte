<script lang="ts">
	import BrandIcon from './BrandIcon.svelte';
	import type { ResolvedTech } from '$lib/stack';

	let { tech, mode = 'badge' }: { tech: ResolvedTech; mode?: 'badge' | 'icon' } = $props();
	const monogram = $derived(tech.name.replace(/[^\p{L}\p{N}#+]/gu, '').slice(0, 2) || '?');
</script>

<span class="tech {mode}" style="--brand: {tech.color}" title={tech.name}>
	<span class="glyph">
		{#if tech.icon}
			<BrandIcon slug={tech.id} />
		{:else}
			<span class="monogram">{monogram}</span>
		{/if}
	</span>
	<span class="name">{tech.name}</span>
</span>

<style>
	.tech {
		display: inline-flex;
		align-items: center;
		gap: 6px;
		min-width: 0;
	}

	.badge {
		padding: 2px 10px 2px 6px;
		font-size: 0.88em;
		line-height: 1.7;
		background: color-mix(in srgb, var(--brand) 10%, var(--p-surface, #fff));
		border: 1px solid color-mix(in srgb, var(--brand) 35%, var(--p-border, #ddd));
		border-radius: 999px;
	}

	.glyph {
		display: inline-grid;
		place-items: center;
		color: color-mix(in srgb, var(--brand) 85%, var(--p-text, #333));
	}

	.monogram {
		display: inline-grid;
		place-items: center;
		min-width: 1.35em;
		height: 1.35em;
		padding: 0 2px;
		font: bold 0.62em/1 var(--p-font, Arial, sans-serif);
		color: #fff;
		background: var(--brand);
		border-radius: 3px;
	}

	.icon {
		flex-direction: column;
		gap: 4px;
		width: 72px;
		font-size: 0.78em;
		text-align: center;
	}

	.icon .glyph {
		width: 44px;
		height: 44px;
		font-size: 24px;
		background: color-mix(in srgb, var(--brand) 10%, var(--p-surface, #fff));
		border: 1px solid color-mix(in srgb, var(--brand) 30%, var(--p-border, #ddd));
		border-radius: 12px;
	}

	.icon .monogram {
		font-size: 0.5em;
	}

	.icon .name {
		max-width: 100%;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		color: var(--p-muted, #666);
	}
</style>
