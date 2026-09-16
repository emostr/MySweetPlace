<script lang="ts">
	import NoteCard from '$lib/components/notes/NoteCard.svelte';
	import NoteComposer from '$lib/components/notes/NoteComposer.svelte';
	import { getPlaceContext } from '$lib/components/place/context';
	import { getI18n } from '$lib/i18n';
	import type { BlockOf, Place } from '$lib/types';

	let { block, place }: { block: BlockOf<'notes'>; place: Place } = $props();
	const i18n = getI18n();
	const context = getPlaceContext();
	const owner = $derived(place.owner && !context.preview);
</script>

<div class="notes">
	{#if owner}
		<NoteComposer onsaved={() => context.refresh()} />
	{/if}

	{#each block.content.items as note (note.id)}
		<NoteCard
			{note}
			username={place.username}
			{owner}
			compact={block.style.variant === 'compact'}
			onchange={() => context.refresh()}
		/>
	{:else}
		<p class="place-empty">{i18n.t.blocks.notes.empty}</p>
	{/each}

	{#if block.content.total > block.content.items.length}
		<a class="all" href="/@{place.username}/notes"
			>{i18n.t.blocks.notes.all(block.content.total)} →</a
		>
	{/if}
</div>

<style>
	.notes {
		display: grid;
		gap: 14px;
	}

	.all {
		justify-self: start;
		font-size: 0.9em;
	}
</style>
