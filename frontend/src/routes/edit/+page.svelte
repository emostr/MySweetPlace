<script lang="ts">
	import { tick } from 'svelte';
	import Plus from '@lucide/svelte/icons/plus';
	import { page } from '$app/state';
	import BlockEditor from '$lib/components/editor/BlockEditor.svelte';
	import KindPicker from '$lib/components/editor/KindPicker.svelte';
	import { api } from '$lib/api';
	import { getEditor } from '$lib/editor/state.svelte';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import type { BlockKind, Place } from '$lib/types';

	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor);

	let openId = $state<number | null>(Number(page.url.searchParams.get('block')) || null);
	let picking = $state(false);
	let dragId: number | null = null;
	let error = $state('');
	const blocks = $derived(editor.place.blocks);

	async function add(kind: BlockKind) {
		picking = false;
		error = '';
		try {
			const result = await api.post<{ block_id: number; place: Place }>('/api/my/blocks', { kind });
			editor.place = result.place;
			openId = result.block_id;
			await tick();
			document
				.getElementById(`editor-block-${result.block_id}`)
				?.scrollIntoView({ behavior: 'smooth', block: 'start' });
		} catch (e) {
			error = errorMessage(e, i18n);
		}
	}

	async function reorder(ids: number[]) {
		error = '';
		try {
			await editor.mutate(api.put<{ place: Place }>('/api/my/blocks/order', { ids }));
		} catch (e) {
			error = errorMessage(e, i18n);
		}
	}

	function move(index: number, delta: number) {
		const ids = blocks.map((block) => block.id);
		[ids[index], ids[index + delta]] = [ids[index + delta], ids[index]];
		reorder(ids);
	}

	function drop(index: number) {
		if (dragId === null) return;
		const ids = blocks.map((block) => block.id).filter((id) => id !== dragId);
		ids.splice(index, 0, dragId);
		dragId = null;
		reorder(ids);
	}
</script>

<div class="head">
	<h1>{t.tabs.blocks}</h1>
	<button class="btn" onclick={() => (picking = !picking)}><Plus size={15} /> {t.blocks.add}</button
	>
</div>

{#if picking}
	<KindPicker
		existing={blocks.map((block) => block.kind)}
		onpick={add}
		onclose={() => (picking = false)}
	/>
{/if}

{#if error}<p class="notice notice-error">{error}</p>{/if}

<div class="list">
	{#each blocks as block, index (block.id)}
		<BlockEditor
			{block}
			open={openId === block.id}
			first={index === 0}
			last={index === blocks.length - 1}
			ontoggle={() => (openId = openId === block.id ? null : block.id)}
			onmove={(delta) => move(index, delta)}
			ondragstart={() => (dragId = block.id)}
			ondrop={() => drop(index)}
		/>
	{/each}
</div>

<style>
	.head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 10px;
		margin-bottom: 16px;
	}

	h1 {
		font-size: 26px;
	}

	.list {
		display: grid;
		gap: 8px;
	}
</style>
