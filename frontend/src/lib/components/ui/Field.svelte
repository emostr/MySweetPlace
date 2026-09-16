<script lang="ts">
	import type { Snippet } from 'svelte';

	let {
		label,
		hint,
		error,
		children
	}: { label: string; hint?: string; error?: string; children: Snippet } = $props();
</script>

<label class="field">
	<span class="field-label">{label}</span>
	{@render children()}
	{#if error}
		<span class="field-error">{error}</span>
	{:else if hint}
		<span class="hint">{hint}</span>
	{/if}
</label>
