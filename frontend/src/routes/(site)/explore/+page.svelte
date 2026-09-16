<script lang="ts">
	import Search from '@lucide/svelte/icons/search';
	import Shuffle from '@lucide/svelte/icons/shuffle';
	import PlaceCard from '$lib/components/ui/PlaceCard.svelte';
	import { query } from '$lib/api';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.explore);
	const filtered = $derived(!!(data.interest || data.q));
</script>

<svelte:head>
	<title>{t.title} — MySweetPlace</title>
	<meta name="description" content={t.lead} />
</svelte:head>

<section class="explore">
	<header>
		<h1>{t.title}</h1>
		<p class="muted">{t.lead}</p>
		<form class="search" method="get" data-sveltekit-keepfocus>
			<span class="search-field">
				<Search size={15} />
				<input class="input" name="q" value={data.q} placeholder={t.search} aria-label={t.search} />
			</span>
			{#if data.interest}<input type="hidden" name="interest" value={data.interest} />{/if}
			<button class="btn btn-light">{i18n.t.common.search}</button>
			<a class="btn btn-light" href="/random" data-sveltekit-preload-data="off"
				><Shuffle size={14} /> {i18n.t.site.nav.random}</a
			>
		</form>
	</header>

	{#if data.interests.length}
		<div class="interests">
			<span class="label">{t.interests}:</span>
			<a class="tag" class:active={!data.interest} href="/explore{query({ q: data.q })}">{t.all}</a>
			{#each data.interests as interest (interest.label)}
				<a
					class="tag"
					class:active={data.interest === interest.label}
					href="/explore{query({ interest: interest.label, q: data.q })}"
				>
					{interest.label} <small>{interest.count}</small>
				</a>
			{/each}
		</div>
	{/if}

	{#if data.places.items.length}
		<div class="grid">
			{#each data.places.items as place (place.id)}
				<PlaceCard {place} />
			{/each}
		</div>
	{:else}
		<div class="empty">
			<img src="/images/niki.png" alt="" width="160" height="120" />
			<p>{t.empty}</p>
			{#if filtered}<a href="/explore">{t.reset}</a>{/if}
		</div>
	{/if}

	{#if data.places.has_more}
		<p class="more">
			<a
				class="btn btn-light"
				href="/explore{query({ interest: data.interest, q: data.q, page: data.page + 1 })}"
				>{i18n.t.common.more}</a
			>
		</p>
	{/if}
</section>

<style>
	.explore {
		padding: 36px 60px 50px;
	}

	h1 {
		margin-bottom: 6px;
		font-size: 30px;
	}

	.search {
		display: flex;
		flex-wrap: wrap;
		gap: 8px;
		margin: 18px 0 10px;
	}

	.search-field {
		position: relative;
		flex: 1;
		min-width: 220px;
	}

	.search-field :global(svg) {
		position: absolute;
		top: 50%;
		left: 9px;
		color: var(--ink-soft);
		transform: translateY(-50%);
	}

	.search-field .input {
		padding-left: 30px;
	}

	.interests {
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
		align-items: center;
		margin: 6px 0 24px;
		padding: 10px 12px;
		background: #f7f7f8;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	.label {
		margin-right: 4px;
		font-size: 12px;
		color: var(--ink-soft);
	}

	.tag {
		padding: 1px 9px;
		font-size: 12px;
		color: #444;
		text-decoration: none;
		background: #fff;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
	}

	.tag:hover,
	.tag.active {
		color: #fff;
		background: var(--accent);
		border-color: var(--accent-deep);
	}

	.tag small {
		opacity: 0.6;
	}

	.grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
		gap: 12px;
	}

	.empty {
		display: grid;
		justify-items: center;
		gap: 6px;
		padding: 40px 0;
		color: var(--ink-soft);
	}

	.more {
		margin-top: 20px;
		text-align: center;
	}

	@media (max-width: 760px) {
		.explore {
			padding: 26px 16px 40px;
		}
	}
</style>
