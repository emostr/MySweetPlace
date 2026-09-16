<script lang="ts">
	import { getI18n } from '$lib/i18n';

	let { motto }: { motto: string } = $props();
	const i18n = getI18n();
	const year = new Date().getFullYear();
</script>

<footer class="site-footer">
	<p class="motto">{motto}</p>
	<img class="mascot" src="/images/niki.png" alt={i18n.t.site.mascotAlt} width="160" height="120" />
	<div class="copy">
		&copy; MySweetPlace, {year} · {i18n.t.site.footer.rights}<br />
		{i18n.t.site.footer.infrastructure}
		<a href="https://senko.digital" rel="noopener">senko://digital</a><br />
		<a href="/about">{i18n.t.site.nav.about}</a> ·
		<a href="https://github.com/emostr/MySweetPlace" rel="noopener">{i18n.t.site.footer.source}</a>
		·
		<a href="https://github.com/emostr/MySweetPlace/blob/master/LICENSE" rel="noopener"
			>{i18n.t.site.footer.license}</a
		>
		·
		<a href="#top">{i18n.t.site.footer.toTop}</a>
	</div>
</footer>

<style>
	.site-footer {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0 12px;
		padding: 22px 30px;
		font-size: 11px;
		color: #8a8f96;
		background: var(--bar-bottom);
		border-top: 3px solid var(--accent-deep);
	}

	.motto {
		margin: 0;
		font: italic 14px/1.6 var(--serif);
		color: var(--bar-ink);
		white-space: pre-line;
	}

	.mascot {
		display: block;
		width: 160px;
		height: 120px;
		margin-left: -12px;
	}

	.copy {
		margin-left: auto;
		text-align: right;
	}

	a {
		color: var(--bar-ink);
		text-decoration: none;
	}

	a:hover {
		color: #fff;
		text-decoration: underline;
	}

	@media (max-width: 760px) {
		.site-footer {
			padding: 20px 16px;
		}

		.copy {
			width: 100%;
			margin: 8px 0 0;
			text-align: left;
		}
	}
</style>
