<script lang="ts">
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockOf, Place } from '$lib/types';

	let { block, place }: { block: BlockOf<'neighbours'>; place: Place } = $props();
	const i18n = getI18n();
	const items = $derived(block.content.items);
</script>

{#if items.length === 0}
	<p class="place-empty">
		{place.owner ? i18n.t.blocks.neighbours.emptyOwner : i18n.t.blocks.neighbours.empty}
	</p>
{:else if block.style.variant === 'district'}
	<div class="district">
		{#each items as neighbour, index (neighbour.id)}
			{@const name = i18n.pick(neighbour.name) || neighbour.username}
			<a
				class="house"
				href="/@{neighbour.username}"
				style="--roof: {neighbour.accent}; --wall: {neighbour.background}; --lift: {(index % 3) *
					4}px"
				title={neighbour.label || name}
			>
				<svg viewBox="0 0 80 74" aria-hidden="true">
					<rect x="58" y="6" width="8" height="16" fill="var(--roof)" opacity="0.8" />
					<path d="M4 36 40 6l36 30z" fill="var(--roof)" />
					<rect x="12" y="34" width="56" height="38" fill="var(--wall)" stroke="rgba(0,0,0,.25)" />
					<rect x="44" y="50" width="14" height="22" fill="var(--roof)" opacity="0.85" />
				</svg>
				<span class="window"
					><Avatar
						src={neighbour.avatar_url}
						{name}
						size={26}
						accent={neighbour.accent}
						round={false}
					/></span
				>
				<span class="name">@{neighbour.username}</span>
			</a>
		{/each}
		<span class="ground" aria-hidden="true"></span>
	</div>
{:else}
	<ul class="list">
		{#each items as neighbour (neighbour.id)}
			{@const name = i18n.pick(neighbour.name) || neighbour.username}
			<li>
				<a href="/@{neighbour.username}">
					<Avatar src={neighbour.avatar_url} {name} size={36} accent={neighbour.accent} />
					<span class="info">
						<span class="title">{name}</span>
						<span class="muted"
							>@{neighbour.username}{neighbour.label ? ` · ${neighbour.label}` : ''}</span
						>
					</span>
				</a>
			</li>
		{/each}
	</ul>
{/if}

<style>
	.list {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 6px 14px;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.list a {
		display: flex;
		gap: 10px;
		align-items: center;
		padding: 4px;
		margin: -4px;
		text-decoration: none;
		border-radius: 6px;
	}

	.list a:hover {
		background: color-mix(in srgb, var(--p-accent) 8%, transparent);
	}

	.info {
		display: grid;
		min-width: 0;
		line-height: 1.35;
	}

	.title {
		overflow: hidden;
		color: var(--p-text);
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.info .muted {
		overflow: hidden;
		font-size: 0.82em;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.district {
		position: relative;
		display: flex;
		flex-wrap: wrap;
		gap: 6px 4px;
		align-items: flex-end;
		padding: 8px 4px 14px;
	}

	.ground {
		position: absolute;
		left: 0;
		right: 0;
		bottom: 8px;
		height: 6px;
		background: color-mix(in srgb, var(--p-accent) 25%, var(--p-border));
		border-radius: 3px;
	}

	.house {
		position: relative;
		z-index: 1;
		display: grid;
		justify-items: center;
		width: 92px;
		margin-bottom: var(--lift);
		text-decoration: none;
		transition: transform 0.15s;
	}

	.house:hover {
		transform: translateY(-4px);
	}

	svg {
		width: 80px;
		height: 74px;
		filter: drop-shadow(0 2px 2px rgba(0, 0, 0, 0.15));
	}

	.window {
		position: absolute;
		top: 42px;
		left: 20px;
		display: block;
		padding: 2px;
		background: #fff8d6;
		border: 1px solid rgba(0, 0, 0, 0.25);
	}

	.name {
		max-width: 92px;
		overflow: hidden;
		font-size: 0.75em;
		color: var(--p-text);
		text-overflow: ellipsis;
		white-space: nowrap;
	}
</style>
