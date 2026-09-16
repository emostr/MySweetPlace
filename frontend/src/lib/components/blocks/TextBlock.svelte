<script lang="ts">
	import RichText from '$lib/components/ui/RichText.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockOf } from '$lib/types';

	let { block }: { block: BlockOf<'text'> } = $props();
	const i18n = getI18n();
</script>

<div class="text"><RichText text={i18n.pick(block.data.body)} /></div>
