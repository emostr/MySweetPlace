<script lang="ts">
	import Shuffle from '@lucide/svelte/icons/shuffle';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import PlaceCard from '$lib/components/ui/PlaceCard.svelte';
	import NoteBody from '$lib/components/notes/NoteBody.svelte';
	import { getI18n } from '$lib/i18n';
	import { formatShortDate } from '$lib/dates';

	let { data } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.landing);
</script>

<svelte:head>
	<title>MySweetPlace — {i18n.t.site.footer.rights.toLowerCase()}</title>
	<meta name="description" content={t.lead} />
	<meta property="og:title" content="MySweetPlace" />
	<meta property="og:description" content={t.lead} />
</svelte:head>

<section class="hero">
	<div class="hero-text">
		<h1>{t.title}</h1>
		<p class="lead">{t.lead}</p>
		<div class="row">
			{#if data.me.place}
				<a class="btn btn-lg" href="/@{data.me.place.username}">{t.ctaMine}</a>
			{:else}
				<a class="btn btn-lg" href="/signup">{t.cta}</a>
			{/if}
			<a class="btn btn-light btn-lg" href="/random" data-sveltekit-preload-data="off">
				<Shuffle size={16} />
				{i18n.t.site.takeMeSomewhere}
			</a>
		</div>
		{#if data.home.stats.places > 0}
			<p class="stats">{t.stats(data.home.stats.places, data.home.stats.notes)}</p>
		{/if}
	</div>

	<div class="mock" aria-hidden="true">
		<div class="mock-bar">
			<span></span><span></span><span></span><em>mysweetplace.org/@niki</em>
		</div>
		<div class="mock-page">
			<div class="mock-card intro">
				<img src="/images/niki.png" alt="" width="64" height="48" />
				<div>
					<strong>Ники</strong>
					<small>@niki · {i18n.locale === 'ru' ? 'слушаю музыку' : 'listening to music'}</small>
				</div>
			</div>
			<div class="mock-grid">
				<div class="mock-card"><b>{i18n.t.blocks.titles.now}</b><i></i><i class="short"></i></div>
				<div class="mock-card"><b>{i18n.t.blocks.titles.links}</b><i></i><i class="short"></i></div>
			</div>
			<div class="mock-card note">
				<b>{i18n.t.blocks.titles.guestbook}</b>
				<p>{i18n.locale === 'ru' ? 'уютно тут :)' : 'so cozy here :)'}</p>
			</div>
		</div>
	</div>
</section>

<section class="columns">
	{#each t.features as feature (feature.title)}
		<div class="col">
			<h3>{feature.title}</h3>
			<p>{feature.text}</p>
		</div>
	{/each}
</section>

<section class="feed">
	<div class="feed-col">
		<h2 class="section-title">{t.newPlaces}</h2>
		{#if data.home.places.length}
			<div class="places">
				{#each data.home.places as place (place.id)}
					<PlaceCard {place} />
				{/each}
			</div>
			<p><a href="/explore">{i18n.t.site.nav.explore} →</a></p>
		{:else}
			<p class="muted">{t.quiet}</p>
		{/if}
	</div>

	<div class="feed-col">
		<h2 class="section-title">{t.freshNotes}</h2>
		{#if data.home.notes.length}
			<ul class="notes">
				{#each data.home.notes as note (note.id)}
					{@const place = note.place!}
					<li>
						<a class="author" href="/@{place.username}">
							<Avatar
								src={place.avatar_url}
								name={i18n.pick(place.name) || place.username}
								size={28}
								accent={place.accent}
							/>
							<span>{i18n.pick(place.name) || place.username}</span>
						</a>
						<NoteBody {note} compact />
						<a class="date" href="/@{place.username}/notes/{note.id}">
							{formatShortDate(note.created_at, i18n.locale, i18n.timeZone)}
						</a>
					</li>
				{/each}
			</ul>
		{:else}
			<p class="muted">{t.quiet}</p>
		{/if}
	</div>
</section>

<style>
	.hero {
		display: grid;
		grid-template-columns: 1fr 340px;
		gap: 40px;
		align-items: center;
		padding: 64px 60px;
		background: linear-gradient(#f7f7f8, #ebecee);
		border-bottom: 1px solid #d6d8db;
	}

	h1 {
		max-width: 620px;
		margin-bottom: 18px;
		font-size: 32px;
		color: #222;
	}

	.lead {
		max-width: 540px;
		margin-bottom: 26px;
		font-size: 15px;
		color: #666;
	}

	.stats {
		margin: 18px 0 0;
		font-size: 12px;
		color: var(--ink-soft);
	}

	.mock {
		overflow: hidden;
		background: #fff;
		border: 1px solid #cfd2d6;
		border-radius: 6px;
		box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
		transform: rotate(1.5deg);
	}

	.mock-bar {
		display: flex;
		gap: 5px;
		align-items: center;
		padding: 7px 10px;
		background: linear-gradient(#f3f4f5, #e2e4e7);
		border-bottom: 1px solid #d3d6d9;
	}

	.mock-bar span {
		width: 8px;
		height: 8px;
		background: #c9ccd0;
		border-radius: 50%;
	}

	.mock-bar em {
		margin-left: 8px;
		font: normal 11px var(--sans);
		color: #6b6f76;
	}

	.mock-page {
		display: grid;
		gap: 8px;
		padding: 12px;
		background: #fbe7ee
			url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Cpath d='M18 25s-7-4.4-7-9.2a3.8 3.8 0 0 1 7-1.8 3.8 3.8 0 0 1 7 1.8c0 4.8-7 9.2-7 9.2z' fill='%23d2557f' opacity='.13'/%3E%3C/svg%3E");
	}

	.mock-card {
		display: grid;
		gap: 5px;
		padding: 9px 10px;
		background: #fffafb;
		border: 1px solid #f2cbd7;
		border-radius: 10px;
	}

	.mock-card b {
		font:
			normal 12px 'Georgia',
			serif;
		color: #4a2f38;
	}

	.mock-card i {
		display: block;
		height: 6px;
		background: #f2d9e1;
		border-radius: 3px;
	}

	.mock-card i.short {
		width: 60%;
	}

	.intro {
		grid-template-columns: auto 1fr;
		align-items: center;
	}

	.intro img {
		width: 64px;
		height: 48px;
	}

	.intro strong {
		display: block;
		font:
			normal 16px Georgia,
			serif;
		color: #4a2f38;
	}

	.intro small {
		font-size: 11px;
		color: #9a7482;
	}

	.mock-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.note p {
		margin: 0;
		font:
			italic 13px Georgia,
			serif;
		color: #d2557f;
	}

	.columns {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 5%;
		padding: 40px 60px 10px;
	}

	.col h3 {
		margin-bottom: 10px;
		padding-bottom: 6px;
		font-size: 17px;
		border-bottom: 1px solid var(--line);
	}

	.col p {
		color: #555;
	}

	.feed {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 40px;
		padding: 30px 60px 50px;
	}

	.places {
		display: grid;
		gap: 10px;
		margin-bottom: 12px;
	}

	.notes {
		display: grid;
		gap: 12px;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.notes li {
		padding: 12px 14px;
		background: #fafafb;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	.author {
		display: flex;
		gap: 8px;
		align-items: center;
		margin-bottom: 6px;
		font: normal 14px var(--serif);
		color: var(--ink-strong);
		text-decoration: none;
	}

	.date {
		display: inline-block;
		margin-top: 8px;
		font-size: 11px;
		color: var(--ink-soft);
		text-decoration: none;
	}

	@media (max-width: 860px) {
		.hero {
			grid-template-columns: 1fr;
			padding: 40px 16px;
		}

		.mock {
			max-width: 340px;
		}

		h1 {
			font-size: 25px;
		}

		.columns,
		.feed {
			grid-template-columns: 1fr;
			gap: 20px;
			padding-left: 16px;
			padding-right: 16px;
		}
	}
</style>
