<script lang="ts">
	import X from '@lucide/svelte/icons/x';
	import { BLOCK_ICONS, BLOCK_KINDS, MULTIPLE } from '$lib/blocks';
	import { getI18n } from '$lib/i18n';
	import type { BlockKind } from '$lib/types';

	let {
		existing,
		onpick,
		onclose
	}: { existing: BlockKind[]; onpick: (kind: BlockKind) => void; onclose: () => void } = $props();
	const i18n = getI18n();
	const taken = (kind: BlockKind) => !MULTIPLE.includes(kind) && existing.includes(kind);
</script>

<div class="picker panel">
	<div class="head">
		<h3>{i18n.t.editor.blocks.choose}</h3>
		<button class="icon-btn" onclick={onclose} aria-label={i18n.t.common.close}
			><X size={16} /></button
		>
	</div>
	<div class="kinds">
		{#each BLOCK_KINDS as kind (kind)}
			{@const Icon = BLOCK_ICONS[kind]}
			<button class="kind" disabled={taken(kind)} onclick={() => onpick(kind)}>
				<span class="icon"><Icon size={18} /></span>
				<span>
					<strong>{i18n.t.blocks.titles[kind]}</strong>
					<small
						>{taken(kind) ? i18n.t.editor.blocks.already : i18n.t.blocks.descriptions[kind]}</small
					>
				</span>
			</button>
		{/each}
	</div>
</div>

<style>
	.picker {
		margin-bottom: 14px;
		padding: 14px;
		box-shadow: 0 4px 18px rgba(0, 0, 0, 0.08);
	}

	.head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 10px;
	}

	h3 {
		font-size: 16px;
	}

	.kinds {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
		gap: 8px;
	}

	.kind {
		display: flex;
		gap: 10px;
		align-items: flex-start;
		padding: 9px 10px;
		text-align: left;
		background: #fafafb;
		border: 1px solid var(--line);
		border-radius: 3px;
		cursor: pointer;
	}

	.kind:hover:not(:disabled) {
		background: var(--accent-wash);
		border-color: #e3c3c8;
	}

	.kind:disabled {
		opacity: 0.45;
		cursor: default;
	}

	.icon {
		display: grid;
		place-items: center;
		flex: none;
		width: 30px;
		height: 30px;
		color: var(--accent);
		background: #fff;
		border: 1px solid var(--line);
		border-radius: 50%;
	}

	strong {
		display: block;
		font: normal 14px var(--serif);
	}

	small {
		font-size: 12px;
		color: var(--ink-soft);
	}
</style>
