<script lang="ts">
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'interests'> } = $props();
</script>

<ul class="interests {block.style.variant}">
	{#each block.data.items as item (item.id)}
		<li>
			<a
				class={block.style.variant === 'tags' ? 'chip' : ''}
				href="/explore?interest={encodeURIComponent(item.label.toLowerCase())}"
			>
				{#if item.emoji}<span>{item.emoji}</span>{/if}
				{item.label}
			</a>
		</li>
	{/each}
</ul>

<style>
	.interests {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.tags {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
	}

	.tags a:hover {
		border-color: var(--p-accent);
	}

	.list {
		display: grid;
		gap: 4px;
	}

	.list a {
		display: inline-flex;
		gap: 8px;
		color: var(--p-text);
		text-decoration: none;
	}

	.list a:hover {
		color: var(--p-accent);
	}
</style>
