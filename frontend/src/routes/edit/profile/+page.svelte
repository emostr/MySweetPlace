<script lang="ts">
	import Upload from '@lucide/svelte/icons/upload';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import LocalizedInput from '$lib/components/editor/LocalizedInput.svelte';
	import { api } from '$lib/api';
	import { clone, getEditor } from '$lib/editor/state.svelte';
	import { errorMessage, fieldErrors } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import { imageForm, MAX_SIZES } from '$lib/images';
	import type { Place, Profile } from '$lib/types';

	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.profile);

	const blank: Profile = {
		name: {},
		tagline: {},
		occupation: {},
		location: {},
		status: { emoji: '', text: {} },
		about: {}
	};
	if (!editor.profile) editor.profile = { ...blank, ...clone(editor.place.profile) };
	const profile = $derived(editor.profile ?? blank);

	let username = $state(editor.place.username);
	let busy = $state(false);
	let avatarBusy = $state(false);
	let error = $state('');
	let fields = $state<Record<string, string>>({});
	let saved = $state(false);

	const dirty = $derived(
		username !== editor.place.username ||
			JSON.stringify(profile) !== JSON.stringify({ ...blank, ...editor.place.profile })
	);

	async function save() {
		busy = true;
		error = '';
		fields = {};
		try {
			const place = await editor.mutate(
				api.patch<{ place: Place }>('/api/my/place', { profile, username })
			);
			editor.profile = { ...blank, ...clone(place.profile) };
			username = place.username;
			saved = true;
			setTimeout(() => (saved = false), 2000);
		} catch (e) {
			fields = fieldErrors(e);
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}

	function reset() {
		editor.profile = { ...blank, ...clone(editor.place.profile) };
		username = editor.place.username;
	}

	async function uploadAvatar(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const file = input.files?.[0];
		input.value = '';
		if (!file) return;
		avatarBusy = true;
		error = '';
		try {
			await editor.mutate(
				api.put<{ place: Place }>('/api/my/place/avatar', await imageForm(file, MAX_SIZES.avatar))
			);
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			avatarBusy = false;
		}
	}

	async function removeAvatar() {
		await editor.mutate(api.delete<{ place: Place }>('/api/my/place/avatar'));
	}
</script>

<h1>{i18n.t.editor.tabs.profile}</h1>

<section class="avatar-row">
	<Avatar
		src={editor.place.avatar_url}
		name={i18n.pick(profile.name) || editor.place.username}
		size={84}
		accent={editor.preview.theme.colors.accent}
	/>
	<div class="avatar-actions">
		<span class="field-label">{t.avatar}</span>
		<div class="row">
			<label class="btn btn-light btn-sm">
				<Upload size={14} />
				{avatarBusy ? i18n.t.common.uploading : t.uploadAvatar}
				<input
					type="file"
					accept="image/*"
					class="visually-hidden"
					onchange={uploadAvatar}
					disabled={avatarBusy}
				/>
			</label>
			{#if editor.place.avatar_url}
				<button class="btn btn-ghost btn-sm" onclick={removeAvatar}>{t.removeAvatar}</button>
			{/if}
		</div>
	</div>
</section>

<label class="field">
	<span class="field-label">{t.username}</span>
	<span class="prefixed">
		<span>@</span>
		<input class="input" bind:value={username} maxlength="30" aria-invalid={!!fields.username} />
	</span>
	{#if fields.username}<span class="field-error">{fields.username}</span>{:else}<span class="hint"
			>{t.usernameHint}</span
		>{/if}
</label>

<LocalizedInput
	bind:value={profile.name}
	label={t.name}
	maxlength={60}
	error={fields['profile.name.ru'] ?? fields['profile.name.en']}
/>
<LocalizedInput bind:value={profile.tagline} label={t.tagline} maxlength={140} />
<div class="grid2">
	<LocalizedInput bind:value={profile.occupation} label={t.occupation} maxlength={80} />
	<LocalizedInput bind:value={profile.location} label={t.location} maxlength={80} />
</div>
<div class="status">
	<label class="field emoji">
		<span class="field-label">{t.statusEmoji}</span>
		<input class="input" bind:value={profile.status.emoji} maxlength="16" placeholder="🎧" />
	</label>
	<LocalizedInput bind:value={profile.status.text} label={t.statusText} maxlength={80} />
</div>
<LocalizedInput bind:value={profile.about} label={t.about} multiline rows={5} maxlength={1000} />

{#if error}<p class="notice notice-error">{error}</p>{/if}

<div class="actions">
	{#if saved}<span class="saved">✓ {i18n.t.common.saved}</span>{/if}
	<button class="btn btn-light" onclick={reset} disabled={!dirty || busy}
		>{i18n.t.common.cancel}</button
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

	.avatar-row {
		display: flex;
		gap: 16px;
		align-items: center;
		margin-bottom: 18px;
	}

	.avatar-actions label {
		position: relative;
	}

	.prefixed {
		display: flex;
	}

	.prefixed span {
		display: grid;
		place-items: center;
		padding: 0 9px;
		color: var(--ink-soft);
		background: #f1f2f3;
		border: 1px solid #c3c6ca;
		border-right: 0;
		border-radius: 3px 0 0 3px;
	}

	.prefixed .input {
		border-radius: 0 3px 3px 0;
	}

	.grid2 {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0 14px;
	}

	.status {
		display: grid;
		grid-template-columns: 80px 1fr;
		gap: 0 10px;
	}

	.emoji .input {
		text-align: center;
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
		.grid2 {
			grid-template-columns: 1fr;
		}
	}
</style>
