<script lang="ts">
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['notes'] } = $props();
	const i18n = getI18n();
</script>

<label class="field">
	<span class="field-label">{i18n.t.editor.forms.notesLimit}</span>
	<input class="input narrow" type="number" min="1" max="20" bind:value={data.limit} />
	<span class="hint">{i18n.t.editor.forms.notesHint} <a href="/edit/notes">→</a></span>
</label>

<style>
	.narrow {
		width: 90px;
	}
</style>
