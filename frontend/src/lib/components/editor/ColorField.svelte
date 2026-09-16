<script lang="ts">
	let { value = $bindable(), label }: { value: string; label: string } = $props();

	function typed(event: Event) {
		const text = (event.currentTarget as HTMLInputElement).value.trim();
		if (/^#[0-9a-f]{6}$/i.test(text)) value = text.toLowerCase();
	}
</script>

<label class="color-field">
	<input type="color" bind:value aria-label={label} />
	<span class="info">
		<span class="name">{label}</span>
		<input
			class="hex"
			{value}
			onchange={typed}
			maxlength="7"
			spellcheck="false"
			aria-label="{label} HEX"
		/>
	</span>
</label>

<style>
	.color-field {
		display: flex;
		gap: 8px;
		align-items: center;
		padding: 6px 8px;
		background: #fafafb;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	input[type='color'] {
		flex: none;
		width: 34px;
		height: 34px;
		padding: 0;
		background: none;
		border: 1px solid var(--line-strong);
		border-radius: 3px;
		cursor: pointer;
	}

	.info {
		display: grid;
		min-width: 0;
		line-height: 1.3;
	}

	.name {
		overflow: hidden;
		font-size: 12px;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.hex {
		width: 76px;
		padding: 0;
		font: 12px var(--mono);
		color: var(--ink-soft);
		background: none;
		border: 0;
	}
</style>
