<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import LocalizedInput from '../LocalizedInput.svelte';
	import Segmented from '../Segmented.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let {
		data = $bindable(),
		errors
	}: { data: BlockDataMap['timeline']; errors: Record<string, string> } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);
</script>

<div class="field">
	<span class="field-label">{t.timelineOrder}</span>
	<Segmented
		bind:value={data.order}
		label={t.timelineOrder}
		options={[
			{ value: 'desc', label: t.timelineOrders.desc },
			{ value: 'asc', label: t.timelineOrders.asc }
		]}
	/>
</div>

<ListEditor
	bind:items={data.items}
	create={() => ({ id: uid(), date: '', emoji: '', title: {}, text: {} })}
	addLabel={t.addMoment}
	max={100}
>
	{#snippet item(moment, index)}
		<div class="head">
			<label class="field">
				<span class="field-label">{t.timelineDate}</span>
				<input
					class="input"
					bind:value={moment.date}
					placeholder={t.timelineDateHint}
					aria-invalid={!!errors[`items.${index}.date`]}
				/>
				{#if errors[`items.${index}.date`]}<span class="field-error"
						>{errors[`items.${index}.date`]}</span
					>{/if}
			</label>
			<label class="field">
				<span class="field-label">{t.emoji}</span>
				<input class="input" bind:value={moment.emoji} placeholder="🎓" maxlength="16" />
			</label>
		</div>
		<LocalizedInput
			bind:value={moment.title}
			label={t.timelineTitle}
			maxlength={120}
			error={errors[`items.${index}.title`]}
		/>
		<LocalizedInput bind:value={moment.text} label={t.text} multiline rows={2} maxlength={500} />
	{/snippet}
</ListEditor>

<style>
	.head {
		display: grid;
		grid-template-columns: 1fr 80px;
		gap: 8px;
	}
</style>
