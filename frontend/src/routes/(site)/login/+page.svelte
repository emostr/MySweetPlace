<script lang="ts">
	import { goto, invalidate } from '$app/navigation';
	import { page } from '$app/state';
	import AuthPanel from '$lib/components/site/AuthPanel.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import { api } from '$lib/api';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';
	import { safeNext } from '$lib/navigation';
	import type { Me } from '$lib/types';

	const i18n = getI18n();
	const t = $derived(i18n.t.auth);

	let email = $state('');
	let password = $state('');
	let busy = $state(false);
	let error = $state('');

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		busy = true;
		error = '';
		try {
			const me = await api.post<Me>('/api/session', { email_address: email, password });
			await invalidate('app:me');
			await goto(
				safeNext(page.url.searchParams.get('next'), me.place ? `/@${me.place.username}` : '/edit')
			);
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<svelte:head><title>{t.loginTitle} — MySweetPlace</title></svelte:head>

<AuthPanel title={t.loginTitle} lead={t.loginLead}>
	<form onsubmit={submit}>
		<Field label={t.email}>
			<input class="input" type="email" bind:value={email} autocomplete="email" required />
		</Field>
		<Field label={t.password}>
			<input
				class="input"
				type="password"
				bind:value={password}
				autocomplete="current-password"
				required
			/>
		</Field>
		{#if error}<p class="notice notice-error">{error}</p>{/if}
		<p class="row">
			<button class="btn" disabled={busy}>{t.loginButton}</button>
			<a class="forgot" href="/forgot-password">{t.forgot}</a>
		</p>
	</form>
	{#snippet footer()}
		{t.noAccount} <a href="/signup">{t.createOne}</a>
	{/snippet}
</AuthPanel>

<style>
	.forgot {
		margin-left: auto;
		font-size: 12px;
	}
</style>
