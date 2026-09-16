<script lang="ts">
	import X from '@lucide/svelte/icons/x';
	import Plus from '@lucide/svelte/icons/plus';
	import TechBadge from '$lib/components/ui/TechBadge.svelte';
	import { uid } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';
	import { resolveStackItem, searchTech, type Tech } from '$lib/stack';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['stack'] } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor.forms);

	let search = $state('');
	let customName = $state('');
	let customColor = $state('#7a2531');

	const selected = $derived(new Set(data.items.map((item) => item.slug).filter(Boolean)));
	const results = $derived(searchTech(search, 30));

	function add(tech: Tech) {
		if (selected.has(tech.id) || data.items.length >= 150) return;
		data.items = [...data.items, { id: uid(), slug: tech.id, name: '', color: null }];
	}

	function addCustom() {
		const name = customName.trim();
		if (!name) return;
		data.items = [...data.items, { id: uid(), slug: '', name, color: customColor }];
		customName = '';
	}

	function keydown(event: KeyboardEvent) {
		if (event.key === 'Enter') {
			event.preventDefault();
			if (results[0]) add(results[0]);
			search = '';
		}
	}
</script>

<div class="stack-editor">
	<div class="selected">
		<span class="field-label">{t.stackSelected(data.items.length)}</span>
		<div class="chips">
			{#each data.items as item (item.id)}
				<span class="chip-wrap">
					<TechBadge tech={resolveStackItem(item)} />
					<button
						type="button"
						class="x"
						title={i18n.t.common.remove}
						onclick={() => (data.items = data.items.filter((other) => other.id !== item.id))}
					>
						<X size={11} />
					</button>
				</span>
			{/each}
		</div>
	</div>

	<label class="field">
		<span class="field-label">{t.stackSearch}</span>
		<input
			class="input"
			bind:value={search}
			onkeydown={keydown}
			placeholder="Ruby, Svelte, PostgreSQL…"
		/>
	</label>
	{#if search.trim()}
		<div class="results">
			{#each results as tech (tech.id)}
				<button
					type="button"
					class="result"
					class:taken={selected.has(tech.id)}
					onclick={() => add(tech)}
				>
					<TechBadge {tech} />
					<small>{i18n.t.stack.categories[tech.category]}</small>
				</button>
			{:else}
				<p class="hint">{t.stackNothing}</p>
			{/each}
		</div>
	{/if}

	<fieldset class="custom">
		<legend class="field-label">{t.stackCustom}</legend>
		<div class="row">
			<input
				class="input"
				bind:value={customName}
				placeholder={t.stackCustomName}
				maxlength="40"
				onkeydown={(e) => e.key === 'Enter' && (e.preventDefault(), addCustom())}
			/>
			<input type="color" bind:value={customColor} aria-label={t.stackCustomColor} />
			<button type="button" class="btn btn-light btn-sm" onclick={addCustom}
				><Plus size={14} /> {i18n.t.common.add}</button
			>
		</div>
	</fieldset>
</div>

<style>
	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
		margin: 6px 0 14px;
		--p-surface: #fff;
		--p-border: #ddd;
		--p-text: #333;
	}

	.chip-wrap {
		display: inline-flex;
		align-items: center;
	}

	.x {
		display: grid;
		place-items: center;
		width: 18px;
		height: 18px;
		margin-left: -4px;
		padding: 0;
		color: #fff;
		background: #8a8f96;
		border: 2px solid #fff;
		border-radius: 50%;
		cursor: pointer;
	}

	.results {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
		max-height: 220px;
		margin: -6px 0 14px;
		padding: 8px;
		overflow: auto;
		background: #fafafb;
		border: 1px solid var(--line);
		border-radius: 3px;
		--p-surface: #fff;
		--p-border: #ddd;
	}

	.result {
		display: grid;
		gap: 1px;
		justify-items: start;
		padding: 2px;
		background: none;
		border: 0;
		cursor: pointer;
	}

	.result small {
		padding-left: 8px;
		font-size: 10px;
		color: var(--ink-soft);
	}

	.result.taken {
		opacity: 0.4;
	}

	.custom {
		margin: 0;
		padding: 8px 10px 10px;
		border: 1px dashed var(--line-strong);
		border-radius: 3px;
	}

	.custom .input {
		flex: 1;
	}

	input[type='color'] {
		width: 34px;
		height: 32px;
		padding: 0;
		border: 1px solid var(--line-strong);
		border-radius: 3px;
	}
</style>
