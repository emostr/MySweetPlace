<script lang="ts">
	import type { Embed } from '$lib/embeds';

	let { embed }: { embed: Embed } = $props();
</script>

<iframe
	class="embed"
	src={embed.src}
	title={embed.provider}
	loading="lazy"
	allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
	referrerpolicy="strict-origin-when-cross-origin"
	sandbox="allow-scripts allow-same-origin allow-popups allow-presentation"
	style={embed.ratio ? `aspect-ratio: ${embed.ratio}` : `height: ${embed.height}px`}
></iframe>

<style>
	.embed {
		display: block;
		width: 100%;
		margin: 10px 0 0;
		background: rgba(0, 0, 0, 0.05);
		border: 0;
		border-radius: 8px;
	}
</style>
