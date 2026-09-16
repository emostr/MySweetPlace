<script lang="ts">
	import Blocks from '@lucide/svelte/icons/layout-grid';
	import User from '@lucide/svelte/icons/user';
	import Palette from '@lucide/svelte/icons/palette';
	import NotebookPen from '@lucide/svelte/icons/notebook-pen';
	import BookHeart from '@lucide/svelte/icons/book-heart';
	import House from '@lucide/svelte/icons/house';
	import Settings from '@lucide/svelte/icons/settings';
	import ExternalLink from '@lucide/svelte/icons/external-link';
	import LogOut from '@lucide/svelte/icons/log-out';
	import Eye from '@lucide/svelte/icons/eye';
	import { goto, invalidate } from '$app/navigation';
	import { page } from '$app/state';
	import LocaleSwitch from '$lib/components/site/LocaleSwitch.svelte';
	import PlaceView from '$lib/components/place/PlaceView.svelte';
	import { api } from '$lib/api';
	import { EditorState, setEditor } from '$lib/editor/state.svelte';
	import { getI18n } from '$lib/i18n';

	let { data, children } = $props();
	const i18n = getI18n();
	const t = $derived(i18n.t.editor);

	// svelte-ignore state_referenced_locally
	const editor = setEditor(new EditorState(data.place));

	const tabs = $derived([
		{
			href: '/edit',
			label: t.tabs.blocks,
			icon: Blocks,
			dirty: Object.keys(editor.blockDrafts).length > 0
		},
		{ href: '/edit/profile', label: t.tabs.profile, icon: User, dirty: !!editor.profile },
		{ href: '/edit/appearance', label: t.tabs.appearance, icon: Palette, dirty: !!editor.theme },
		{ href: '/edit/notes', label: t.tabs.notes, icon: NotebookPen, dirty: false },
		{ href: '/edit/guestbook', label: t.tabs.guestbook, icon: BookHeart, dirty: false },
		{ href: '/edit/neighbours', label: t.tabs.neighbours, icon: House, dirty: false },
		{ href: '/edit/settings', label: t.tabs.settings, icon: Settings, dirty: false }
	]);

	const pending = $derived(
		editor.place.blocks.find((block) => block.kind === 'guestbook')?.content?.pending ?? 0
	);
	const withPreview = $derived(
		['/edit', '/edit/profile', '/edit/appearance'].includes(page.url.pathname)
	);
	let previewOpen = $state(false);

	async function logout() {
		await api.delete('/api/session');
		await invalidate('app:me');
		await goto('/');
	}
</script>

<svelte:head><title>{t.title} — MySweetPlace</title></svelte:head>

