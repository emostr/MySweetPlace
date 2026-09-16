<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import LocalizedInput from '../LocalizedInput.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['now'] } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);
	const today = () => new Date().toISOString().slice(0, 10);
</script>

<LocalizedInput bind:value={data.text} label={t.nowText} multiline maxlength={1000} />

<span class="field-label">{t.nowItems}</span>
<ListEditor
	bind:items={data.items}
	create={() => ({ id: uid(), emoji: '', text: {} })}
	addLabel={t.addItem}
	max={12}
>
	{#snippet item(entry)}
		<div class="item">
			<input
				class="input emoji"
				bind:value={entry.emoji}
				placeholder="📖"
				maxlength="16"
				aria-label={t.emoji}
			/>
			<LocalizedInput bind:value={entry.text} maxlength={160} />
		</div>
	{/snippet}
</ListEditor>

<label class="field updated">
	<span class="field-label">{t.updatedOn}</span>
	<span class="row">
		<input class="input date" type="date" bind:value={data.updated_on} />
		<button type="button" class="btn btn-light btn-sm" onclick={() => (data.updated_on = today())}
			>{i18n.t.common.today}</button
		>
	</span>
</label>

<style>
	.item {
		display: flex;
		gap: 8px;
	}

	.emoji {
		width: 52px;
		height: 34px;
		text-align: center;
	}

	.item :global(.localized) {
		flex: 1;
		margin: 0;
	}

	.updated {
		margin-top: 14px;
	}

	.date {
		width: 170px;
	}
</style>
