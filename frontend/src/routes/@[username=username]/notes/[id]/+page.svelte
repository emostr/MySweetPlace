<script lang="ts">
	import ArrowLeft from '@lucide/svelte/icons/arrow-left';
	import { goto, invalidate } from '$app/navigation';
	import { page } from '$app/state';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import PlaceShell from '$lib/components/place/PlaceShell.svelte';
	import NoteCard from '$lib/components/notes/NoteCard.svelte';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const place = $derived(data.place);
	const name = $derived(i18n.pick(place.profile.name) || place.username);
	const excerpt = $derived(data.note.body.replace(/\s+/g, ' ').slice(0, 180));
	const image = $derived(data.note.images[0]?.url ?? place.avatar_url);

	async function refresh() {
		try {
			await invalidate('app:place');
		} catch {
			await goto(`/@${place.username}`);
		}
	}
</script>

<svelte:head>
	<title>{i18n.t.notes.title(place.username)}{excerpt ? `: ${excerpt.slice(0, 60)}` : ''}</title>
	<meta name="description" content={excerpt} />
	<meta property="og:type" content="article" />
	<meta property="og:title" content="{name} (@{place.username})" />
	<meta property="og:description" content={excerpt} />
	{#if image}<meta property="og:image" content={new URL(image, page.url.origin).href} />{/if}
	{#if place.settings.noindex}<meta name="robots" content="noindex" />{/if}
</svelte:head>

<PlaceShell {place} me={data.me} motto={data.motto} season={data.season} {refresh}>
	<article class="block single">
		<a class="back" href="/@{place.username}"><ArrowLeft size={14} /> {i18n.t.notes.back}</a>
		<a class="author" href="/@{place.username}">
			<Avatar src={place.avatar_url} {name} size={44} accent={place.theme.colors.accent} />
			<span>
				<strong>{name}</strong>
				<span class="muted">@{place.username}</span>
			</span>
		</a>
		<NoteCard note={data.note} username={place.username} owner={place.owner} onchange={refresh} />
	</article>
</PlaceShell>

<style>
	.single {
		display: grid;
		gap: 12px;
		max-width: 720px;
		margin: 0 auto;
		font-size: 1.05em;
	}

	.back {
		display: inline-flex;
		gap: 4px;
		align-items: center;
		justify-self: start;
		font-size: 0.8em;
	}

	.author {
		display: flex;
		gap: 12px;
		align-items: center;
		text-decoration: none;
	}

	.author strong {
		display: block;
		font: normal 1.2em var(--p-heading);
		color: var(--p-text);
	}
</style>
