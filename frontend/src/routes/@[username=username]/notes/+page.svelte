<script lang="ts">
	import ArrowLeft from '@lucide/svelte/icons/arrow-left';
	import { invalidate } from '$app/navigation';
	import PlaceShell from '$lib/components/place/PlaceShell.svelte';
	import NoteCard from '$lib/components/notes/NoteCard.svelte';
	import NoteComposer from '$lib/components/notes/NoteComposer.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const place = $derived(data.place);
	const name = $derived(i18n.pick(place.profile.name) || place.username);
	const refresh = () => invalidate('app:place');
</script>

<svelte:head>
	<title>{i18n.t.blocks.titles.notes} — {name} (@{place.username})</title>
</svelte:head>

<PlaceShell {place} me={data.me} motto={data.motto} season={data.season} {refresh}>
	<section class="block notes-page">
		<a class="back" href="/@{place.username}"><ArrowLeft size={14} /> {i18n.t.notes.back}</a>
		<h1 class="block-title">{i18n.t.blocks.titles.notes} · {name}</h1>
		{#if place.owner && !data.before}
			<NoteComposer onsaved={refresh} />
		{/if}
		<div class="list">
			{#each data.notes.items as note (note.id)}
				<NoteCard {note} username={place.username} owner={place.owner} onchange={refresh} />
			{:else}
				<p class="place-empty">{i18n.t.blocks.notes.empty}</p>
			{/each}
		</div>
		{#if data.notes.has_more}
			<a class="p-btn p-btn-light more" href="?before={data.notes.items.at(-1)?.id}"
				>{i18n.t.common.more}</a
			>
		{/if}
	</section>
</PlaceShell>

<style>
	.notes-page {
		display: grid;
		gap: 14px;
		max-width: 720px;
		margin: 0 auto;
	}

	.back {
		display: inline-flex;
		gap: 4px;
		align-items: center;
		justify-self: start;
		font-size: 0.85em;
	}

	.block-title {
		margin-bottom: 0;
	}

	.list {
		display: grid;
		gap: 14px;
	}

	.more {
		justify-self: center;
	}
</style>
