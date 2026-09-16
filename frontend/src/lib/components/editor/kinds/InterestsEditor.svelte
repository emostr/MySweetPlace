<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let {
		data = $bindable(),
		errors
	}: { data: BlockDataMap['interests']; errors: Record<string, string> } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);
</script>

<p class="hint">{i18n.t.blocks.descriptions.interests}</p>
<ListEditor
	bind:items={data.items}
	create={() => ({ id: uid(), emoji: '', label: '' })}
	addLabel={t.addInterest}
	max={50}
>
	{#snippet item(interest, index)}
		<div class="item">
			<input
				class="input emoji"
				bind:value={interest.emoji}
				placeholder="🎧"
				maxlength="16"
				aria-label={t.emoji}
			/>
			<input
				class="input"
				bind:value={interest.label}
				placeholder={t.interestPlaceholder}
				maxlength="40"
				aria-label={t.interestLabel}
				aria-invalid={!!errors[`items.${index}.label`]}
			/>
		</div>
	{/snippet}
</ListEditor>

<style>
	.item {
		display: flex;
		gap: 8px;
	}

	.emoji {
		width: 52px;
		text-align: center;
	}

	.hint {
		margin-top: 0;
	}
</style>
