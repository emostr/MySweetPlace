<script lang="ts">
	import ColorField from '$lib/components/editor/ColorField.svelte';
	import ImagePicker from '$lib/components/editor/ImagePicker.svelte';
	import Segmented from '$lib/components/editor/Segmented.svelte';
	import { api } from '$lib/api';
	import { clone, getEditor } from '$lib/editor/state.svelte';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import { FONT_GROUPS, FONTS, getFont } from '$lib/theme/fonts';
	import { patternImage } from '$lib/theme/patterns';
	import { applyPreset, PRESETS } from '$lib/theme/presets';
	import {
		CARD_STYLES,
		PATTERNS,
		THEME_PRESETS,
		type Place,
		type Theme,
		type ThemeColors
	} from '$lib/types';

	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.appearance);

	if (!editor.theme) editor.theme = clone(editor.place.theme);
	const theme = $derived(editor.theme ?? editor.place.theme);

	let busy = $state(false);
	let error = $state('');
	let saved = $state(false);
	const dirty = $derived(JSON.stringify(theme) !== JSON.stringify(editor.place.theme));
	const colorKeys: (keyof ThemeColors)[] = [
		'background',
		'surface',
		'text',
		'muted',
		'accent',
		'border'
	];
	const sample = $derived(
		i18n.locale === 'ru'
			? 'Съешь же ещё этих мягких французских булок'
			: 'The quick brown fox jumps over the lazy dog'
	);

	function preset(name: Theme['preset']) {
		editor.theme = applyPreset(theme, name);
	}

	async function save() {
		busy = true;
		error = '';
		try {
			const place = await editor.mutate(api.patch<{ place: Place }>('/api/my/place', { theme }));
			editor.theme = clone(place.theme);
			saved = true;
			setTimeout(() => (saved = false), 2000);
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<h1>{i18n.t.editor.tabs.appearance}</h1>

<section>
	<h2 class="section-title">{t.presets}</h2>
	<div class="presets">
		{#each THEME_PRESETS as name (name)}
			{@const look = PRESETS[name]}
			<button
				class="preset"
				class:active={theme.preset === name}
				onclick={() => preset(name)}
				style="--bg: {look.colors.background}; --surface: {look.colors.surface}; --accent: {look
					.colors.accent}; --text: {look.colors.text}; --border: {look.colors
					.border}; background-image: {patternImage(look.background.pattern, look.colors.text) ??
					'none'}"
			>
				<span
					class="mini"
					style="border-radius: {Math.min(look.cards.radius, 8)}px; font-family: {getFont(
						look.heading_font
					).stack}"
				>
					<b>Aa</b>
					<i></i>
				</span>
				<span class="preset-name">{t.presetNames[name]}</span>
			</button>
		{/each}
	</div>
</section>

