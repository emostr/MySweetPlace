<script lang="ts">
	import ExternalLink from '@lucide/svelte/icons/external-link';
	import GitBranch from '@lucide/svelte/icons/git-branch';
	import TechBadge from '$lib/components/ui/TechBadge.svelte';
	import { getI18n } from '$lib/i18n';
	import { formatPartialDate } from '$lib/dates';
	import { customTech, findTech } from '$lib/stack';
	import type { BlockOf, Place, ProjectItem } from '$lib/types';

	let { block, place }: { block: BlockOf<'projects'>; place: Place } = $props();
	const i18n = getI18n();

	const period = (project: ProjectItem) => {
		if (!project.started && !project.finished) return '';
		const start = project.started ? formatPartialDate(project.started, i18n.locale) : '…';
		const end = project.finished
			? formatPartialDate(project.finished, i18n.locale)
			: project.status === 'in_progress'
				? i18n.t.blocks.projects.present
				: '';
		return end ? `${start} — ${end}` : start;
	};

	const tech = (name: string) => findTech(name) ?? customTech(name);
</script>

<div class="projects {block.style.variant}">
	{#each block.data.items as project (project.id)}
		{@const cover = project.image_ids.map((id) => place.uploads[id]).find(Boolean)}
		<article class="project">
			{#if cover && block.style.variant === 'cards'}
				<a
					class="cover"
					href={project.url || project.repo || cover.url}
					target="_blank"
					rel="noopener"
				>
					<img src={cover.url} alt="" loading="lazy" width={cover.width} height={cover.height} />
				</a>
			{/if}
			<div class="body">
				<div class="head">
					<h3>{i18n.pick(project.title)}</h3>
					<span class="status status-{project.status}"
						>{i18n.t.blocks.projects.statuses[project.status]}</span
					>
				</div>
				{#if period(project)}<div class="period">{period(project)}</div>{/if}
				{#if i18n.pick(project.description)}
					<p class="description">{i18n.pick(project.description)}</p>
				{/if}
				{#if project.stack.length}
					<div class="stack">
						{#each project.stack as name (name)}
							<TechBadge tech={tech(name)} />
						{/each}
					</div>
				{/if}
				{#if project.meta.length}
					<dl class="meta">
						{#each project.meta as row, index (index)}
							<dt>{row.key}</dt>
							<dd>{row.value}</dd>
						{/each}
					</dl>
				{/if}
				{#if project.url || project.repo}
					<div class="actions">
						{#if project.url}
							<a href={project.url} target="_blank" rel="noopener"
								><ExternalLink size={14} /> {i18n.t.blocks.projects.site}</a
							>
						{/if}
						{#if project.repo}
							<a href={project.repo} target="_blank" rel="noopener"
								><GitBranch size={14} /> {i18n.t.blocks.projects.repo}</a
							>
						{/if}
					</div>
				{/if}
				{#if block.style.variant === 'cards' && project.image_ids.length > 1}
					<div class="gallery">
						{#each project.image_ids.slice(1) as id (id)}
							{@const image = place.uploads[id]}
							{#if image}
								<a href={image.url} target="_blank" rel="noopener"
									><img src={image.url} alt="" loading="lazy" /></a
								>
							{/if}
						{/each}
					</div>
				{/if}
			</div>
		</article>
	{/each}
</div>

<style>
	.projects {
		display: grid;
		gap: 14px;
	}

	.cards {
		grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
	}

	.project {
		min-width: 0;
		overflow: hidden;
	}

	.cards .project {
		background: color-mix(in srgb, var(--p-surface) 92%, var(--p-text));
		border: 1px solid var(--p-border);
		border-radius: min(var(--p-radius), 10px);
	}

	.cards .body {
		padding: 12px 14px 14px;
	}

	.list .project + .project {
		padding-top: 14px;
		border-top: 1px dashed var(--p-border);
	}

	.cover {
		display: block;
		aspect-ratio: 16 / 9;
		overflow: hidden;
		background: var(--p-border);
	}

	.cover img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.head {
		display: flex;
		flex-wrap: wrap;
		gap: 6px 10px;
		align-items: baseline;
		justify-content: space-between;
	}

	h3 {
		margin: 0;
		font-size: 1.12em;
	}

	.status {
		padding: 0 8px;
		font-size: 0.75em;
		line-height: 1.8;
		white-space: nowrap;
		border-radius: 999px;
		color: var(--p-text);
		background: color-mix(in srgb, var(--p-text) 10%, transparent);
	}

	.status-in_progress {
		color: var(--p-accent-ink);
		background: var(--p-accent);
	}

	.status-done {
		color: #1f5f2c;
		background: #d9efdc;
	}

	.status-idea {
		color: #6a4b00;
		background: #fbecc0;
	}

	.period {
		margin-top: 2px;
		font-size: 0.82em;
		color: var(--p-muted);
	}

	.description {
		margin: 8px 0 0;
		white-space: pre-line;
	}

	.stack {
		display: flex;
		flex-wrap: wrap;
		gap: 5px;
		margin-top: 10px;
		font-size: 0.92em;
	}

	.meta {
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 2px 12px;
		margin: 10px 0 0;
		font-size: 0.88em;
	}

	dt {
		color: var(--p-muted);
	}

	dd {
		margin: 0;
	}

	.actions {
		display: flex;
		gap: 14px;
		margin-top: 10px;
		font-size: 0.92em;
	}

	.actions a {
		display: inline-flex;
		gap: 4px;
		align-items: center;
	}

	.gallery {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
		gap: 4px;
		margin-top: 10px;
	}

	.gallery img {
		width: 100%;
		aspect-ratio: 1;
		object-fit: cover;
		border-radius: 4px;
	}
</style>
