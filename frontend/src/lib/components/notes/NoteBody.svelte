<script lang="ts">
	import Embed from './Embed.svelte';
	import { findEmbeds } from '$lib/embeds';
	import type { Note } from '$lib/types';

	let { note, compact = false }: { note: Note; compact?: boolean } = $props();
	const embeds = $derived(compact ? [] : findEmbeds(note.body));
</script>

<div class="note-body" class:compact>
	<!-- eslint-disable-next-line svelte/no-at-html-tags -- rendered and sanitized by the api -->
	{@html note.body_html}
</div>

{#if note.images.length}
	<div class="images count-{Math.min(note.images.length, 4)}" class:compact>
		{#each note.images as image (image.id)}
			<a href={image.url} target="_blank" rel="noopener">
				<img src={image.url} alt="" loading="lazy" width={image.width} height={image.height} />
			</a>
		{/each}
	</div>
{/if}

{#each embeds as embed (embed.src)}
	<Embed {embed} />
{/each}

<style>
	.note-body {
		overflow-wrap: anywhere;
	}

	.note-body :global(p) {
		margin: 0 0 0.6em;
	}

	.note-body :global(p:last-child) {
		margin-bottom: 0;
	}

	.note-body :global(a) {
		color: var(--p-accent, var(--accent));
	}

	.note-body :global(code) {
		padding: 1px 4px;
		font:
			0.9em 'JetBrains Mono',
			'PT Mono',
			'Courier New',
			monospace;
		background: color-mix(in srgb, var(--p-text, #333) 8%, transparent);
		border-radius: 3px;
	}

	.note-body :global(pre) {
		margin: 0.6em 0;
		padding: 10px 12px;
		overflow-x: auto;
		font-size: 0.9em;
		line-height: 1.5;
		background: color-mix(in srgb, var(--p-text, #333) 6%, transparent);
		border: 1px solid color-mix(in srgb, var(--p-text, #333) 10%, transparent);
		border-radius: 4px;
	}

	.note-body :global(pre code) {
		padding: 0;
		background: none;
	}

	.note-body :global(blockquote) {
		margin: 0.6em 0;
		padding: 2px 0 2px 12px;
		color: var(--p-muted, var(--ink-soft));
		border-left: 3px solid color-mix(in srgb, var(--p-accent, #7a2531) 50%, transparent);
	}

	.note-body :global(ul),
	.note-body :global(ol) {
		margin: 0.4em 0 0.6em;
		padding-left: 1.4em;
	}

	.note-body :global(hr) {
		border: 0;
		border-top: 1px dashed color-mix(in srgb, var(--p-text, #333) 25%, transparent);
	}

	.note-body :global(.k),
	.note-body :global(.kd),
	.note-body :global(.kn),
	.note-body :global(.kr),
	.note-body :global(.nt) {
		color: color-mix(in srgb, var(--p-accent, #7a2531) 80%, var(--p-text, #333));
		font-weight: bold;
	}

	.note-body :global(.s),
	.note-body :global(.s1),
	.note-body :global(.s2),
	.note-body :global(.sr),
	.note-body :global(.ss),
	.note-body :global(.dl) {
		color: color-mix(in srgb, #2e8b57 75%, var(--p-text, #333));
	}

	.note-body :global(.c),
	.note-body :global(.c1),
	.note-body :global(.cm),
	.note-body :global(.cp) {
		font-style: italic;
		color: var(--p-muted, var(--ink-soft));
	}

	.note-body :global(.mi),
	.note-body :global(.mf),
	.note-body :global(.kc),
	.note-body :global(.no) {
		color: color-mix(in srgb, #c06a1b 75%, var(--p-text, #333));
	}

	.note-body :global(.nf),
	.note-body :global(.nc),
	.note-body :global(.nb),
	.note-body :global(.na),
	.note-body :global(.nv) {
		color: color-mix(in srgb, #3a6db5 75%, var(--p-text, #333));
	}

	.images {
		display: grid;
		gap: 4px;
		margin-top: 10px;
		overflow: hidden;
		border-radius: 6px;
	}

	.images a {
		display: block;
		min-height: 0;
	}

	.images img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.count-1 img {
		max-height: 520px;
		object-fit: contain;
		background: color-mix(in srgb, var(--p-text, #333) 5%, transparent);
	}

	.count-2 {
		grid-template-columns: 1fr 1fr;
		aspect-ratio: 2 / 1;
	}

	.count-3 {
		grid-template-columns: 2fr 1fr;
		grid-template-rows: 1fr 1fr;
		aspect-ratio: 3 / 2;
	}

	.count-3 a:first-child {
		grid-row: span 2;
	}

	.count-4 {
		grid-template-columns: 1fr 1fr;
		aspect-ratio: 1 / 1;
	}

	.compact.images {
		max-width: 320px;
	}
</style>
