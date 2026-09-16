<script lang="ts">
	import { invalidate } from '$app/navigation';
	import ThemedPanel from '$lib/components/place/ThemedPanel.svelte';
	import GuestbookEntryView from '$lib/components/guestbook/GuestbookEntryView.svelte';
	import { query } from '$lib/api';
	import { getEditor } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.guestbook);
	const filters = ['', 'pending', 'visible', 'hidden'] as const;
	const total = $derived(Object.values(data.counts).reduce((sum, count) => sum + count, 0));

	async function refresh() {
		await Promise.all([invalidate('app:editor-guestbook'), editor.reload()]);
	}
</script>

<h1>{t.title}</h1>

<nav class="filters">
	{#each filters as filter (filter)}
		<a href="/edit/guestbook{query({ status: filter })}" class:active={data.status === filter}>
			{t.filters[filter || 'all']}
			<small>{filter ? (data.counts[filter] ?? 0) : total}</small>
		</a>
	{/each}
</nav>

<ThemedPanel theme={editor.place.theme} uploads={editor.place.uploads}>
	{#if data.items.length}
		<ul class="entries">
			{#each data.items as entry (entry.id)}
				<GuestbookEntryView {entry} username={editor.place.username} moderate onchange={refresh} />
			{/each}
		</ul>
	{:else}
		<p class="place-empty">{t.empty}</p>
	{/if}
	{#if data.has_more}
		<p class="more">
			<a
				class="p-btn p-btn-light"
				href="/edit/guestbook{query({ status: data.status, before: data.items.at(-1)?.id })}"
				>{i18n.t.common.more}</a
			>
		</p>
	{/if}
</ThemedPanel>

<p class="hint">{t.settingsHint}</p>

<style>
	h1 {
		margin-bottom: 12px;
		font-size: 26px;
	}

	.filters {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
		margin-bottom: 12px;
	}

	.filters a {
		padding: 4px 11px;
		font-size: 13px;
		color: #444;
		text-decoration: none;
		background: linear-gradient(#fdfdfd, #eceef0);
		border: 1px solid #c4c7cb;
		border-radius: 3px;
	}

	.filters a.active {
		color: #fff;
		background: linear-gradient(#8e2e3b, #6d2230);
		border-color: var(--accent-deep);
	}

	.filters small {
		opacity: 0.7;
	}

	.entries {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.more {
		margin: 10px 0 0;
		text-align: center;
	}

	.hint {
		margin-top: 12px;
	}
</style>
