<script lang="ts">
	import AuthPanel from '$lib/components/site/AuthPanel.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import { api } from '$lib/api';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';

	const i18n = getI18n();
	const t = $derived(i18n.t.auth);

	let email = $state('');
	let busy = $state(false);
	let sent = $state(false);
	let error = $state('');

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		busy = true;
		error = '';
		try {
			await api.post('/api/password_resets', { email_address: email });
			sent = true;
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<svelte:head><title>{t.forgotTitle} — MySweetPlace</title></svelte:head>

<AuthPanel title={t.forgotTitle} lead={t.forgotLead}>
	{#if sent}
		<p class="notice notice-ok">{t.forgotSent}</p>
		<p><a href="/login">{i18n.t.site.nav.login}</a></p>
	{:else}
		<form onsubmit={submit}>
			<Field label={t.email}>
				<input class="input" type="email" bind:value={email} autocomplete="email" required />
			</Field>
			{#if error}<p class="notice notice-error">{error}</p>{/if}
			<p><button class="btn" disabled={busy}>{t.forgotButton}</button></p>
		</form>
	{/if}
</AuthPanel>
