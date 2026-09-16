<script lang="ts">
	import { getI18n } from '$lib/i18n';
	import type { BlockOf, Place } from '$lib/types';

	let { block, place }: { block: BlockOf<'photos'>; place: Place } = $props();
	const i18n = getI18n();
	const photos = $derived(
		block.data.items
			.map((item) => ({
				...item,
				image: place.uploads[item.image_id],
				caption: i18n.pick(item.caption)
			}))
			.filter((item) => item.image)
	);
</script>

<div class="photos {block.style.variant}">
	{#each photos as photo, index (photo.id)}
		<figure style="--tilt: {((index * 7) % 5) - 2}deg">
			<a href={photo.image.url} target="_blank" rel="noopener">
				<img
					src={photo.image.url}
					alt={photo.caption}
					loading="lazy"
					width={photo.image.width}
					height={photo.image.height}
				/>
			</a>
			{#if photo.caption}<figcaption>{photo.caption}</figcaption>{/if}
		</figure>
	{/each}
</div>

<style>
	.photos {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		gap: 8px;
	}

	figure {
		margin: 0;
		min-width: 0;
	}

	a {
		display: block;
	}

	img {
		display: block;
		width: 100%;
		height: auto;
		aspect-ratio: 1;
		object-fit: cover;
		border-radius: min(var(--p-radius), 6px);
	}

	figcaption {
		margin-top: 4px;
		font-size: 0.82em;
		color: var(--p-muted);
	}

	.polaroid {
		grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
		gap: 22px 18px;
		padding: 8px 4px;
	}

	.polaroid figure {
		padding: 9px 9px 0;
		background: #fff;
		box-shadow: 0 3px 10px rgba(0, 0, 0, 0.18);
		transform: rotate(var(--tilt));
		transition: transform 0.2s;
	}

	.polaroid figure:hover {
		transform: rotate(0) scale(1.03);
	}

	.polaroid img {
		border-radius: 0;
	}

	.polaroid figcaption {
		min-height: 34px;
		padding: 6px 2px 8px;
		font: 1.05em/1.2 var(--p-heading);
		color: #333;
		text-align: center;
	}

	.polaroid figure:not(:has(figcaption)) {
		padding-bottom: 30px;
	}
</style>