<section>
	<h2 class="section-title">{t.colors}</h2>
	<div class="colors">
		{#each colorKeys as key (key)}
			<ColorField bind:value={theme.colors[key]} label={t.colorNames[key]} />
		{/each}
	</div>
</section>

<section>
	<h2 class="section-title">{t.fonts}</h2>
	<div class="fonts">
		{#each [{ key: 'font', label: t.font }, { key: 'heading_font', label: t.headingFont }] as const as field (field.key)}
			<label class="field">
				<span class="field-label">{field.label}</span>
				<select class="input" bind:value={theme[field.key]}>
					{#each FONT_GROUPS as group (group)}
						<optgroup label={t.fontGroups[group]}>
							{#each FONTS.filter((font) => font.group === group) as font (font.id)}
								<option value={font.id}>{font.name}</option>
							{/each}
						</optgroup>
					{/each}
				</select>
				<span class="sample" style="font-family: {getFont(theme[field.key]).stack}">{sample}</span>
			</label>
		{/each}
	</div>
	<div class="field">
		<span class="field-label">{t.fontSize}</span>
		<Segmented
			bind:value={theme.font_size}
			label={t.fontSize}
			options={(['small', 'normal', 'large'] as const).map((value) => ({
				value,
				label: t.fontSizes[value]
			}))}
		/>
	</div>
</section>

<section>
	<h2 class="section-title">{t.background}</h2>
	<div class="field">
		<Segmented
			bind:value={theme.background.type}
			label={t.background}
			options={(['color', 'gradient', 'pattern', 'image'] as const).map((value) => ({
				value,
				label: t.backgroundTypes[value]
			}))}
		/>
	</div>
	{#if theme.background.type === 'gradient'}
		<div class="colors">
			<ColorField bind:value={theme.background.color2} label={t.color2} />
			<label class="field">
				<span class="field-label">{t.angle}: {theme.background.angle}°</span>
				<input type="range" min="0" max="360" step="5" bind:value={theme.background.angle} />
			</label>
		</div>
	{:else if theme.background.type === 'pattern'}
		<div class="patterns">
			{#each PATTERNS.filter((pattern) => pattern !== 'none') as pattern (pattern)}
				<button
					class="pattern"
					class:active={theme.background.pattern === pattern}
					title={t.patternNames[pattern]}
					onclick={() => (theme.background.pattern = pattern)}
					style="background: {patternImage(pattern, theme.colors.text)} {theme.colors.background}"
				>
					<span>{t.patternNames[pattern]}</span>
				</button>
			{/each}
		</div>
	{:else if theme.background.type === 'image'}
		<ImagePicker bind:value={theme.background.image_id} purpose="background" label={t.image} />
		<Segmented
			bind:value={theme.background.image_mode}
			label={t.image}
			options={(['cover', 'tile', 'fixed'] as const).map((value) => ({
				value,
				label: t.imageModes[value]
			}))}
		/>
	{/if}
</section>

<section>
	<h2 class="section-title">{t.cards}</h2>
	<div class="field">
		<Segmented
			bind:value={theme.cards.style}
			label={t.cards}
			options={CARD_STYLES.map((value) => ({ value, label: t.cardStyles[value] }))}
		/>
	</div>
	<label class="field radius">
		<span class="field-label">{t.radius}: {theme.cards.radius}px</span>
		<input type="range" min="0" max="28" bind:value={theme.cards.radius} />
	</label>
	<div class="field">
		<span class="field-label">{t.layout}</span>
		<Segmented
			bind:value={theme.layout.width}
			label={t.layout}
			options={(['narrow', 'normal', 'wide'] as const).map((value) => ({
				value,
				label: t.widths[value]
			}))}
		/>
	</div>
	<p class="hint">{t.customCss}</p>
</section>

{#if error}<p class="notice notice-error">{error}</p>{/if}

<div class="actions">
	{#if saved}<span class="saved">✓ {i18n.t.common.saved}</span>{/if}
	<button
		class="btn btn-light"
		onclick={() => (editor.theme = clone(editor.place.theme))}
		disabled={!dirty || busy}>{i18n.t.common.cancel}</button
	>
	<button class="btn" onclick={save} disabled={!dirty || busy}
		>{busy ? i18n.t.common.saving : i18n.t.common.save}</button
	>
</div>

<style>
	h1 {
		margin-bottom: 16px;
		font-size: 26px;
	}

	section {
		margin-bottom: 26px;
	}

	.presets {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
		gap: 10px;
	}

	.preset {
		display: grid;
		gap: 6px;
		justify-items: center;
		padding: 12px 8px 8px;
		background-color: var(--bg);
		border: 2px solid transparent;
		border-radius: 6px;
		box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.12);
		cursor: pointer;
	}

	.preset.active {
		border-color: #7a2531;
		box-shadow: 0 0 0 3px rgba(122, 37, 49, 0.2);
	}

	.mini {
		display: grid;
		gap: 4px;
		width: 64px;
		padding: 6px 8px;
		text-align: left;
		background: var(--surface);
		border: 1px solid var(--border);
	}

	.mini b {
		font-size: 16px;
		font-weight: normal;
		line-height: 1;
		color: var(--text);
	}

	.mini i {
		display: block;
		height: 5px;
		background: var(--accent);
		border-radius: 3px;
	}

	.preset-name {
		padding: 0 6px;
		font-size: 11px;
		color: var(--text);
		background: var(--surface);
		border-radius: 3px;
	}

	.colors {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
		gap: 8px;
	}

	.fonts {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0 14px;
	}

	.sample {
		overflow: hidden;
		font-size: 16px;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.patterns {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(90px, 1fr));
		gap: 8px;
	}

	.pattern {
		display: grid;
		align-items: end;
		height: 64px;
		padding: 0;
		overflow: hidden;
		border: 2px solid transparent;
		border-radius: 4px;
		box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.12);
		cursor: pointer;
	}

	.pattern span {
		padding: 1px 4px;
		font-size: 11px;
		background: rgba(255, 255, 255, 0.85);
	}

	.pattern.active {
		border-color: #7a2531;
	}

	.radius input,
	input[type='range'] {
		width: 100%;
		max-width: 320px;
		accent-color: var(--accent);
	}

	.actions {
		position: sticky;
		bottom: -60px;
		display: flex;
		gap: 8px;
		align-items: center;
		justify-content: flex-end;
		margin: 10px -26px -60px;
		padding: 12px 26px;
		background: rgba(255, 255, 255, 0.95);
		border-top: 1px solid var(--line);
	}

	.saved {
		margin-right: auto;
		color: var(--ok);
	}

	@media (max-width: 720px) {
		.fonts {
			grid-template-columns: 1fr;
		}
	}
</style>