<div class="editor">
	<header class="bar">
		<a class="logo" href="/">MySweetPlace</a>
		<span class="crumb">{t.title} · @{editor.place.username}</span>
		<span class="spacer"></span>
		{#if withPreview}
			<button class="bar-link preview-toggle" onclick={() => (previewOpen = !previewOpen)}
				><Eye size={15} /> {t.preview}</button
			>
		{/if}
		<a class="bar-link" href="/@{editor.place.username}"
			><ExternalLink size={15} /> <span class="long">{t.view}</span></a
		>
		<LocaleSwitch signedIn />
		<button class="bar-link" onclick={logout} title={i18n.t.site.nav.logout}
			><LogOut size={15} /></button
		>
	</header>

	<div class="body" class:with-preview={withPreview}>
		<nav class="tabs" aria-label={t.title}>
			{#each tabs as tab (tab.href)}
				{@const Icon = tab.icon}
				<a
					href={tab.href}
					class:active={page.url.pathname === tab.href}
					aria-current={page.url.pathname === tab.href ? 'page' : undefined}
				>
					<Icon size={16} />
					<span>{tab.label}</span>
					{#if tab.dirty}<i class="dirty" title={i18n.t.common.unsaved}></i>{/if}
					{#if tab.href === '/edit/guestbook' && pending > 0}<b class="count">{pending}</b>{/if}
				</a>
			{/each}
		</nav>

		<main class="content">
			{@render children()}
		</main>

		{#if withPreview}
			<aside class="preview" class:open={previewOpen}>
				<div class="preview-head">
					<span>{t.preview}</span>
					<a href="/@{editor.place.username}" target="_blank" rel="noopener"
						><ExternalLink size={13} /></a
					>
				</div>
				<div class="preview-scroll">
					<div class="preview-zoom">
						<PlaceView place={editor.preview} me={data.me} preview />
					</div>
				</div>
			</aside>
		{/if}
	</div>
</div>

<style>
	.editor {
		display: flex;
		flex-direction: column;
		height: 100vh;
		background: var(--page);
	}

	.bar {
		display: flex;
		flex: none;
		gap: 14px;
		align-items: center;
		padding: 0 18px;
		background: linear-gradient(var(--bar-top), var(--bar-bottom));
		border-bottom: 1px solid var(--bar-deep);
	}

	.logo {
		font: normal 19px/46px var(--serif);
		color: #fff;
		text-decoration: none;
		text-shadow: 0 1px 0 #000;
	}

	.logo:hover {
		color: #fff;
	}

	.crumb {
		font-size: 12px;
		color: var(--bar-ink);
		text-transform: uppercase;
		letter-spacing: 1px;
	}

	.spacer {
		flex: 1;
	}

	.bar-link {
		display: inline-flex;
		gap: 6px;
		align-items: center;
		padding: 0;
		font-size: 13px;
		color: var(--bar-ink);
		text-decoration: none;
		background: none;
		border: 0;
		cursor: pointer;
	}

	.bar-link:hover {
		color: #fff;
	}

	.preview-toggle {
		display: none;
	}

	.body {
		display: grid;
		flex: 1;
		grid-template-columns: 190px minmax(0, 1fr);
		min-height: 0;
	}

	.body.with-preview {
		grid-template-columns: 190px minmax(420px, 1fr) minmax(380px, 0.9fr);
	}

	.tabs {
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 14px 8px;
		overflow-y: auto;
		background: #f4f5f6;
		border-right: 1px solid var(--line);
	}

	.tabs a {
		display: flex;
		gap: 9px;
		align-items: center;
		padding: 8px 10px;
		color: #3b3e44;
		text-decoration: none;
		border-radius: 3px;
	}

	.tabs a:hover {
		background: #e8e9eb;
	}

	.tabs a.active {
		color: #fff;
		background: linear-gradient(#8e2e3b, #6d2230);
		box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.15);
	}

	.dirty {
		width: 7px;
		height: 7px;
		margin-left: auto;
		background: #e0a100;
		border-radius: 50%;
	}

	.count {
		margin-left: auto;
		padding: 0 6px;
		font-size: 11px;
		color: #fff;
		background: var(--accent);
		border-radius: 999px;
	}

	.active .count {
		color: var(--accent);
		background: #fff;
	}

	.content {
		min-width: 0;
		padding: 22px 26px 60px;
		overflow-y: auto;
		background: var(--paper);
	}

	.preview {
		display: flex;
		flex-direction: column;
		min-width: 0;
		background: #d9dbde;
		border-left: 1px solid var(--line-strong);
	}

	.preview-head {
		display: flex;
		justify-content: space-between;
		padding: 5px 12px;
		font-size: 11px;
		color: var(--ink-soft);
		text-transform: uppercase;
		letter-spacing: 1px;
		background: linear-gradient(#f3f4f5, #e2e4e7);
		border-bottom: 1px solid var(--line-strong);
	}

	.preview-scroll {
		flex: 1;
		overflow-y: auto;
	}

	.preview-zoom {
		zoom: 0.62;
		min-height: 100%;
	}

	@media (max-width: 1100px) {
		.body.with-preview {
			grid-template-columns: 170px minmax(0, 1fr);
		}

		.preview-toggle {
			display: inline-flex;
		}

		.preview {
			position: fixed;
			inset: 46px 0 0 auto;
			z-index: 50;
			width: min(560px, 100%);
			box-shadow: -10px 0 30px rgba(0, 0, 0, 0.2);
			transform: translateX(100%);
			transition: transform 0.2s;
		}

		.preview.open {
			transform: none;
		}
	}

	@media (max-width: 720px) {
		.body,
		.body.with-preview {
			grid-template-columns: minmax(0, 1fr);
			grid-template-rows: auto 1fr;
		}

		.tabs {
			flex-direction: row;
			padding: 6px;
			overflow-x: auto;
			border-right: 0;
			border-bottom: 1px solid var(--line);
		}

		.tabs a {
			flex: none;
			padding: 6px 9px;
		}

		.tabs a span {
			display: none;
		}

		.tabs a.active span {
			display: inline;
		}

		.crumb,
		.long {
			display: none;
		}

		.content {
			padding: 16px 14px 50px;
		}
	}
</style>
