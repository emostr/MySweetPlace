<script lang="ts">
	import { untrack } from 'svelte';
	import ImagePlus from '@lucide/svelte/icons/image-plus';
	import X from '@lucide/svelte/icons/x';
	import { api } from '$lib/api';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import { uploadImage } from '$lib/images';
	import type { Note, Upload } from '$lib/types';

	const MAX_IMAGES = 4;

	let {
		note,
		onsaved,
		oncancel
	}: { note?: Note; onsaved?: (note: Note) => void; oncancel?: () => void } = $props();

	const i18n = getI18n();
	const t = $derived(i18n.t.notes);

	let body = $state(untrack(() => note?.body ?? ''));
	let images = $state<Upload[]>(untrack(() => note?.images ?? []));
	let uploading = $state(0);
	let busy = $state(false);
	let error = $state('');
	let form = $state<HTMLFormElement>();

	const empty = $derived(!body.trim() && images.length === 0);

	async function addImages(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const files = Array.from(input.files ?? []);
		input.value = '';
		if (images.length + files.length > MAX_IMAGES) error = t.tooManyImages(MAX_IMAGES);
		for (const file of files.slice(0, MAX_IMAGES - images.length)) {
			uploading++;
			try {
				images.push(await uploadImage(file, 'note'));
			} catch (e) {
				error = errorMessage(e, i18n);
			} finally {
				uploading--;
			}
		}
	}

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		if (empty || busy) return;
		busy = true;
		error = '';
		try {
			const payload = { body, image_ids: images.map((image) => image.id) };
			const response = note
				? await api.patch<{ note: Note }>(`/api/my/notes/${note.id}`, payload)
				: await api.post<{ note: Note }>('/api/my/notes', payload);
			if (!note) {
				body = '';
				images = [];
			}
			onsaved?.(response.note);
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}

	function keydown(event: KeyboardEvent) {
		if ((event.metaKey || event.ctrlKey) && event.key === 'Enter') form?.requestSubmit();
	}
</script>

<form class="composer" bind:this={form} onsubmit={submit}>
	<textarea
		class="p-input"
		bind:value={body}
		placeholder={t.placeholder}
		rows={note ? 4 : 2}
		maxlength="5000"
		onkeydown={keydown}
		aria-label={t.placeholder}></textarea>

	{#if images.length || uploading}
		<div class="thumbs">
			{#each images as image (image.id)}
				<span class="thumb">
					<img src={image.url} alt="" />
					<button
						type="button"
						class="remove"
						aria-label={i18n.t.common.remove}
						onclick={() => (images = images.filter((item) => item.id !== image.id))}
					>
						<X size={12} />
					</button>
				</span>
			{/each}
			{#each { length: uploading }}
				<span class="thumb loading"></span>
			{/each}
		</div>
	{/if}

	<div class="bar">
		<label class="p-icon-btn" title={t.photos}>
			<ImagePlus size={18} />
			<input
				type="file"
				accept="image/*"
				multiple
				class="visually-hidden"
				onchange={addImages}
				disabled={images.length >= MAX_IMAGES}
			/>
		</label>
		<span class="hint" title={t.markdown}>Markdown</span>
		<span class="spacer"></span>
		{#if oncancel}
			<button type="button" class="p-btn p-btn-light" onclick={oncancel}
				>{i18n.t.common.cancel}</button
			>
		{/if}
		<button class="p-btn" disabled={busy || uploading > 0 || empty}>
			{busy ? t.publishing : note ? i18n.t.common.save : t.publish}
		</button>
	</div>
	{#if error}<p class="place-error">{error}</p>{/if}
</form>

<style>
	.composer {
		display: grid;
		gap: 8px;
	}

	textarea {
		min-height: 64px;
	}

	.bar {
		display: flex;
		gap: 8px;
		align-items: center;
	}

	.bar label {
		position: relative;
	}

	.hint {
		font-size: 0.75em;
		color: var(--p-muted);
		cursor: help;
	}

	.spacer {
		flex: 1;
	}

	.thumbs {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
	}

	.thumb {
		position: relative;
		width: 72px;
		height: 72px;
		overflow: hidden;
		background: color-mix(in srgb, var(--p-text) 10%, transparent);
		border-radius: 6px;
	}

	.thumb img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.loading {
		animation: pulse 1s ease-in-out infinite alternate;
	}

	@keyframes pulse {
		to {
			opacity: 0.4;
		}
	}

	.remove {
		position: absolute;
		top: 3px;
		right: 3px;
		display: grid;
		place-items: center;
		width: 20px;
		height: 20px;
		padding: 0;
		color: #fff;
		background: rgba(0, 0, 0, 0.6);
		border: 0;
		border-radius: 50%;
		cursor: pointer;
	}
</style>
