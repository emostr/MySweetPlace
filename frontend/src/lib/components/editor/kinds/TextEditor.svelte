<script lang="ts">
	import LocalizedInput from '../LocalizedInput.svelte';
	import { getI18n } from '$lib/i18n';
	import type { BlockDataMap } from '$lib/types';

	let { data = $bindable() }: { data: BlockDataMap['text'] } = $props();
	const i18n = getI18n();
</script>

<LocalizedInput
	bind:value={data.body}
	label={i18n.t.editor.forms.textBody}
	multiline
	rows={8}
	maxlength={5000}
/>
