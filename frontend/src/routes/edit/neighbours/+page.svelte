<script lang="ts">
	import ArrowUp from '@lucide/svelte/icons/arrow-up';
	import ArrowDown from '@lucide/svelte/icons/arrow-down';
	import X from '@lucide/svelte/icons/x';
	import HousePlus from '@lucide/svelte/icons/house-plus';
	import { invalidate } from '$app/navigation';
	import Avatar from '$lib/components/ui/Avatar.svelte';
	import PlaceCard from '$lib/components/ui/PlaceCard.svelte';
	import { api } from '$lib/api';
	import { getEditor } from '$lib/editor/state.svelte';
	import { errorMessage } from '$lib/errors';
	import { getI18n } from '$lib/i18n';

	let { data } = $props();
	const i18n = getI18n();
	const editor = getEditor();
	const t = $derived(i18n.t.editor.neighbours);

	let username = $state('');
	let label = $state('');
	let busy = $state(false);
	let error = $state('');

	async function refresh() {
		await Promise.all([invalidate('app:editor-neighbours'), editor.reload()]);
	}

	async function run(action: () => Promise<unknown>) {
		busy = true;
		error = '';
		try {
			await action();
			await refresh();
		} catch (e) {
			error = errorMessage(e, i18n);
		} finally {
			busy = false;
		}
	}

	function add(event: SubmitEvent) {
		event.preventDefault();
		run(async () => {
			await api.post('/api/my/neighbours', { username: username.trim().replace(/^@/, ''), label });
			username = '';
			label = '';
		});
	}

	function move(index: number, delta: number) {
		const usernames = data.items.map((item) => item.username);
		[usernames[index], usernames[index + delta]] = [usernames[index + delta], usernames[index]];
		run(() => api.put('/api/my/neighbours/order', { usernames }));
	}
</script>

<h1>{t.title}</h1>

<form class="add panel" onsubmit={add}>
	<span class="prefixed">
		<span>@</span>
		<input
			class="input"
			bind:value={username}
			placeholder={t.addPlaceholder}
			required
			maxlength="31"
		/>
	</span>
	<input
		class="input"
		bind:value={label}
		placeholder={t.labelPlaceholder}
		maxlength="60"
		aria-label={t.label}
	/>
	<button class="btn" disabled={busy}><HousePlus size={15} /> {t.add}</button>
</form>
{#if error}<p class="notice notice-error">{error}</p>{/if}

{#if data.items.length}
	<ul class="neighbours">
		{#each data.items as neighbour, index (neighbour.id)}
			<li>
				<a class="who" href="/@{neighbour.username}">
					<Avatar
						src={neighbour.avatar_url}
						name={i18n.pick(neighbour.name) || neighbour.username}
						size={36}
						accent={neighbour.accent}
					/>
					<span>
						<strong>{i18n.pick(neighbour.name) || neighbour.username}</strong>
						<small>@{neighbour.username}</small>
					</span>
				</a>
				<input
					class="input label"
					value={neighbour.label ?? ''}
					placeholder={t.labelPlaceholder}
					maxlength="60"
					aria-label={t.label}
					onchange={(e) =>
						run(() =>
							api.patch(`/api/my/neighbours/${neighbour.username}`, {
								label: e.currentTarget.value
							})
						)}
				/>
				<span class="tools">
					<button
						class="icon-btn"
						title={i18n.t.common.up}
						disabled={index === 0 || busy}
						onclick={() => move(index, -1)}><ArrowUp size={15} /></button
					>
					<button
						class="icon-btn"
						title={i18n.t.common.down}
						disabled={index === data.items.length - 1 || busy}
						onclick={() => move(index, 1)}><ArrowDown size={15} /></button
					>
					<button
						class="icon-btn"
						title={i18n.t.common.remove}
						disabled={busy}
						onclick={() => run(() => api.delete(`/api/my/neighbours/${neighbour.username}`))}
						><X size={15} /></button
					>
				</span>
			</li>
		{/each}
	</ul>
{:else}
	<p class="muted">{t.empty}</p>
{/if}

<h2 class="section-title">{t.neighbourOf}</h2>
{#if data.neighbour_of.length}
	<div class="grid">
		{#each data.neighbour_of as place (place.id)}
			<PlaceCard {place} />
		{/each}
	</div>
{:else}
	<p class="muted">{t.nobody}</p>
{/if}

<style>
	h1 {
		margin-bottom: 14px;
		font-size: 26px;
	}

	.add {
		display: grid;
		grid-template-columns: 1fr 1.3fr auto;
		gap: 8px;
		margin-bottom: 14px;
		padding: 12px;
		background: #fafafb;
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

	.neighbours {
		display: grid;
		gap: 6px;
		margin: 0 0 26px;
		padding: 0;
		list-style: none;
	}

	li {
		display: grid;
		grid-template-columns: minmax(180px, 1fr) 1.2fr auto;
		gap: 10px;
		align-items: center;
		padding: 8px 10px;
		background: #fff;
		border: 1px solid var(--line);
		border-radius: 3px;
	}

	.who {
		display: flex;
		gap: 10px;
		align-items: center;
		min-width: 0;
		color: inherit;
		text-decoration: none;
	}

	.who strong {
		display: block;
		font: normal 15px var(--serif);
	}

	.who small {
		color: var(--ink-soft);
	}

	.tools {
		display: flex;
	}

	.grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
		gap: 10px;
	}

	@media (max-width: 720px) {
		.add,
		li {
			grid-template-columns: 1fr;
		}
	}
</style>
