<script lang="ts">
	import HousePlus from '@lucide/svelte/icons/house-plus';
	import House from '@lucide/svelte/icons/house';
	import { api } from '$lib/api';
	import { getI18n } from '$lib/i18n';
	import { getPlaceContext } from './context';

	let { username, neighbour }: { username: string; neighbour: boolean } = $props();
	const i18n = getI18n();
	const context = getPlaceContext();
	let busy = $state(false);
	let hover = $state(false);

	async function toggle() {
		busy = true;
		try {
			if (neighbour) await api.delete(`/api/my/neighbours/${username}`);
			else await api.post('/api/my/neighbours', { username });
			await context.refresh();
		} finally {
			busy = false;
		}
	}
</script>

<button
	class="bar-btn"
	class:on={neighbour}
	onclick={toggle}
	disabled={busy}
	onmouseenter={() => (hover = true)}
	onmouseleave={() => (hover = false)}
>
	{#if neighbour}
		<House size={15} />
		{hover ? i18n.t.place.removeNeighbour : i18n.t.place.isNeighbour}
	{:else}
		<HousePlus size={15} />
		{i18n.t.place.addNeighbour}
	{/if}
</button>
