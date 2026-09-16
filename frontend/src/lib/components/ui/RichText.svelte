<script lang="ts">
	let { text }: { text: string } = $props();

	const URL_PATTERN = /(https?:\/\/[^\s<]+[^\s<.,:;!?)"'»])/g;

	const paragraphs = $derived(
		text
			.split(/\n{2,}/)
			.map((paragraph) => paragraph.split('\n').map((line) => line.split(URL_PATTERN)))
	);
</script>

{#each paragraphs as lines, p (p)}
	<p class="rich-text">
		{#each lines as parts, l (l)}
			{#if l > 0}<br />{/if}
			{#each parts as part, i (i)}
				{#if i % 2 === 1}
					<a href={part} rel="nofollow ugc noopener" target="_blank"
						>{part.replace(/^https?:\/\//, '')}</a
					>
				{:else}
					{part}
				{/if}
			{/each}
		{/each}
	</p>
{/each}

<style>
	.rich-text {
		margin: 0 0 0.7em;
		overflow-wrap: anywhere;
	}

	.rich-text:last-child {
		margin-bottom: 0;
	}
</style>
