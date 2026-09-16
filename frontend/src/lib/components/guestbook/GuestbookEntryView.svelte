<script lang="ts">
	import Pin from '@lucide/svelte/icons/pin';
	import PinOff from '@lucide/svelte/icons/pin-off';
	import Eye from '@lucide/svelte/icons/eye';
	import EyeOff from '@lucide/svelte/icons/eye-off';
	import Check from '@lucide/svelte/icons/check';
	import Trash from '@lucide/svelte/icons/trash';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import { api } from '$lib/api';
	import { formatShortDate } from '$lib/dates';
	import { getI18n } from '$lib/i18n';
	import type { GuestbookEntry } from '$lib/types';

	let {
		entry,
		username,
		moderate = false,
		onchange
	}: {
		entry: GuestbookEntry;
		username: string;
		moderate?: boolean;
		onchange?: () => void;
	} = $props();

	const i18n = getI18n();
	const t = $derived(i18n.t.blocks.guestbook);

	async function update(changes: Partial<Pick<GuestbookEntry, 'status' | 'pinned'>>) {
		await api.patch(`/api/my/guestbook/${entry.id}`, changes);
		onchange?.();
	}

	async function remove() {
		if (!confirm(i18n.t.common.confirmDelete)) return;
		await api.delete(
			moderate ? `/api/my/guestbook/${entry.id}` : `/api/places/${username}/guestbook/${entry.id}`
		);
		onchange?.();
	}
</script>

<li class="entry msp-entry" class:pinned={entry.pinned} class:dim={entry.status !== 'visible'}>
	<Avatar src={entry.author.avatar_url} name={entry.author.name} size={36} />
	<div class="content">
		<div class="head">
			{#if entry.author.username}
				<a class="author" href="/@{entry.author.username}">{entry.author.name}</a>
			{:else}
				<span class="author">{entry.author.name}</span>
			{/if}
			<time class="muted" datetime={entry.created_at}
				>{formatShortDate(entry.created_at, i18n.locale, i18n.timeZone)}</time
			>
			{#if entry.pinned}<span class="pin" title={i18n.t.common.pin}><Pin size={12} /></span>{/if}
			{#if moderate && entry.status !== 'visible'}
				<span class="status status-{entry.status}">{t.statuses[entry.status]}</span>
			{/if}
		</div>
		<p class="body">{entry.body}</p>
		{#if moderate || entry.can_delete}
			<div class="actions">
				{#if moderate}
					{#if entry.status === 'pending'}
						<button
							class="p-icon-btn"
							title={t.approve}
							onclick={() => update({ status: 'visible' })}><Check size={15} /></button
						>
					{:else if entry.status === 'visible'}
						<button
							class="p-icon-btn"
							title={i18n.t.common.hide}
							onclick={() => update({ status: 'hidden' })}><EyeOff size={15} /></button
						>
					{:else}
						<button
							class="p-icon-btn"
							title={i18n.t.common.show}
							onclick={() => update({ status: 'visible' })}><Eye size={15} /></button
						>
					{/if}
					<button
						class="p-icon-btn"
						title={entry.pinned ? i18n.t.common.unpin : i18n.t.common.pin}
						onclick={() => update({ pinned: !entry.pinned })}
					>
						{#if entry.pinned}<PinOff size={15} />{:else}<Pin size={15} />{/if}
					</button>
				{/if}
				<button class="p-icon-btn" title={i18n.t.common.delete} onclick={remove}
					><Trash size={15} /></button
				>
			</div>
		{/if}
	</div>
</li>

<style>
	.entry {
		display: flex;
		gap: 12px;
		padding: 12px 0;
	}

	:global(.msp-entry + .msp-entry) {
		border-top: 1px dashed color-mix(in srgb, var(--p-border) 90%, transparent);
	}

	.pinned {
		margin: 0 -10px;
		padding: 12px 10px;
		background: color-mix(in srgb, var(--p-accent) 7%, transparent);
		border-radius: min(var(--p-radius), 8px);
	}

	.dim {
		opacity: 0.65;
	}

	.content {
		flex: 1;
		min-width: 0;
	}

	.head {
		display: flex;
		flex-wrap: wrap;
		gap: 4px 10px;
		align-items: baseline;
	}

	.author {
		font-family: var(--p-heading);
		font-size: 1.05em;
	}

	span.author {
		color: var(--p-text);
	}

	time {
		font-size: 0.78em;
	}

	.pin {
		color: var(--p-accent);
	}

	.status {
		padding: 0 7px;
		font-size: 0.72em;
		line-height: 1.7;
		border-radius: 999px;
		background: color-mix(in srgb, var(--p-text) 12%, transparent);
	}

	.status-pending {
		color: #6a4b00;
		background: #fbecc0;
	}

	.body {
		margin: 3px 0 0;
		white-space: pre-line;
		overflow-wrap: anywhere;
	}

	.actions {
		display: flex;
		gap: 2px;
		margin-top: 4px;
		opacity: 0.6;
	}

	.entry:hover .actions,
	.actions:focus-within {
		opacity: 1;
	}
</style>
