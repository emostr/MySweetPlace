<script lang="ts" generics="T">
	import type { Snippet } from 'svelte';
	import ArrowUp from '@lucide/svelte/icons/arrow-up';
	import ArrowDown from '@lucide/svelte/icons/arrow-down';
	import X from '@lucide/svelte/icons/x';
	import Plus from '@lucide/svelte/icons/plus';
	import { getI18n } from '$lib/i18n';

	let {
		items = $bindable(),
		create,
		addLabel,
		max = 100,
		item
	}: {
		items: T[];
		create: () => T;
		addLabel: string;
		max?: number;
		item: Snippet<[T, number]>;
	} = $props();

	const i18n = getI18n();

	function move(index: number, delta: number) {
		const next = [...items];
		const [moved] = next.splice(index, 1);
		next.splice(index + delta, 0, moved);
		items = next;
	}
</script>

<div class="list-editor">
	{#each items as entry, index (index)}
		<div class="list-item">
			<div class="list-body">{@render item(entry, index)}</div>
			<div class="list-actions">
				<button
					type="button"
					class="icon-btn"
					title={i18n.t.common.up}
					disabled={index === 0}
					onclick={() => move(index, -1)}><ArrowUp size={14} /></button
				>
				<button
					type="button"
					class="icon-btn"
					title={i18n.t.common.down}
					disabled={index === items.length - 1}
					onclick={() => move(index, 1)}><ArrowDown size={14} /></button
				>
				<button
					type="button"
					class="icon-btn"
					title={i18n.t.common.remove}
					onclick={() => (items = items.filter((_, i) => i !== index))}><X size={14} /></button
				>
			</div>
		</div>
	{/each}
	{#if items.length < max}
		<button
			type="button"
			class="btn btn-light btn-sm add"
			onclick={() => (items = [...items, create()])}
		>
			<Plus size={14} />
			{addLabel}
		</button>
	{/if}
</div>

<style>
	.list-editor {
		display: grid;
		gap: 8px;
	}

	.list-item {
		display: flex;
		gap: 6px;
		padding: 10px 6px 10px 10px;
		background: #fafafb;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	.list-body {
		flex: 1;
		min-width: 0;
	}

	.list-body :global(.field:last-child) {
		margin-bottom: 0;
	}

	.list-actions {
		display: flex;
		flex-direction: column;
		gap: 2px;
	}

	.add {
		justify-self: start;
	}
</style>
