<script lang="ts">
	import LocalizedInput from '../LocalizedInput.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['guestbook'] } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);
	const accesses = ['everyone', 'members', 'nobody'] as const;
</script>

<fieldset class="access">
	<legend class="field-label">{t.guestbookAccess}</legend>
	{#each accesses as access (access)}
		<label class="check">
			<input type="radio" bind:group={data.access} value={access} />
			<span>{t.guestbookAccessOptions[access]}</span>
		</label>
	{/each}
</fieldset>

<label class="check">
	<input type="checkbox" bind:checked={data.premoderation} />
	<span>{t.guestbookPremoderation}</span>
</label>

<LocalizedInput
	bind:value={data.prompt}
	label={t.guestbookPrompt}
	placeholder={i18n.t.blocks.guestbook.prompt}
	maxlength={140}
/>

<label class="field">
	<span class="field-label">{t.guestbookLimit}</span>
	<input class="input narrow" type="number" min="1" max="50" bind:value={data.limit} />
</label>

<p class="hint"><a href="/edit/guestbook">{i18n.t.editor.guestbook.title} →</a></p>

<style>
	.access {
		margin: 0 0 12px;
		padding: 0;
		border: 0;
	}

	.access .check {
		margin-bottom: 4px;
	}

	.narrow {
		width: 90px;
	}
</style>
