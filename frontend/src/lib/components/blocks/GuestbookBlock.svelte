<script lang="ts">
	import { page } from '$app/state';
	import GuestbookForm from '$lib/components/guestbook/GuestbookForm.svelte';
	import GuestbookEntryView from '$lib/components/guestbook/GuestbookEntryView.svelte';
	import { getPlaceContext } from '$lib/components/place/context';
	import { api } from '$lib/api';
	import { getI18n } from '$lib/i18n';
	import type { BlockOf, GuestbookEntry, Me, Paginated, Place } from '$lib/types';

	let { block, place }: { block: BlockOf<'guestbook'>; place: Place } = $props();
	const i18n = getI18n();
	const context = getPlaceContext();
	const t = $derived(i18n.t.blocks.guestbook);
	const me = $derived((page.data.me as Me | undefined) ?? { user: null, place: null });
	const owner = $derived(place.owner && !context.preview);

	let more = $state<GuestbookEntry[]>([]);
	let hasMore = $state<boolean | null>(null);
	let loading = $state(false);

	const entries = $derived([
		...block.content.items,
		...more.filter((entry) => !block.content.items.some((item) => item.id === entry.id))
	]);
	const canLoadMore = $derived(hasMore ?? block.content.total > block.content.items.length);
	const prompt = $derived(i18n.pick(block.data.prompt) || t.prompt);

	async function loadMore() {
		loading = true;
		try {
			const before = Math.min(...entries.map((entry) => entry.id));
			const result = await api.get<Paginated<GuestbookEntry>>(
				`/api/places/${place.username}/guestbook?before=${before}`
			);
			more = [...more, ...result.items];
			hasMore = result.has_more;
		} finally {
			loading = false;
		}
	}

	async function refresh() {
		more = [];
		hasMore = null;
		await context.refresh();
	}
</script>

<div class="guestbook">
	<p class="prompt">{prompt}</p>

	{#if !context.preview}
		{#if block.content.can_write}
			<GuestbookForm username={place.username} author={me.place} onsent={refresh} />
		{:else if block.data.access === 'members'}
			<p class="place-notice">
				{t.membersOnly}
				<a href="/login?next={encodeURIComponent(page.url.pathname)}">{t.loginToWrite}</a>
			</p>
		{:else}
			<p class="place-notice">{t.closed}</p>
		{/if}
	{/if}

	{#if owner && block.content.pending > 0}
		<p class="place-notice">
			<a href="/edit/guestbook?status=pending">{t.pending(block.content.pending)} →</a>
		</p>
	{/if}

	{#if entries.length}
		<ul class="entries">
			{#each entries as entry (entry.id)}
				<GuestbookEntryView {entry} username={place.username} moderate={owner} onchange={refresh} />
			{/each}
		</ul>
	{:else}
		<p class="place-empty">{t.empty}</p>
	{/if}

	{#if canLoadMore}
		<button class="p-btn p-btn-light more" onclick={loadMore} disabled={loading}
			>{i18n.t.common.more}</button
		>
	{/if}
</div>

<style>
	.guestbook {
		display: grid;
		gap: 10px;
	}

	.prompt {
		margin: 0;
		font-family: var(--p-heading);
		font-style: italic;
		color: var(--p-muted);
	}

	.entries {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.place-notice {
		margin: 0;
	}

	.more {
		justify-self: center;
	}
</style>
