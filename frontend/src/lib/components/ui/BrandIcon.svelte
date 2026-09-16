<script lang="ts">
	import { brandIcon } from '$lib/links';

	let { slug }: { slug: string } = $props();
</script>

<span class="brand-icon" style="--icon: url({brandIcon(slug)})" aria-hidden="true"></span>
