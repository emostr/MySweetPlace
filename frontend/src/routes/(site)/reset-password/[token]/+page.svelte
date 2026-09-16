<script lang="ts">
	import { page } from '$app/state';
	import AuthPanel from '$lib/components/site/AuthPanel.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import { api } from '$lib/api';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';

	const i18n = getI18n();
	const t = $derived(i18n.t.auth);

	let password = $state('');
	let busy = $state(false);
	let done = $state(false);
	let error = $state('');

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		busy = true;
		error = '';
		try {
			await api.patch(`/api/password_resets/${encodeURIComponent(page.params.token ?? '')}`, {
				password
			});
			done = true;
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<svelte:head><title>{t.resetTitle} — MySweetPlace</title></svelte:head>

<AuthPanel title={t.resetTitle}>
	{#if done}
		<p class="notice notice-ok">{t.resetDone}</p>
		<p><a class="btn" href="/login">{i18n.t.site.nav.login}</a></p>
	{:else}
		<form onsubmit={submit}>
			<Field label={t.password} hint={t.passwordHint}>
				<input
					class="input"
					type="password"
					bind:value={password}
					autocomplete="new-password"
					required
					minlength="8"
				/>
			</Field>
			{#if error}<p class="notice notice-error">{error}</p>{/if}
			<p><button class="btn" disabled={busy}>{t.resetButton}</button></p>
		</form>
	{/if}
</AuthPanel>
