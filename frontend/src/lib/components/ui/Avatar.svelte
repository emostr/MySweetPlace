<script lang="ts">
	import { contrastInk } from '$lib/theme/style';

	let {
		src,
		name,
		size = 40,
		accent = '#7a2531',
		round = true
	}: {
		src: string | null;
		name: string;
		size?: number;
		accent?: string;
		round?: boolean;
	} = $props();

	const initial = $derived(name.replace(/^@/, '').trim().charAt(0).toUpperCase() || '?');
	const ink = $derived(/^#[0-9a-f]{6}$/i.test(accent) ? contrastInk(accent) : '#fff');
</script>

{#if src}
	<img
		class="avatar"
		class:round
		{src}
		alt=""
		width={size}
		height={size}
		loading="lazy"
		style="--size: {size}px"
	/>
{:else}
	<span
		class="avatar empty"
		class:round
		style="--size: {size}px; --tint: {accent}; --ink: {ink}"
		aria-hidden="true">{initial}</span
	>
{/if}

<style>
	.avatar {
		flex: none;
		width: var(--size);
		height: var(--size);
		object-fit: cover;
		border-radius: 4px;
	}

	.round {
		border-radius: 50%;
	}

	.empty {
		display: grid;
		place-items: center;
		font:
			calc(var(--size) * 0.45) / 1 Georgia,
			serif;
		color: var(--ink);
		background: var(--tint);
		background-image: linear-gradient(rgba(255, 255, 255, 0.18), rgba(0, 0, 0, 0.12));
	}
</style>
