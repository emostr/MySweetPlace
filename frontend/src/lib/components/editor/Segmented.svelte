<script lang="ts" generics="T extends string">
	let {
		value = $bindable(),
		options,
		label
	}: { value: T; options: { value: T; label: string }[]; label: string } = $props();
</script>

<div class="segmented" role="radiogroup" aria-label={label}>
	{#each options as option (option.value)}
		<button
			type="button"
			role="radio"
			aria-checked={value === option.value}
			class:active={value === option.value}
			onclick={() => (value = option.value)}
		>
			{option.label}
		</button>
	{/each}
</div>

<style>
	.segmented {
		display: inline-flex;
		justify-self: start;
		flex-wrap: wrap;
		overflow: hidden;
		border: 1px solid #c4c7cb;
		border-radius: 3px;
	}

	button {
		padding: 5px 11px;
		font-size: 12px;
		background: linear-gradient(#fdfdfd, #eceef0);
		border: 0;
		border-right: 1px solid #c4c7cb;
		cursor: pointer;
	}

	button:last-child {
		border-right: 0;
	}

	button.active {
		color: #fff;
		background: linear-gradient(#8e2e3b, #6d2230);
		box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.25);
	}
</style>
