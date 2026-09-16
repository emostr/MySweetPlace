<script lang="ts">
	import type { Snippet } from 'svelte';

	let {
		title,
		lead,
		children,
		footer
	}: { title: string; lead?: string; children: Snippet; footer?: Snippet } = $props();
</script>

<section class="auth">
	<div class="panel">
		<h1>{title}</h1>
		{#if lead}<p class="lead">{lead}</p>{/if}
		{@render children()}
	</div>
	{#if footer}<div class="after">{@render footer()}</div>{/if}
</section>

<style>
	.auth {
		display: grid;
		justify-items: center;
		gap: 14px;
		padding: 56px 16px 64px;
		background: linear-gradient(#f7f7f8, #ebecee);
		min-height: 100%;
	}

	.panel {
		width: 100%;
		max-width: 380px;
		padding: 26px 28px 12px;
		box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
	}

	h1 {
		margin-bottom: 4px;
		font-size: 26px;
	}

	.lead {
		margin-bottom: 18px;
		color: var(--ink-soft);
	}

	.after {
		font-size: 13px;
		color: var(--ink-soft);
	}
</style>
