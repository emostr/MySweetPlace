<script lang="ts">
	import { page } from '$app/state';
	import { getI18n } from '$lib/i18n';
	import type { Me } from '$lib/types';
	import LocaleSwitch from './LocaleSwitch.svelte';

	let { me }: { me: Me } = $props();
	const i18n = getI18n();

	const links = $derived([
		{ href: '/', label: i18n.t.site.nav.home },
		{ href: '/explore', label: i18n.t.site.nav.explore },
		{ href: '/random', label: i18n.t.site.nav.random, random: true },
		{ href: '/about', label: i18n.t.site.nav.about }
	]);

	const active = (href: string) =>
		href === '/' ? page.url.pathname === '/' : page.url.pathname.startsWith(href);
</script>

<header class="site-header">
	<a class="logo" href="/">MySweetPlace</a>
	<nav aria-label="MySweetPlace">
		<ul>
			{#each links as link (link.href)}
				<li>
					<a
						href={link.href}
						class:active={active(link.href)}
						data-sveltekit-preload-data={link.random ? 'off' : undefined}
					>
						{link.label}
					</a>
				</li>
			{/each}
			{#if me.place}
				<li><a href="/@{me.place.username}">{i18n.t.site.nav.myPlace}</a></li>
				<li><a href="/edit" class:active={active('/edit')}>{i18n.t.site.nav.edit}</a></li>
			{:else}
				<li><a href="/login" class:active={active('/login')}>{i18n.t.site.nav.login}</a></li>
			{/if}
		</ul>
		<LocaleSwitch signedIn={!!me.user} />
	</nav>
</header>

<style>
	.site-header {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		padding: 0 30px;
		background: linear-gradient(var(--bar-top), var(--bar-bottom));
		border-bottom: 1px solid var(--bar-deep);
	}

	.logo {
		font: normal 24px/64px var(--serif);
		color: #fff;
		text-decoration: none;
		text-shadow: 0 1px 0 #000;
	}

	.logo:hover {
		color: #fff;
	}

	nav {
		display: flex;
		align-items: center;
		gap: 12px;
	}

	ul {
		display: flex;
		flex-wrap: wrap;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	nav a {
		display: block;
		padding: 0 13px;
		font-size: 12px;
		line-height: 64px;
		color: var(--bar-ink);
		text-decoration: none;
		text-transform: uppercase;
		letter-spacing: 1px;
	}

	nav a:hover,
	nav a.active {
		color: #fff;
		background: #22262a;
	}

	@media (max-width: 760px) {
		.site-header {
			padding: 0 16px;
		}

		.logo {
			line-height: 54px;
		}

		nav {
			width: 100%;
			justify-content: space-between;
			margin: 0 -10px 6px;
		}

		nav a {
			padding: 0 10px;
			line-height: 34px;
		}
	}
</style>
