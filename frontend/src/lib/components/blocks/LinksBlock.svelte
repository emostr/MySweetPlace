<script lang="ts">
	import Globe from '@lucide/svelte/icons/globe';
	import Mail from '@lucide/svelte/icons/mail';
	import ArrowUpRight from '@lucide/svelte/icons/arrow-up-right';
	import BrandIcon from '$lib/components/ui/BrandIcon.svelte';
	import { linkBrand, linkHost } from '$lib/links';
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'links'> } = $props();

	const links = $derived(
		block.data.items.map((item) => ({
			...item,
			brand: linkBrand(item.url),
			host: linkHost(item.url),
			mail: item.url.startsWith('mailto:')
		}))
	);
</script>

<ul class="links {block.style.variant}">
	{#each links as link (link.id)}
		<li>
			<a
				href={link.url}
				rel="me noopener"
				target="_blank"
				title={block.style.variant === 'icons' ? link.title || link.host : undefined}
			>
				<span class="icon">
					{#if link.brand}
						<BrandIcon slug={link.brand} />
					{:else if link.mail}
						<Mail size={16} />
					{:else}
						<Globe size={16} />
					{/if}
				</span>
				<span class="title">{link.title || link.host}</span>
				{#if block.style.variant === 'list'}
					<span class="host">{link.host}</span>
					<ArrowUpRight size={14} class="arrow" />
				{/if}
			</a>
		</li>
	{/each}
</ul>

<style>
	.links {
		display: grid;
		gap: 2px;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	a {
		display: flex;
		gap: 10px;
		align-items: center;
		text-decoration: none;
	}

	.icon {
		display: inline-grid;
		place-items: center;
		font-size: 17px;
	}

	.list a {
		padding: 6px 8px;
		margin: 0 -8px;
		border-radius: 4px;
	}

	.list a:hover {
		background: color-mix(in srgb, var(--p-accent) 8%, transparent);
	}

	.list .title {
		color: var(--p-text);
	}

	.host {
		margin-left: auto;
		overflow: hidden;
		font-size: 0.85em;
		color: var(--p-muted);
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.list :global(.arrow) {
		flex: none;
		color: var(--p-muted);
	}

	.buttons {
		gap: 8px;
	}

	.buttons a {
		justify-content: center;
		padding: 10px 16px;
		font-weight: bold;
		color: var(--p-accent-ink);
		background: var(--p-accent);
		background-image: linear-gradient(rgba(255, 255, 255, 0.14), rgba(0, 0, 0, 0.06));
		border-radius: max(var(--p-radius), 6px);
		transition: transform 0.12s;
	}

	.buttons a:hover {
		color: var(--p-accent-ink);
		transform: translateY(-1px);
	}

	.icons {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
	}

	.icons a {
		justify-content: center;
		width: 42px;
		height: 42px;
		color: var(--p-text);
		background: color-mix(in srgb, var(--p-surface) 88%, var(--p-text));
		border: 1px solid var(--p-border);
		border-radius: 50%;
	}

	.icons a:hover {
		color: var(--p-accent-ink);
		background: var(--p-accent);
	}

	.icons .title {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
	}
</style>
