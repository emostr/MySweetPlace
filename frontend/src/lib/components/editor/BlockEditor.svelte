<script lang="ts">
	import type { Component } from 'svelte';
	import ChevronDown from '@lucide/svelte/icons/chevron-down';
	import GripVertical from '@lucide/svelte/icons/grip-vertical';
	import Eye from '@lucide/svelte/icons/eye';
	import EyeOff from '@lucide/svelte/icons/eye-off';
	import ArrowUp from '@lucide/svelte/icons/arrow-up';
	import ArrowDown from '@lucide/svelte/icons/arrow-down';
	import Trash from '@lucide/svelte/icons/trash';
	import LocalizedInput from './LocalizedInput.svelte';
	import Segmented from './Segmented.svelte';
	import LinksEditor from './kinds/LinksEditor.svelte';
	import ProjectsEditor from './kinds/ProjectsEditor.svelte';
	import NotesEditor from './kinds/NotesEditor.svelte';
	import NowEditor from './kinds/NowEditor.svelte';
	import StackEditor from './kinds/StackEditor.svelte';
	import InterestsEditor from './kinds/InterestsEditor.svelte';
	import MusicEditor from './kinds/MusicEditor.svelte';
	import PhotosEditor from './kinds/PhotosEditor.svelte';
	import GuestbookEditor from './kinds/GuestbookEditor.svelte';
	import TimelineEditor from './kinds/TimelineEditor.svelte';
	import TextEditor from './kinds/TextEditor.svelte';
	import { api } from '$lib/api';
	import { BLOCK_ICONS, blockTitle, VARIANTS } from '$lib/blocks';
	import { clone, getEditor } from '$lib/editor/state.svelte';
	import { errorMessage, fieldErrors } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import type { Block, BlockKind, Place } from '$lib/types';

	let {
		block,
		open,
		first,
		last,
		ontoggle,
		onmove,
		ondragstart,
		ondrop
	}: {
		block: Block;
		open: boolean;
		first: boolean;
		last: boolean;
		ontoggle: () => void;
		onmove: (delta: number) => void;
		ondragstart: () => void;
		ondrop: () => void;
	} = $props();

	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.blocks);

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const forms: Partial<Record<BlockKind, Component<any>>> = {
		links: LinksEditor,
		projects: ProjectsEditor,
		notes: NotesEditor,
		now: NowEditor,
		stack: StackEditor,
		interests: InterestsEditor,
		music: MusicEditor,
		photos: PhotosEditor,
		guestbook: GuestbookEditor,
		timeline: TimelineEditor,
		text: TextEditor
	};

	const draft = $derived(editor.blockDrafts[block.id]);
	const Icon = $derived(BLOCK_ICONS[block.kind]);
	const Form = $derived(forms[block.kind]);
	const dirty = $derived(
		!!draft &&
			JSON.stringify({ title: block.title, data: block.data, style: block.style }) !==
				JSON.stringify(draft)
	);

	let busy = $state(false);
	let error = $state('');
	let errors = $state<Record<string, string>>({});
	let saved = $state(false);
	let dragging = $state(false);

	$effect(() => {
		if (open && !editor.blockDrafts[block.id]) {
			editor.blockDrafts[block.id] = clone({
				title: block.title,
				data: block.data,
				style: block.style
			});
		}
	});

	function scoped(prefix: string) {
		return Object.fromEntries(
			Object.entries(errors)
				.filter(([key]) => key.startsWith(`${prefix}.`))
				.map(([key, message]) => [key.slice(prefix.length + 1), message])
		);
	}

	async function save() {
		if (!draft) return;
		busy = true;
		error = '';
		errors = {};
		try {
			await editor.mutate(api.patch<{ place: Place }>(`/api/my/blocks/${block.id}`, draft));
			delete editor.blockDrafts[block.id];
			saved = true;
			setTimeout(() => (saved = false), 2000);
		} catch (e) {
			errors = fieldErrors(e);
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}

	function cancel() {
		delete editor.blockDrafts[block.id];
		errors = {};
		error = '';
		ontoggle();
	}

	async function toggleVisible() {
		await editor.mutate(
			api.patch<{ place: Place }>(`/api/my/blocks/${block.id}`, { visible: !block.visible })
		);
	}

	async function remove() {
		if (!confirm(t.deleteConfirm(blockTitle(block, i18n)))) return;
		delete editor.blockDrafts[block.id];
		await editor.mutate(api.delete<{ place: Place }>(`/api/my/blocks/${block.id}`));
	}
</script>

<article
	class="block-editor"
	class:open
	class:dragging
	class:hidden-block={!block.visible}
	id="editor-block-{block.id}"
	ondragover={(event) => event.preventDefault()}
	ondrop={(event) => {
		event.preventDefault();
		ondrop();
	}}
>
	<header>
		<span
			class="grip"
			draggable="true"
			title={i18n.t.common.dragHint}
			role="button"
			tabindex="-1"
			ondragstart={(event) => {
				dragging = true;
				event.dataTransfer?.setData('text/plain', String(block.id));
				ondragstart();
			}}
			ondragend={() => (dragging = false)}
		>
			<GripVertical size={16} />
		</span>
		<button class="title" onclick={ontoggle} aria-expanded={open}>
			<span class="icon"><Icon size={15} /></span>
			<span class="name"
				>{blockTitle({ kind: block.kind, title: draft?.title ?? block.title }, i18n)}</span
			>
			{#if dirty}<span class="dot" title={i18n.t.common.unsaved}></span>{/if}
			{#if !block.visible}<span class="badge">{t.hidden}</span>{/if}
			{#if saved}<span class="saved">✓ {i18n.t.common.saved}</span>{/if}
		</button>
		<span class="tools">
			<button
				class="icon-btn"
				title={block.visible ? i18n.t.common.hide : i18n.t.common.show}
				onclick={toggleVisible}
			>
				{#if block.visible}<Eye size={15} />{:else}<EyeOff size={15} />{/if}
			</button>
			<button class="icon-btn" title={i18n.t.common.up} disabled={first} onclick={() => onmove(-1)}
				><ArrowUp size={15} /></button
			>
			<button class="icon-btn" title={i18n.t.common.down} disabled={last} onclick={() => onmove(1)}
				><ArrowDown size={15} /></button
			>
			<button class="icon-btn chevron" onclick={ontoggle} aria-label={i18n.t.common.edit}
				><ChevronDown size={16} /></button
			>
		</span>
	</header>

	{#if open && draft}
		<div class="body">
			{#if Form}
				<section>
					<h4>{t.content}</h4>
					<Form bind:data={draft.data} errors={scoped('data')} />
				</section>
			{:else if block.kind === 'intro'}
				<p class="hint">{i18n.t.editor.forms.introHint} <a href="/edit/profile">→</a></p>
			{:else if block.kind === 'neighbours'}
				<p class="hint">{i18n.t.editor.forms.neighboursHint} <a href="/edit/neighbours">→</a></p>
			{/if}

			<section class="look">
				<h4>{t.look}</h4>
				{#if block.kind !== 'intro'}
					<LocalizedInput
						bind:value={draft.title}
						label={t.title}
						placeholder={t.titlePlaceholder(i18n.t.blocks.titles[block.kind])}
						maxlength={60}
					/>
					<label class="check">
						<input type="checkbox" bind:checked={draft.style.hide_title} />
						<span>{t.hideTitle}</span>
					</label>
				{/if}
				<div class="look-grid">
					{#if VARIANTS[block.kind].length > 1}
						<div class="field">
							<span class="field-label">{t.variant}</span>
							<Segmented
								bind:value={draft.style.variant}
								label={t.variant}
								options={VARIANTS[block.kind].map((value) => ({
									value,
									label: t.variants[value] ?? value
								}))}
							/>
						</div>
					{/if}
					<div class="field">
						<span class="field-label">{t.width}</span>
						<Segmented
							bind:value={draft.style.width}
							label={t.width}
							options={[
								{ value: 'full', label: t.widths.full },
								{ value: 'half', label: t.widths.half }
							]}
						/>
					</div>
					<div class="field">
						<span class="field-label">{t.accent}</span>
						<span class="row">
							<input
								type="color"
								value={draft.style.accent ?? editor.preview.theme.colors.accent}
								oninput={(e) => (draft.style.accent = e.currentTarget.value)}
							/>
							{#if draft.style.accent}
								<button class="btn btn-ghost btn-sm" onclick={() => (draft.style.accent = null)}
									>{i18n.t.common.remove}</button
								>
							{/if}
						</span>
					</div>
				</div>
			</section>

			{#if error}<p class="notice notice-error">{error}</p>{/if}

			<footer>
				<button class="btn btn-ghost btn-sm danger" onclick={remove}
					><Trash size={14} /> {t.delete}</button
				>
				<span class="spacer"></span>
				<button class="btn btn-light" onclick={cancel}>{i18n.t.common.cancel}</button>
				<button class="btn" onclick={save} disabled={busy || !dirty}
					>{busy ? i18n.t.common.saving : i18n.t.common.save}</button
				>
			</footer>
		</div>
	{/if}
</article>

<style>
	.block-editor {
		background: #fff;
		border: 1px solid var(--line);
		border-radius: 3px;
		transition: box-shadow 0.15s;
	}

	.block-editor.open {
		border-color: var(--line-strong);
		box-shadow: 0 3px 14px rgba(0, 0, 0, 0.08);
	}

	.block-editor.dragging {
		opacity: 0.5;
	}

	header {
		display: flex;
		align-items: center;
		gap: 4px;
		padding: 4px 6px 4px 2px;
		background: linear-gradient(#fdfdfd, #f3f4f5);
		border-radius: 3px;
	}

	.open header {
		border-bottom: 1px solid var(--line);
		border-radius: 3px 3px 0 0;
	}

	.grip {
		display: grid;
		place-items: center;
		width: 22px;
		height: 30px;
		color: #b3b6ba;
		cursor: grab;
	}

	.title {
		display: flex;
		flex: 1;
		gap: 8px;
		align-items: center;
		min-width: 0;
		padding: 6px 4px;
		text-align: left;
		background: none;
		border: 0;
		cursor: pointer;
	}

	.icon {
		color: var(--accent);
	}

	.name {
		overflow: hidden;
		font: normal 15px var(--serif);
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.hidden-block .name {
		color: var(--ink-soft);
	}

	.dot {
		width: 7px;
		height: 7px;
		flex: none;
		background: #e0a100;
		border-radius: 50%;
	}

	.badge {
		padding: 0 6px;
		font-size: 10px;
		color: var(--ink-soft);
		text-transform: uppercase;
		letter-spacing: 1px;
		border: 1px solid var(--line-strong);
		border-radius: 3px;
	}

	.saved {
		font-size: 12px;
		color: var(--ok);
	}

	.tools {
		display: flex;
	}

	.chevron :global(svg) {
		transition: transform 0.15s;
	}

	.open .chevron :global(svg) {
		transform: rotate(180deg);
	}

	.body {
		padding: 14px 16px 12px;
	}

	h4 {
		margin: 0 0 10px;
		font: bold 11px var(--sans);
		color: var(--ink-soft);
		text-transform: uppercase;
		letter-spacing: 1px;
	}

	.look {
		margin-top: 18px;
		padding-top: 14px;
		border-top: 1px dashed var(--line-strong);
	}

	.look-grid {
		display: flex;
		flex-wrap: wrap;
		gap: 4px 20px;
	}

	input[type='color'] {
		width: 40px;
		height: 30px;
		padding: 0;
		border: 1px solid var(--line-strong);
		border-radius: 3px;
	}

	footer {
		display: flex;
		gap: 8px;
		align-items: center;
		margin-top: 12px;
		padding-top: 12px;
		border-top: 1px solid var(--line);
	}

	.spacer {
		flex: 1;
	}

	.danger {
		color: var(--danger);
	}
</style>
