<script lang="ts">
	import type { Component } from 'svelte';
	import BlockFrame from './BlockFrame.svelte';
	import PlaceShell from './PlaceShell.svelte';
	import IntroBlock from '$lib/components/blocks/IntroBlock.svelte';
	import LinksBlock from '$lib/components/blocks/LinksBlock.svelte';
	import ProjectsBlock from '$lib/components/blocks/ProjectsBlock.svelte';
	import NotesBlock from '$lib/components/blocks/NotesBlock.svelte';
	import NowBlock from '$lib/components/blocks/NowBlock.svelte';
	import StackBlock from '$lib/components/blocks/StackBlock.svelte';
	import InterestsBlock from '$lib/components/blocks/InterestsBlock.svelte';
	import MusicBlock from '$lib/components/blocks/MusicBlock.svelte';
	import PhotosBlock from '$lib/components/blocks/PhotosBlock.svelte';
	import GuestbookBlock from '$lib/components/blocks/GuestbookBlock.svelte';
	import NeighboursBlock from '$lib/components/blocks/NeighboursBlock.svelte';
	import TimelineBlock from '$lib/components/blocks/TimelineBlock.svelte';
	import TextBlock from '$lib/components/blocks/TextBlock.svelte';
	import { isBlockEmpty } from '$lib/blocks';
	import { getI18n } from '$lib/i18n';
	import type { Season } from '$lib/season';
	import type { Block, BlockKind, Me, Place } from '$lib/types';

	let {
		place,
		me,
		motto = '',
		season = 'none',
		preview = false,
		refresh = async () => {}
	}: {
		place: Place;
		me: Me;
		motto?: string;
		season?: Season;
		preview?: boolean;
		refresh?: () => Promise<void>;
	} = $props();

	const i18n = getI18n();

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const components: Record<BlockKind, Component<any>> = {
		intro: IntroBlock,
		links: LinksBlock,
		projects: ProjectsBlock,
		notes: NotesBlock,
		now: NowBlock,
		stack: StackBlock,
		interests: InterestsBlock,
		music: MusicBlock,
		photos: PhotosBlock,
		guestbook: GuestbookBlock,
		neighbours: NeighboursBlock,
		timeline: TimelineBlock,
		text: TextBlock
	};

	const selfRendersEmpty: BlockKind[] = ['notes', 'neighbours', 'guestbook', 'intro'];
	const shown = (block: Block) => place.owner || !isBlockEmpty(block);
</script>

<PlaceShell {place} {me} {motto} {season} {preview} {refresh}>
	<div class="blocks">
		{#each place.blocks as block (block.id)}
			{#if shown(block)}
				{@const BlockComponent = components[block.kind]}
				<BlockFrame {block}>
					{#if isBlockEmpty(block) && !selfRendersEmpty.includes(block.kind)}
						<p class="place-empty">
							{i18n.t.place.emptyBlock}
							{#if !preview}<a href="/edit?block={block.id}">{i18n.t.place.edit} →</a>{/if}
						</p>
					{:else}
						<BlockComponent {block} {place} />
					{/if}
				</BlockFrame>
			{/if}
		{/each}
	</div>

	{#if !preview && place.neighbour_of_count > 0}
		<p class="neighbour-of">{i18n.t.place.neighbourOf(place.neighbour_of_count)}</p>
	{/if}
</PlaceShell>

<style>
	.neighbour-of {
		margin: 20px 0 0;
		font-size: 0.82em;
		text-align: center;
		color: var(--p-muted);
	}
</style>
