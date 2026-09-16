<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import ImagePicker from '../ImagePicker.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap, Track } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['music'] } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);

	const artists = $derived(data.artists.join('\n'));
	const setArtists = (text: string) => {
		data.artists = text
			.split('\n')
			.map((line) => line.trim())
			.filter(Boolean)
			.slice(0, 30);
	};
</script>

{#snippet track(value: Track, title: string)}
	<fieldset class="track">
		<legend class="field-label">{title}</legend>
		<div class="grid3">
			<input class="input" bind:value={value.title} placeholder={t.trackTitle} maxlength="120" />
			<input class="input" bind:value={value.artist} placeholder={t.trackArtist} maxlength="120" />
			<input class="input" bind:value={value.url} placeholder={t.trackUrl} />
		</div>
	</fieldset>
{/snippet}

{@render track(data.current, t.musicCurrent)}
{@render track(data.anthem, t.musicAnthem)}

<label class="field">
	<span class="field-label">{t.musicArtists}</span>
	<textarea
		class="input"
		rows="3"
		value={artists}
		onchange={(e) => setArtists(e.currentTarget.value)}
		placeholder={t.musicArtistsHint}></textarea>
</label>

<span class="field-label">{t.musicAlbums}</span>
<ListEditor
	bind:items={data.albums}
	create={() => ({ id: uid(), title: '', artist: '', year: '', cover_id: null, url: '' })}
	addLabel={t.addAlbum}
	max={12}
>
	{#snippet item(album)}
		<div class="album">
			<ImagePicker bind:value={album.cover_id} purpose="album" />
			<div class="grid2">
				<input class="input" bind:value={album.title} placeholder={t.albumTitle} maxlength="120" />
				<input
					class="input"
					bind:value={album.artist}
					placeholder={t.trackArtist}
					maxlength="120"
				/>
				<input class="input" bind:value={album.year} placeholder={t.albumYear} maxlength="4" />
				<input class="input" bind:value={album.url} placeholder={t.trackUrl} />
			</div>
		</div>
	{/snippet}
</ListEditor>

<fieldset class="track playlist">
	<legend class="field-label">{i18n.t.blocks.music.playlist}</legend>
	<div class="grid2">
		<input
			class="input"
			bind:value={data.playlist.title}
			placeholder={t.playlistTitle}
			maxlength="120"
		/>
		<input class="input" bind:value={data.playlist.url} placeholder={t.playlistUrl} />
	</div>
	<span class="hint">{t.playlistHint}</span>
</fieldset>

<style>
	.track {
		margin: 0 0 12px;
		padding: 0;
		border: 0;
	}

	.grid2,
	.grid3 {
		display: grid;
		gap: 6px;
	}

	.grid2 {
		grid-template-columns: 1fr 1fr;
	}

	.grid3 {
		grid-template-columns: 1fr 1fr 1fr;
	}

	.album {
		display: flex;
		gap: 10px;
	}

	.album .grid2 {
		flex: 1;
	}

	.playlist {
		margin-top: 14px;
	}
</style>
