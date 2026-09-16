<script lang="ts">
	import ImagePlus from '@lucide/svelte/icons/image-plus';
	import X from '@lucide/svelte/icons/x';
	import { errorMessage } from '$lib/errors';
	import { getEditor } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import { uploadImage, type UploadPurpose } from '$lib/images';

	let {
		value = $bindable(),
		purpose,
		label
	}: { value: number | null; purpose: UploadPurpose; label?: string } = $props();

	const i18n = getI18n();
	const editor = getEditor();
	let busy = $state(false);
	let error = $state('');
	const image = $derived(value ? editor.preview.uploads[value] : null);

	async function pick(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const file = input.files?.[0];
		input.value = '';
		if (!file) return;
		busy = true;
		error = '';
		try {
			const upload = await uploadImage(file, purpose);
			editor.remember(upload);
			value = upload.id;
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<div class="picker">
	{#if label}<span class="field-label">{label}</span>{/if}
	<div class="row">
		{#if image}
			<span class="thumb">
				<img src={image.url} alt="" />
				<button
					type="button"
					class="remove"
					title={i18n.t.common.remove}
					onclick={() => (value = null)}><X size={12} /></button
				>
			</span>
		{/if}
		<label class="btn btn-light btn-sm">
			<ImagePlus size={14} />
			{busy ? i18n.t.common.uploading : image ? i18n.t.common.replace : i18n.t.common.upload}
			<input type="file" accept="image/*" class="visually-hidden" onchange={pick} disabled={busy} />
		</label>
	</div>
	{#if error}<span class="field-error">{error}</span>{/if}
</div>

<style>
	.picker {
		display: grid;
		gap: 4px;
		margin-bottom: 12px;
	}

	.thumb {
		position: relative;
		width: 56px;
		height: 56px;
		overflow: hidden;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	.thumb img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.remove {
		position: absolute;
		top: 2px;
		right: 2px;
		display: grid;
		place-items: center;
		width: 18px;
		height: 18px;
		padding: 0;
		color: #fff;
		background: rgba(0, 0, 0, 0.6);
		border: 0;
		border-radius: 50%;
		cursor: pointer;
	}

	label {
		position: relative;
	}
</style>
