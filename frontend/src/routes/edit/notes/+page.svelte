<script lang="ts">
	import { invalidate } from '$app/navigation';
	import ThemedPanel from '$lib/components/place/ThemedPanel.svelte';
	import NoteCard from '$lib/components/notes/NoteCard.svelte';
	import NoteComposer from '$lib/components/notes/NoteComposer.svelte';
	import { getEditor } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const editor = getEditor();

	async function refresh() {
		await Promise.all([invalidate('app:editor-notes'), editor.reload()]);
	}
</script>

<h1>{i18n.t.editor.notes.title}</h1>

<ThemedPanel theme={editor.place.theme} uploads={editor.place.uploads}>
	<div class="notes">
		{#if !data.before}<NoteComposer onsaved={refresh} />{/if}
		{#each data.notes.items as note (note.id)}
			<NoteCard {note} username={editor.place.username} owner onchange={refresh} />
		{:else}
			<p class="place-empty">{i18n.t.editor.notes.empty}</p>
		{/each}
		{#if data.notes.has_more}
			<a class="p-btn p-btn-light more" href="?before={data.notes.items.at(-1)?.id}"
				>{i18n.t.common.more}</a
			>
		{/if}
	</div>
</ThemedPanel>

<style>
	h1 {
		margin-bottom: 16px;
		font-size: 26px;
	}

	.notes {
		display: grid;
		gap: 14px;
	}

	.more {
		justify-self: center;
	}
</style>
