<script lang="ts">
	import { untrack } from 'svelte';
	import { goto, invalidate } from '$app/navigation';
	import Field from '$lib/components/ui/Field.svelte';
	import { api } from '$lib/api';
	import { getEditor } from '$lib/editor/state.svelte';
	import { errorMessage, fieldErrors } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import type { Me, Place } from '$lib/types';

	let { data } = $props();
	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.settings);

	let visibilityError = $state('');

	async function setVisibility(changes: { listed?: boolean; settings?: Place['settings'] }) {
		visibilityError = '';
		try {
			await editor.mutate(api.patch<{ place: Place }>('/api/my/place', changes));
		} catch (e) {
			visibilityError = errorMessage(e, i18n);
		}
	}

	let email = $state(untrack(() => data.me.user?.email_address ?? ''));
	let emailPassword = $state('');
	let emailState = $state<{ ok?: string; error?: string; fields?: Record<string, string> }>({});

	async function changeEmail(event: SubmitEvent) {
		event.preventDefault();
		emailState = {};
		try {
			await api.patch<Me>('/api/me', { email_address: email, current_password: emailPassword });
			emailPassword = '';
			emailState = { ok: i18n.t.common.saved };
			await invalidate('app:me');
		} catch (e) {
			emailState = { error: errorMessage(e, i18n), fields: fieldErrors(e) };
		}
	}

	let newPassword = $state('');
	let currentPassword = $state('');
	let passwordState = $state<{ ok?: string; error?: string; fields?: Record<string, string> }>({});

	async function changePassword(event: SubmitEvent) {
		event.preventDefault();
		passwordState = {};
		try {
			await api.patch<Me>('/api/me', { password: newPassword, current_password: currentPassword });
			newPassword = '';
			currentPassword = '';
			passwordState = { ok: t.passwordChanged };
		} catch (e) {
			passwordState = { error: errorMessage(e, i18n), fields: fieldErrors(e) };
		}
	}

	let deletePassword = $state('');
	let deleteError = $state('');

	async function deleteAccount(event: SubmitEvent) {
		event.preventDefault();
		if (!confirm(i18n.t.common.confirmDelete)) return;
		deleteError = '';
		try {
			await api.delete('/api/me', { password: deletePassword });
			await invalidate('app:me');
			await goto('/');
		} catch (e) {
			deleteError = errorMessage(e, i18n);
		}
	}

	async function logout() {
		await api.delete('/api/session');
		await invalidate('app:me');
		await goto('/');
	}
</script>

<h1>{i18n.t.editor.tabs.settings}</h1>

<section class="panel">
	<h2 class="section-title">{t.visibility}</h2>
	<label class="check">
		<input
			type="checkbox"
			checked={editor.place.listed}
			onchange={(e) => setVisibility({ listed: e.currentTarget.checked })}
		/>
		<span>{t.listed}</span>
	</label>
	<label class="check">
		<input
			type="checkbox"
			checked={editor.place.settings.noindex}
			onchange={(e) =>
				setVisibility({ settings: { ...editor.place.settings, noindex: e.currentTarget.checked } })}
		/>
		<span>{t.noindex}</span>
	</label>
	{#if visibilityError}<p class="notice notice-error">{visibilityError}</p>{/if}
</section>

<section class="panel">
	<h2 class="section-title">{t.account}</h2>
	<div class="forms">
		<form onsubmit={changeEmail}>
			<Field label={t.email} error={emailState.fields?.email_address}>
				<input class="input" type="email" bind:value={email} required autocomplete="email" />
			</Field>
			<Field label={t.currentPassword} error={emailState.fields?.current_password}>
				<input
					class="input"
					type="password"
					bind:value={emailPassword}
					required
					autocomplete="current-password"
				/>
			</Field>
			{#if emailState.ok}<p class="notice notice-ok">{emailState.ok}</p>{/if}
			<button class="btn btn-light">{t.changeEmail}</button>
		</form>

		<form onsubmit={changePassword}>
			<Field
				label={t.newPassword}
				hint={i18n.t.auth.passwordHint}
				error={passwordState.fields?.password}
			>
				<input
					class="input"
					type="password"
					bind:value={newPassword}
					required
					minlength="8"
					autocomplete="new-password"
				/>
			</Field>
			<Field label={t.currentPassword} error={passwordState.fields?.current_password}>
				<input
					class="input"
					type="password"
					bind:value={currentPassword}
					required
					autocomplete="current-password"
				/>
			</Field>
			{#if passwordState.ok}<p class="notice notice-ok">{passwordState.ok}</p>{/if}
			<button class="btn btn-light">{t.changePassword}</button>
		</form>
	</div>
	<p class="logout"><button class="btn btn-light" onclick={logout}>{t.logout}</button></p>
</section>

<section class="panel danger">
	<h2 class="section-title">{t.danger}</h2>
	<p class="muted">{t.deleteText}</p>
	<form class="row" onsubmit={deleteAccount}>
		<input
			class="input password"
			type="password"
			bind:value={deletePassword}
			placeholder={i18n.t.auth.password}
			required
			autocomplete="current-password"
		/>
		<button class="btn btn-danger">{t.deleteAccount}</button>
	</form>
	{#if deleteError}<p class="notice notice-error">{deleteError}</p>{/if}
</section>

<style>
	h1 {
		margin-bottom: 16px;
		font-size: 26px;
	}

	.panel {
		margin-bottom: 16px;
	}

	.forms {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 24px;
	}

	.logout {
		margin: 18px 0 0;
		padding-top: 14px;
		border-top: 1px solid var(--line);
	}

	.danger {
		border-color: #efcdcb;
	}

	.danger .section-title {
		color: var(--danger);
	}

	.password {
		max-width: 240px;
	}

	.notice {
		margin: 8px 0;
	}

	@media (max-width: 900px) {
		.forms {
			grid-template-columns: 1fr;
		}
	}
</style>
