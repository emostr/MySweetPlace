<script lang="ts">
	import TechBadge from '$lib/components/ui/TechBadge.svelte';
	import { getI18n } from '$lib/i18n';
	import { resolveStackItem, STACK_CATEGORIES } from '$lib/stack';
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'stack'> } = $props();
	const i18n = getI18n();

	const techs = $derived(
		block.data.items.map((item) => ({
			id: item.id,
			tech: resolveStackItem(item),
			custom: !item.slug
		}))
	);
	const groups = $derived(
		[...STACK_CATEGORIES, 'other' as const]
			.map((category) => ({
				category,
				items: techs.filter((entry) => entry.tech.category === category)
			}))
			.filter((group) => group.items.length)
	);
</script>

{#if block.style.variant === 'grouped'}
	<div class="groups">
		{#each groups as group (group.category)}
			<div>
				<h3>{i18n.t.stack.categories[group.category]}</h3>
				<div class="badges">
					{#each group.items as entry (entry.id)}<TechBadge tech={entry.tech} />{/each}
				</div>
			</div>
		{/each}
	</div>
{:else}
	<div class={block.style.variant === 'icons' ? 'icons' : 'badges'}>
		{#each techs as entry (entry.id)}
			<TechBadge tech={entry.tech} mode={block.style.variant === 'icons' ? 'icon' : 'badge'} />
		{/each}
	</div>
{/if}

<style>
	.badges {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
	}

	.icons {
		display: flex;
		flex-wrap: wrap;
		gap: 12px 6px;
	}

	.groups {
		display: grid;
		gap: 14px;
	}

	h3 {
		margin: 0 0 6px;
		font-size: 0.8em;
		color: var(--p-muted);
		text-transform: uppercase;
		letter-spacing: 1px;
		font-family: var(--p-font);
	}
</style>
