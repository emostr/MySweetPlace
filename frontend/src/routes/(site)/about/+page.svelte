<script lang="ts">
	import { getI18n } from '$lib/i18n';

	const i18n = getI18n();
	const t = $derived(i18n.t.about);
</script>

<svelte:head>
	<title>{t.title} — MySweetPlace</title>
	<meta name="description" content={t.lead} />
</svelte:head>

<article class="about">
	<h1>{t.title}</h1>
	<p class="lead">{t.lead}</p>
	<p>{t.notSocial}</p>

	<h2 class="section-title">{t.principlesTitle}</h2>
	<dl class="principles">
		{#each t.principles as principle (principle.title)}
			<div>
				<dt>{principle.title}</dt>
				<dd>{principle.text}</dd>
			</div>
		{/each}
	</dl>

	<h2 class="section-title">{t.openSourceTitle}</h2>
	<p>
		{t.openSource}
		<a href="https://github.com/emostr/MySweetPlace" rel="noopener"
			>github.com/emostr/MySweetPlace</a
		>
	</p>
</article>

<style>
	.about {
		max-width: 760px;
		padding: 40px 60px 56px;
	}

	h1 {
		margin-bottom: 14px;
		font-size: 30px;
	}

	.lead {
		font: 18px/1.5 var(--serif);
		color: #444;
	}

	.section-title {
		margin-top: 30px;
	}

	.principles {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		gap: 18px 28px;
		margin: 0;
	}

	dt {
		margin-bottom: 2px;
		font-weight: bold;
		color: var(--accent);
	}

	dd {
		margin: 0;
		color: #555;
	}

	@media (max-width: 760px) {
		.about {
			padding: 26px 16px 40px;
		}

		.principles {
			grid-template-columns: 1fr;
		}
	}
</style>
