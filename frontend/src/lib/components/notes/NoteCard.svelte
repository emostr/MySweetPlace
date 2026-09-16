<script lang="ts">
	import Pin from '@lucide/svelte/icons/pin';
	import PinOff from '@lucide/svelte/icons/pin-off';
	import Pencil from '@lucide/svelte/icons/pencil';
	import Trash from '@lucide/svelte/icons/trash';
	import NoteBody from './NoteBody.svelte';
	import NoteComposer from './NoteComposer.svelte';
	import { api } from '$lib/api';
	import { formatShortDate } from '$lib/dates';
	import { getI18n } from '$lib/i18n';
	import type { Note } from '$lib/types';

	let {
		note,
		username,
		owner = false,
		compact = false,
		onchange
	}: {
		note: Note;
		username: string;
		owner?: boolean;
		compact?: boolean;
		onchange?: () => void;
	} = $props();

	const i18n = getI18n();
	let editing = $state(false);

	async function togglePin() {
		await api.patch(`/api/my/notes/${note.id}`, { pinned: !note.pinned });
		onchange?.();
	}

	async function remove() {
		if (!confirm(i18n.t.notes.deleteConfirm)) return;
		await api.delete(`/api/my/notes/${note.id}`);
		onchange?.();
	}
</script>

<article class="note msp-note" class:compact class:pinned={note.pinned}>
	<header>
		{#if note.pinned}
			<span class="pinned-label"><Pin size={12} /> {i18n.t.blocks.notes.pinned}</span>
		{/if}
		<a class="date" href="/@{username}/notes/{note.id}" title={i18n.t.blocks.notes.permalink}>
			<time datetime={note.created_at}
				>{formatShortDate(note.created_at, i18n.locale, i18n.timeZone)}</time
			>
		</a>
		{#if owner && !editing}
			<span class="actions">
				<button
					class="p-icon-btn"
					title={note.pinned ? i18n.t.common.unpin : i18n.t.common.pin}
					onclick={togglePin}
				>
					{#if note.pinned}<PinOff size={15} />{:else}<Pin size={15} />{/if}
				</button>
				<button class="p-icon-btn" title={i18n.t.common.edit} onclick={() => (editing = true)}
					><Pencil size={15} /></button
				>
				<button class="p-icon-btn" title={i18n.t.common.delete} onclick={remove}
					><Trash size={15} /></button
				>
			</span>
		{/if}
	</header>

	{#if editing}
		<NoteComposer
			{note}
			oncancel={() => (editing = false)}
			onsaved={() => {
				editing = false;
				onchange?.();
			}}
		/>
	{:else}
		<NoteBody {note} {compact} />
	{/if}
</article>

<style>
	:global(.msp-note + .msp-note) {
		padding-top: 14px;
		border-top: 1px dashed color-mix(in srgb, var(--p-border) 90%, transparent);
	}

	header {
		display: flex;
		gap: 10px;
		align-items: center;
		min-height: 28px;
		margin-bottom: 2px;
		font-size: 0.8em;
	}

	.date {
		color: var(--p-muted);
		text-decoration: none;
	}

	.date:hover {
		color: var(--p-accent);
	}

	.pinned-label {
		display: inline-flex;
		gap: 3px;
		align-items: center;
		color: var(--p-accent);
	}

	.actions {
		display: flex;
		margin-left: auto;
		opacity: 0.55;
		transition: opacity 0.15s;
	}

	.note:hover .actions,
	.actions:focus-within {
		opacity: 1;
	}

	.compact :global(.note-body) {
		display: -webkit-box;
		overflow: hidden;
		-webkit-line-clamp: 3;
		line-clamp: 3;
		-webkit-box-orient: vertical;
	}
</style>
