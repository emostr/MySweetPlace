<script lang="ts">
	import ImagePlus from '@lucide/svelte/icons/image-plus';
	import ListEditor from '../ListEditor.svelte';
	import LocalizedInput from '../LocalizedInput.svelte';
	import { getEditor, uid } from '$lib/editor/state.svelte';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import { uploadImage } from '$lib/images';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['photos'] } = $props();
	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.forms);
	let uploading = $state(0);
	let error = $state('');

	async function add(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const files = Array.from(input.files ?? []).slice(0, 30 - data.items.length);
		input.value = '';
		error = '';
		for (const file of files) {
			uploading++;
			try {
				const upload = await uploadImage(file, 'photo');
				editor.remember(upload);
				data.items = [...data.items, { id: uid(), image_id: upload.id, caption: {} }];
			} catch (e) {
				error = errorMessage(e, i18n);
			} finally {
				uploading--;
			}
		}
	}
</script>

<label class="btn btn-light btn-sm upload">
	<ImagePlus size={14} />
	{uploading ? `${i18n.t.common.uploading} (${uploading})` : t.addPhotos}
	<input type="file" accept="image/*" multiple class="visually-hidden" onchange={add} />
</label>
{#if error}<p class="field-error">{error}</p>{/if}

<ListEditor
	bind:items={data.items}
	create={() => ({ id: uid(), image_id: 0, caption: {} })}
	addLabel=""
	max={0}
>
	{#snippet item(photo)}
		<div class="photo">
			{#if editor.preview.uploads[photo.image_id]}
				<img src={editor.preview.uploads[photo.image_id].url} alt="" />
			{/if}
			<LocalizedInput bind:value={photo.caption} placeholder={t.caption} maxlength={140} />
		</div>
	{/snippet}
</ListEditor>

<style>
	.upload {
		position: relative;
		margin-bottom: 10px;
	}

	.photo {
		display: flex;
		gap: 10px;
		align-items: flex-start;
	}

	img {
		width: 64px;
		height: 64px;
		object-fit: cover;
		border-radius: 3px;
	}

	.photo :global(.localized) {
		flex: 1;
		margin: 0;
	}
</style>
