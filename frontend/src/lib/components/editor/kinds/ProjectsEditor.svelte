<script lang="ts">
	import ListEditor from '../ListEditor.svelte';
	import LocalizedInput from '../LocalizedInput.svelte';
	import ImagePicker from '../ImagePicker.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import { PROJECT_STATUSES, type BlockDataMap, type ProjectItem } from '$lib/types';

	let {
		data = $bindable(),
		errors
	}: { data: BlockDataMap['projects']; errors: Record<string, string> } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);

	const create = (): ProjectItem => ({
		id: uid(),
		title: {},
		description: {},
		status: 'in_progress',
		started: '',
		finished: '',
		url: '',
		repo: '',
		stack: [],
		image_ids: [],
		meta: []
	});

	const stackText = (project: ProjectItem) => project.stack.join(', ');
	const setStack = (project: ProjectItem, text: string) => {
		project.stack = text
			.split(',')
			.map((part) => part.trim())
			.filter(Boolean)
			.slice(0, 20);
	};
	const err = (index: number, field: string) => errors[`items.${index}.${field}`];
</script>

<ListEditor bind:items={data.items} {create} addLabel={t.addProject} max={30}>
	{#snippet item(project, index)}
		<LocalizedInput
			bind:value={project.title}
			label={t.projectTitle}
			maxlength={80}
			error={err(index, 'title')}
		/>
		<LocalizedInput
			bind:value={project.description}
			label={t.projectDescription}
			multiline
			maxlength={600}
		/>
		<div class="grid3">
			<label class="field">
				<span class="field-label">{t.projectStatus}</span>
				<select class="input" bind:value={project.status}>
					{#each PROJECT_STATUSES as status (status)}
						<option value={status}>{i18n.t.blocks.projects.statuses[status]}</option>
					{/each}
				</select>
			</label>
			<label class="field">
				<span class="field-label">{t.projectStarted}</span>
				<input
					class="input"
					bind:value={project.started}
					placeholder="2026-09"
					title={t.monthHint}
					aria-invalid={!!err(index, 'started')}
				/>
			</label>
			<label class="field">
				<span class="field-label">{t.projectFinished}</span>
				<input
					class="input"
					bind:value={project.finished}
					placeholder={t.monthHint}
					aria-invalid={!!err(index, 'finished')}
				/>
			</label>
		</div>
		<div class="grid2">
			<label class="field">
				<span class="field-label">{t.projectUrl}</span>
				<input
					class="input"
					bind:value={project.url}
					placeholder="https://"
					aria-invalid={!!err(index, 'url')}
				/>
			</label>
			<label class="field">
				<span class="field-label">{t.projectRepo}</span>
				<input
					class="input"
					bind:value={project.repo}
					placeholder="https://github.com/…"
					aria-invalid={!!err(index, 'repo')}
				/>
			</label>
		</div>
		<label class="field">
			<span class="field-label">{t.projectStack}</span>
			<input
				class="input"
				value={stackText(project)}
				onchange={(e) => setStack(project, e.currentTarget.value)}
				placeholder={t.projectStackHint}
			/>
		</label>
		<div class="images">
			<span class="field-label">{t.projectImages}</span>
			<div class="row">
				{#each project.image_ids, imageIndex}
					<ImagePicker
						bind:value={
							() => project.image_ids[imageIndex],
							(id) =>
								(project.image_ids = id
									? project.image_ids.map((existing, i) => (i === imageIndex ? id : existing))
									: project.image_ids.filter((_, i) => i !== imageIndex))
						}
						purpose="project"
					/>
				{/each}
				{#if project.image_ids.length < 6}
					<ImagePicker
						bind:value={() => null, (id) => id && (project.image_ids = [...project.image_ids, id])}
						purpose="project"
					/>
				{/if}
			</div>
		</div>
		<details class="meta">
			<summary>{t.projectMeta} ({project.meta.length})</summary>
			<ListEditor
				bind:items={project.meta}
				create={() => ({ key: '', value: '' })}
				addLabel={t.addMeta}
				max={10}
			>
				{#snippet item(row)}
					<div class="grid2">
						<input class="input" bind:value={row.key} placeholder={t.metaKey} maxlength="40" />
						<input class="input" bind:value={row.value} placeholder={t.metaValue} maxlength="160" />
					</div>
				{/snippet}
			</ListEditor>
		</details>
	{/snippet}
</ListEditor>

<style>
	.grid2,
	.grid3 {
		display: grid;
		gap: 0 8px;
	}

	.grid2 {
		grid-template-columns: 1fr 1fr;
	}

	.grid3 {
		grid-template-columns: 1.2fr 1fr 1fr;
	}

	.images .row {
		align-items: flex-start;
		margin-top: 4px;
	}

	.meta summary {
		margin-bottom: 6px;
		font-size: 12px;
		color: var(--ink-soft);
		cursor: pointer;
	}
</style>
