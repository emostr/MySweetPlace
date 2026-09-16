<script lang="ts">
	import Shuffle from '@lucide/svelte/icons/shuffle';
	import SquarePen from '@lucide/svelte/icons/square-pen';
	import LogIn from '@lucide/svelte/icons/log-in';
	import LocaleSwitch from '$lib/components/site/LocaleSwitch.svelte';
	import NeighbourButton from './NeighbourButton.svelte';
	import { getI18n } from '$lib/i18n';
	import type { Me, Place } from '$lib/types';

	let { place, me }: { place: Place; me: Me } = $props();
	const i18n = getI18n();
</script>

<header class="place-bar">
	<a class="logo" href="/">MySweetPlace</a>
	<nav>
		<a class="bar-link" href="/random?from={place.username}" data-sveltekit-preload-data="off">
			<Shuffle size={15} />
			<span class="long">{i18n.t.site.takeMeSomewhere}</span>
		</a>
		{#if place.owner}
			<a class="bar-btn" href="/edit"><SquarePen size={15} /> {i18n.t.place.edit}</a>
		{:else if me.place}
			<NeighbourButton username={place.username} neighbour={place.neighbour} />
		{:else if !me.user}
			<a class="bar-link" href="/login?next=/@{place.username}"
				><LogIn size={15} /> {i18n.t.site.nav.login}</a
			>
		{/if}
		<LocaleSwitch signedIn={!!me.user} />
	</nav>
</header>

<style>
	.place-bar {
		position: relative;
		z-index: 5;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 12px;
		padding: 0 20px;
		font: 13px/1.4 var(--sans);
		background: linear-gradient(var(--bar-top), var(--bar-bottom));
		border-bottom: 1px solid var(--bar-deep);
	}

	.logo {
		font: normal 19px/46px var(--serif);
		color: #fff;
		text-decoration: none;
		text-shadow: 0 1px 0 #000;
	}

	.place-bar .logo:hover {
		color: #fff;
	}

	nav {
		display: flex;
		gap: 10px;
		align-items: center;
	}

	.bar-link {
		display: inline-flex;
		gap: 6px;
		align-items: center;
		color: var(--bar-ink);
		text-decoration: none;
	}

	.place-bar .bar-link:hover {
		color: #fff;
	}

	.place-bar :global(.bar-btn) {
		display: inline-flex;
		gap: 6px;
		align-items: center;
		padding: 4px 11px;
		font: bold 12px/1.4 var(--sans);
		color: #fff;
		text-decoration: none;
		background: linear-gradient(#8e2e3b, #6d2230);
		border: 1px solid #4a1520;
		border-radius: 3px;
		box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2);
		cursor: pointer;
	}

	.place-bar :global(.bar-btn.on) {
		background: linear-gradient(#4b5058, #3a3f46);
		border-color: #1c1f22;
	}

	.place-bar :global(.bar-btn:disabled) {
		opacity: 0.7;
	}

	@media (max-width: 640px) {
		.place-bar {
			padding: 0 12px;
		}

		.long {
			display: none;
		}
	}
</style>
