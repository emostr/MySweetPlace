<script lang="ts">
	import { getI18n } from '$lib/i18n';
	import { formatPartialDate } from '$lib/dates';
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'timeline'> } = $props();
	const i18n = getI18n();

	const items = $derived(
		[...block.data.items].sort((a, b) =>
			block.data.order === 'asc' ? a.date.localeCompare(b.date) : b.date.localeCompare(a.date)
		)
	);
</script>

<ol class="timeline">
	{#each items as item (item.id)}
		<li>
			<span class="dot">{item.emoji || ''}</span>
			<time datetime={item.date}>{formatPartialDate(item.date, i18n.locale)}</time>
			<h3>{i18n.pick(item.title)}</h3>
			{#if i18n.pick(item.text)}<p>{i18n.pick(item.text)}</p>{/if}
		</li>
	{/each}
</ol>

<style>
	.timeline {
		position: relative;
		margin: 0;
		padding: 0 0 0 28px;
		list-style: none;
	}

	.timeline::before {
		content: '';
		position: absolute;
		top: 6px;
		bottom: 6px;
		left: 9px;
		width: 2px;
		background: color-mix(in srgb, var(--p-accent) 35%, var(--p-border));
	}

	li {
		position: relative;
		padding-bottom: 16px;
	}

	li:last-child {
		padding-bottom: 0;
	}

	.dot {
		position: absolute;
		top: 1px;
		left: -28px;
		display: grid;
		place-items: center;
		width: 20px;
		height: 20px;
		font-size: 11px;
		background: var(--p-surface);
		border: 2px solid var(--p-accent);
		border-radius: 50%;
	}

	time {
		font-size: 0.8em;
		color: var(--p-muted);
	}

	h3 {
		margin: 0;
		font-size: 1.05em;
	}

	p {
		margin: 2px 0 0;
		white-space: pre-line;
	}
</style>
