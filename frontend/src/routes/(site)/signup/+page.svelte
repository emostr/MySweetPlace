<script lang="ts">
	import { goto, invalidate } from '$app/navigation';
	import AuthPanel from '$lib/components/site/AuthPanel.svelte';
	import Field from '$lib/components/ui/Field.svelte';
	import { api } from '$lib/api';
	import { errorMessage, fieldErrors } from '$lib/errors';
	import { getI18n } from '$lib/i18n';

	const i18n = getI18n();
	const t = $derived(i18n.t.auth);

	let username = $state('');
	let email = $state('');
	let password = $state('');
	let busy = $state(false);
	let error = $state('');
	let fields = $state<Record<string, string>>({});

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		busy = true;
		error = '';
		fields = {};
		try {
			await api.post('/api/registration', {
				username: username.replace(/^@/, ''),
				email_address: email,
				password
			});
			await invalidate('app:me');
			await goto('/edit');
		} catch (e) {
			fields = fieldErrors(e);
			if (!Object.keys(fields).length) error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}
</script>

<svelte:head><title>{t.signupTitle} — MySweetPlace</title></svelte:head>

<AuthPanel title={t.signupTitle} lead={t.signupLead}>
	<form onsubmit={submit}>
		<Field label={t.username} hint={t.usernameHint(username.toLowerCase())} error={fields.username}>
			<span class="prefixed">
				<span>@</span>
				<input
					class="input"
					bind:value={username}
					autocomplete="username"
					required
					minlength="2"
					maxlength="30"
					pattern="@?[A-Za-z0-9][A-Za-z0-9_\-]+"
					aria-invalid={!!fields.username}
				/>
			</span>
		</Field>
		<Field label={t.email} error={fields.email_address}>
			<input
				class="input"
				type="email"
				bind:value={email}
				autocomplete="email"
				required
				aria-invalid={!!fields.email_address}
			/>
		</Field>
		<Field label={t.password} hint={t.passwordHint} error={fields.password}>
			<input
				class="input"
				type="password"
				bind:value={password}
				autocomplete="new-password"
				required
				minlength="8"
				aria-invalid={!!fields.password}
			/>
		</Field>
		{#if error}<p class="notice notice-error">{error}</p>{/if}
		<p><button class="btn" disabled={busy}>{t.signupButton}</button></p>
	</form>
	{#snippet footer()}
		{t.haveAccount} <a href="/login">{i18n.t.site.nav.login}</a>
	{/snippet}
</AuthPanel>

<style>
	.prefixed {
		display: flex;
		align-items: stretch;
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
</style>
