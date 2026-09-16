<script lang="ts">
	import RichText from '$lib/components/ui/RichText.svelte';
	import { getI18n } from '$lib/i18n';
	import { formatPartialDate } from '$lib/dates';
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'now'> } = $props();
	const i18n = getI18n();
	const text = $derived(i18n.pick(block.data.text));
</script>

<div class="now {block.style.variant}">
	{#if text}<div class="text"><RichText {text} /></div>{/if}
	{#if block.data.items.length}
		<ul>
			{#each block.data.items as item (item.id)}
				<li>
					<span class="emoji">{item.emoji || '•'}</span>
					<span>{i18n.pick(item.text)}</span>
				</li>
			{/each}
		</ul>
	{/if}
	{#if block.data.updated_on}
		<p class="updated">
			{i18n.t.blocks.now.updated(formatPartialDate(block.data.updated_on, i18n.locale))}
		</p>
	{/if}
</div>

<style>
	.text {
		margin-bottom: 10px;
	}

	ul {
		display: grid;
		gap: 6px;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	li {
		display: flex;
		gap: 10px;
		align-items: baseline;
	}

	.emoji {
		flex: none;
		width: 1.5em;
		text-align: center;
	}

	.card ul {
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 8px;
	}

	.card li {
		padding: 8px 10px;
		background: color-mix(in srgb, var(--p-accent) 7%, var(--p-surface));
		border-radius: min(var(--p-radius), 8px);
	}

	.updated {
		margin: 12px 0 0;
		font-size: 0.8em;
		color: var(--p-muted);
	}
</style>
