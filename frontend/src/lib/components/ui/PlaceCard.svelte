<script lang="ts">
	import Avatar from './Avatar.svelte';
	import { getI18n } from '$lib/i18n';
	import type { PlaceCard } from '$lib/types';

	let { place }: { place: PlaceCard } = $props();
	const i18n = getI18n();
	const name = $derived(i18n.pick(place.name) || place.username);
	const tagline = $derived(i18n.pick(place.tagline));
</script>

<a
	class="place-card"
	href="/@{place.username}"
	style="--tint: {place.accent}; --wash: {place.background}"
>
	<span class="stripe"></span>
	<Avatar src={place.avatar_url} {name} size={46} accent={place.accent} />
	<span class="info">
		<strong>{name}</strong>
		<span class="username">@{place.username}</span>
		{#if tagline}<span class="tagline">{tagline}</span>{/if}
	</span>
</a>

<style>
	.place-card {
		position: relative;
		display: flex;
		gap: 12px;
		align-items: flex-start;
		padding: 14px 14px 14px 18px;
		overflow: hidden;
		color: inherit;
		text-decoration: none;
		background: #fff;
		border: 1px solid var(--line);
		border-radius: 3px;
		transition:
			border-color 0.15s,
			box-shadow 0.15s;
	}

	.place-card:hover {
		color: inherit;
		border-color: var(--line-strong);
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	}

	.stripe {
		position: absolute;
		inset: 0 auto 0 0;
		width: 5px;
		background: var(--tint);
		box-shadow: 3px 0 0 var(--wash);
	}

	.info {
		display: grid;
		min-width: 0;
	}

	strong {
		overflow: hidden;
		font: normal 16px/1.3 var(--serif);
		color: var(--ink-strong);
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.username {
		font-size: 12px;
		color: color-mix(in srgb, var(--tint) 65%, #1f1f1f);
	}

	.tagline {
		display: -webkit-box;
		margin-top: 4px;
		overflow: hidden;
		font-size: 13px;
		color: var(--ink-soft);
		-webkit-line-clamp: 2;
		line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
