<script lang="ts">
	import Briefcase from '@lucide/svelte/icons/briefcase';
	import MapPin from '@lucide/svelte/icons/map-pin';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import RichText from '$lib/components/ui/RichText.svelte';
	import { getI18n, pickLocalized, type Locale } from '$lib/i18n';
	import type { BlockOf, LocalizedText, Place } from '$lib/types';

	let { block, place }: { block: BlockOf<'intro'>; place: Place } = $props();
	const i18n = getI18n();

	const other = $derived<Locale>(i18n.locale === 'ru' ? 'en' : 'ru');
	const both = (text: LocalizedText | undefined) => {
		const primary = i18n.pick(text);
		const secondary = text?.[other];
		return secondary && secondary !== primary ? `${primary} / ${secondary}` : primary;
	};

	const profile = $derived(place.profile);
	const name = $derived(both(profile.name) || place.username);
	const occupation = $derived(both(profile.occupation));
	const location = $derived(both(profile.location));
	const tagline = $derived(i18n.pick(profile.tagline));
	const about = $derived(i18n.pick(profile.about));
	const statusText = $derived(pickLocalized(profile.status?.text, i18n.locale));
</script>

<div class="intro {block.style.variant}">
	<Avatar
		src={place.avatar_url}
		name={i18n.pick(profile.name) || place.username}
		size={block.style.variant === 'center' ? 128 : 108}
		accent={place.theme.colors.accent}
	/>
	<div class="text">
		<h1 class="name">{name}</h1>
		<div class="username">@{place.username}</div>
		{#if tagline}<p class="tagline">{tagline}</p>{/if}
		{#if occupation || location}
			<ul class="facts">
				{#if occupation}<li><Briefcase size={14} /> {occupation}</li>{/if}
				{#if location}<li><MapPin size={14} /> {location}</li>{/if}
			</ul>
		{/if}
		{#if profile.status?.emoji || statusText}
			<div class="status">
				{#if profile.status.emoji}<span class="emoji">{profile.status.emoji}</span>{/if}
				{statusText}
			</div>
		{/if}
		{#if about}
			<div class="about"><RichText text={about} /></div>
		{/if}
	</div>
</div>

<style>
	.intro {
		display: flex;
		gap: 22px;
		align-items: flex-start;
	}

	.intro :global(.avatar) {
		border: 3px solid var(--p-surface);
		box-shadow: 0 0 0 1px var(--p-border);
	}

	.center {
		flex-direction: column;
		align-items: center;
		text-align: center;
	}

	.text {
		min-width: 0;
	}

	.name {
		margin: 2px 0 0;
		font-size: 1.9em;
		line-height: 1.15;
	}

	.username {
		margin-top: 2px;
		color: var(--p-accent);
	}

	.tagline {
		margin: 8px 0 0;
		font-size: 1.05em;
	}

	.facts {
		display: flex;
		flex-wrap: wrap;
		gap: 4px 16px;
		margin: 8px 0 0;
		padding: 0;
		color: var(--p-muted);
		list-style: none;
	}

	.center .facts {
		justify-content: center;
	}

	.facts li {
		display: inline-flex;
		gap: 5px;
		align-items: center;
	}

	.status {
		display: inline-flex;
		gap: 6px;
		align-items: center;
		margin-top: 10px;
		padding: 2px 12px 2px 8px;
		font-size: 0.92em;
		background: color-mix(in srgb, var(--p-accent) 10%, var(--p-surface));
		border: 1px solid color-mix(in srgb, var(--p-accent) 25%, var(--p-border));
		border-radius: 999px;
	}

	.about {
		margin-top: 12px;
	}

	@container (max-width: 520px) {
		.intro {
			flex-direction: column;
			align-items: center;
			text-align: center;
		}

		.facts {
			justify-content: center;
		}
	}
</style>
