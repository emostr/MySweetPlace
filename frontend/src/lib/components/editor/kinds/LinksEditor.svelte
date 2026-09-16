<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let {
		data = $bindable(),
		errors
	}: { data: BlockDataMap['links']; errors: Record<string, string> } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);
</script>

<ListEditor
	bind:items={data.items}
	create={() => ({ id: uid(), title: '', url: '' })}
	addLabel={t.addLink}
	max={50}
>
	{#snippet item(link, index)}
		<div class="pair">
			<label class="field">
				<span class="field-label">{t.linkTitle}</span>
				<input class="input" bind:value={link.title} maxlength="80" placeholder="GitHub" />
			</label>
			<label class="field">
				<span class="field-label">{t.linkUrl}</span>
				<input
					class="input"
					bind:value={link.url}
					placeholder="https://"
					aria-invalid={!!errors[`items.${index}.url`]}
				/>
				{#if errors[`items.${index}.url`]}<span class="field-error"
						>{errors[`items.${index}.url`]}</span
					>{/if}
			</label>
		</div>
	{/snippet}
</ListEditor>

<style>
	.pair {
		display: grid;
		grid-template-columns: 1fr 1.4fr;
		gap: 0 8px;
	}
</style>
