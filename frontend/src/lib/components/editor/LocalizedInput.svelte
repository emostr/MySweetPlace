<script lang="ts">
	import { getI18n } from '$lib/i18n';
	import type { LocalizedText } from '$lib/types';

	let {
		value = $bindable(),
		label,
		multiline = false,
		maxlength,
		rows = 3,
		placeholder = '',
		error
	}: {
		value: LocalizedText;
		label?: string;
		multiline?: boolean;
		maxlength?: number;
		rows?: number;
		placeholder?: string;
		error?: string;
	} = $props();

	const i18n = getI18n();
	let english = $state(false);
	const showEnglish = $derived(english || !!value.en);

	function set(locale: 'ru' | 'en', text: string) {
		value = { ...value, [locale]: text };
	}
</script>

<div class="localized field">
	{#if label}<span class="field-label">{label}</span>{/if}
	<div class="pair">
		<span class="lang">RU</span>
		{#if multiline}
			<textarea
				class="input"
				{rows}
				{maxlength}
				{placeholder}
				value={value.ru ?? ''}
				oninput={(e) => set('ru', e.currentTarget.value)}
				aria-label={label ? `${label} (RU)` : undefined}
				aria-invalid={!!error}></textarea>
		{:else}
			<input
				class="input"
				{maxlength}
				{placeholder}
				value={value.ru ?? ''}
				oninput={(e) => set('ru', e.currentTarget.value)}
				aria-label={label ? `${label} (RU)` : undefined}
				aria-invalid={!!error}
			/>
		{/if}
	</div>
	{#if showEnglish}
		<div class="pair">
			<span class="lang">EN</span>
			{#if multiline}
				<textarea
					class="input"
					{rows}
					{maxlength}
					value={value.en ?? ''}
					oninput={(e) => set('en', e.currentTarget.value)}
					aria-label={label ? `${label} (EN)` : undefined}></textarea>
			{:else}
				<input
					class="input"
					{maxlength}
					value={value.en ?? ''}
					oninput={(e) => set('en', e.currentTarget.value)}
					aria-label={label ? `${label} (EN)` : undefined}
				/>
			{/if}
		</div>
	{:else}
		<button type="button" class="add-en" onclick={() => (english = true)}
			>+ {i18n.t.editor.localized.addEnglish}</button
		>
	{/if}
	{#if error}<span class="field-error">{error}</span>{/if}
</div>

<style>
	.localized {
		gap: 5px;
	}

	.pair {
		display: flex;
		gap: 6px;
		align-items: flex-start;
	}

	.lang {
		flex: none;
		width: 26px;
		margin-top: 8px;
		font: bold 10px var(--sans);
		letter-spacing: 1px;
		color: var(--ink-soft);
	}

	.add-en {
		justify-self: start;
		margin-left: 32px;
		padding: 0;
		font-size: 12px;
		color: var(--accent);
		background: none;
		border: 0;
		cursor: pointer;
	}

	.add-en:hover {
		text-decoration: underline;
	}
</style>
