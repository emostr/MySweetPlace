<script lang="ts">
	import Pin from '@lucide/svelte/icons/pin';
	import Disc3 from '@lucide/svelte/icons/disc-3';
	import Embed from '$lib/components/notes/Embed.svelte';
	import { getI18n } from '$lib/i18n';
	import { parseEmbed } from '$lib/embeds';
	import type { BlockOf, Place, Track } from '$lib/types';

	let { block, place }: { block: BlockOf<'music'>; place: Place } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.blocks.music);
	const data = $derived(block.data);
	const anthemEmbed = $derived(data.anthem.url ? parseEmbed(data.anthem.url) : null);
	const playlistEmbed = $derived(data.playlist.url ? parseEmbed(data.playlist.url) : null);
</script>

{#snippet track(item: Track)}
	{#if item.url}
		<a href={item.url} target="_blank" rel="noopener"><strong>{item.title}</strong></a>
	{:else}
		<strong>{item.title}</strong>
	{/if}
	{#if item.artist}<span class="muted"> — {item.artist}</span>{/if}
{/snippet}

<div class="music">
	{#if data.current.title}
		<div class="row now-playing">
			<span class="eq" aria-hidden="true"><i></i><i></i><i></i></span>
			<div>
				<div class="label">{t.current}</div>
				{@render track(data.current)}
			</div>
		</div>
	{/if}

	{#if data.anthem.title}
		<div class="row anthem">
			<span class="pin"><Pin size={16} /></span>
			<div class="grow">
				<div class="label">{t.anthem}</div>
				{@render track(data.anthem)}
				{#if anthemEmbed}<Embed embed={anthemEmbed} />{/if}
			</div>
		</div>
	{/if}

	{#if data.artists.length}
		<div>
			<div class="label">{t.artists}</div>
			<div class="artists">
				{#each data.artists as artist (artist)}<span class="chip">{artist}</span>{/each}
			</div>
		</div>
	{/if}

	{#if data.albums.length}
		<div>
			<div class="label">{t.albums}</div>
			<div class="albums">
				{#each data.albums as album (album.id)}
					{@const cover = album.cover_id ? place.uploads[album.cover_id] : null}
					<svelte:element
						this={album.url ? 'a' : 'div'}
						class="album"
						href={album.url || undefined}
						target={album.url ? '_blank' : undefined}
						rel={album.url ? 'noopener' : undefined}
					>
						<span class="cover">
							{#if cover}<img src={cover.url} alt="" loading="lazy" />{:else}<Disc3
									size={36}
								/>{/if}
						</span>
						<span class="album-title">{album.title}</span>
						<span class="muted small">{[album.artist, album.year].filter(Boolean).join(', ')}</span>
					</svelte:element>
				{/each}
			</div>
		</div>
	{/if}

	{#if data.playlist.url}
		<div>
			<div class="label">{t.playlist}{data.playlist.title ? `: ${data.playlist.title}` : ''}</div>
			{#if playlistEmbed}
				<Embed embed={playlistEmbed} />
			{:else}
				<a href={data.playlist.url} target="_blank" rel="noopener">{t.listen} →</a>
			{/if}
		</div>
	{/if}
</div>

<style>
	.music {
		display: grid;
		gap: 16px;
	}

	.row {
		display: flex;
		gap: 12px;
		align-items: flex-start;
	}

	.grow {
		flex: 1;
		min-width: 0;
	}

	.label {
		margin-bottom: 4px;
		font-size: 0.75em;
		color: var(--p-muted);
		text-transform: uppercase;
		letter-spacing: 1px;
	}

	.now-playing {
		align-items: center;
	}

	.eq {
		display: flex;
		gap: 3px;
		align-items: flex-end;
		width: 22px;
		height: 22px;
		padding: 3px;
		flex: none;
	}

	.eq i {
		flex: 1;
		height: 40%;
		background: var(--p-accent);
		border-radius: 1px;
		animation: bounce 1s ease-in-out infinite alternate;
	}

	.eq i:nth-child(2) {
		animation-delay: -0.4s;
	}

	.eq i:nth-child(3) {
		animation-delay: -0.7s;
	}

	@keyframes bounce {
		to {
			height: 100%;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.eq i {
			animation: none;
			height: 70%;
		}
	}

	.pin {
		display: grid;
		place-items: center;
		width: 22px;
		height: 22px;
		flex: none;
		color: var(--p-accent);
		transform: rotate(35deg);
	}

	.artists {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
	}

	.albums {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
		gap: 12px;
	}

	.album {
		display: grid;
		gap: 2px;
		min-width: 0;
		color: var(--p-text);
		text-decoration: none;
	}

	.cover {
		display: grid;
		place-items: center;
		aspect-ratio: 1;
		margin-bottom: 4px;
		overflow: hidden;
		color: var(--p-muted);
		background: color-mix(in srgb, var(--p-text) 8%, var(--p-surface));
		border-radius: min(var(--p-radius), 6px);
		box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
	}

	.cover img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.album-title {
		overflow: hidden;
		font-size: 0.9em;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.small {
		font-size: 0.8em;
	}
</style>
