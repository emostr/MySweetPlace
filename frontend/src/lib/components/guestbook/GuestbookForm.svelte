<script lang="ts">
	import { onMount } from 'svelte';
	import { api } from '$lib/api';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import type { GuestbookEntry, PlaceCard } from '$lib/types';

	let {
		username,
		author,
		onsent
	}: { username: string; author: PlaceCard | null; onsent?: (entry: GuestbookEntry) => void } =
		$props();

	const i18n = getI18n();
	const t = $derived(i18n.t.blocks.guestbook);

	let name = $state('');
	let body = $state('');
	let website = $state('');
	let busy = $state(false);
	let error = $state('');
	let success = $state('');

	onMount(() => {
		try {
			name = localStorage.getItem('guestbook-name') ?? '';
		} catch {
			name = '';
		}
	});

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		busy = true;
		error = '';
		success = '';
		try {
			const { entry } = await api.post<{ entry: GuestbookEntry | null }>(
				`/api/places/${username}/guestbook`,
				{
					author_name: name,
					body,
					website
				}
			);
			try {
				if (!author) localStorage.setItem('guestbook-name', name);
			} catch {
				// storage is optional
			}
			body = '';
			success = entry?.status === 'pending' ? t.sentPending : t.sent;
			if (entry) onsent?.(entry);
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<form class="guestbook-form" onsubmit={submit}>
	{#if author}
		<p class="as muted">{t.as(author.username)}</p>
	{:else}
		<input
			class="p-input"
			bind:value={name}
			placeholder={t.name}
			aria-label={t.name}
			maxlength="40"
			required
		/>
	{/if}
	<textarea
		class="p-input"
		bind:value={body}
		placeholder={t.message}
		aria-label={t.message}
		maxlength="500"
		rows="3"
		required></textarea>
	<input
		class="trap"
		bind:value={website}
		name="website"
		tabindex="-1"
		autocomplete="off"
		aria-hidden="true"
	/>
	<div class="bar">
		<span class="count muted">{body.length}/500</span>
		<button class="p-btn" disabled={busy || !body.trim()}>{busy ? t.sending : t.send}</button>
	</div>
	{#if success}<p class="place-notice">{success}</p>{/if}
	{#if error}<p class="place-error">{error}</p>{/if}
</form>

<style>
	.guestbook-form {
		display: grid;
		gap: 8px;
		margin-bottom: 18px;
	}

	.as {
		margin: 0;
		font-size: 0.85em;
	}

	.trap {
		position: absolute;
		left: -9999px;
		width: 1px;
		height: 1px;
		opacity: 0;
	}

	.bar {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.count {
		font-size: 0.75em;
	}

	p {
		margin: 0;
	}
</style>
