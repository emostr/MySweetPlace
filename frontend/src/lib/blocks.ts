import type { Component } from 'svelte';
import User from '@lucide/svelte/icons/user';
import Link from '@lucide/svelte/icons/link';
import FolderGit2 from '@lucide/svelte/icons/folder-git-2';
import NotebookPen from '@lucide/svelte/icons/notebook-pen';
import Sparkles from '@lucide/svelte/icons/sparkles';
import Layers from '@lucide/svelte/icons/layers';
import Heart from '@lucide/svelte/icons/heart';
import Music from '@lucide/svelte/icons/music';
import Image from '@lucide/svelte/icons/image';
import BookHeart from '@lucide/svelte/icons/book-heart';
import House from '@lucide/svelte/icons/house';
import Milestone from '@lucide/svelte/icons/milestone';
import Type from '@lucide/svelte/icons/type';
import type { I18n } from '$lib/i18n';
import type { Block, BlockKind } from '$lib/types';

export const BLOCK_KINDS: BlockKind[] = [
	'intro',
	'now',
	'links',
	'notes',
	'projects',
	'stack',
	'interests',
	'music',
	'photos',
	'timeline',
	'guestbook',
	'neighbours',
	'text'
];

export const MULTIPLE: BlockKind[] = ['links', 'projects', 'photos', 'text'];

export const VARIANTS: Record<BlockKind, string[]> = {
	intro: ['side', 'center'],
	links: ['list', 'buttons', 'icons'],
	projects: ['cards', 'list'],
	notes: ['feed', 'compact'],
	now: ['list', 'card'],
	stack: ['badges', 'icons', 'grouped'],
	interests: ['tags', 'list'],
	music: ['default'],
	photos: ['grid', 'polaroid'],
	guestbook: ['default'],
	neighbours: ['list', 'district'],
	timeline: ['default'],
	text: ['card', 'plain']
};

export const BLOCK_ICONS: Record<BlockKind, Component> = {
	intro: User,
	links: Link,
	projects: FolderGit2,
	notes: NotebookPen,
	now: Sparkles,
	stack: Layers,
	interests: Heart,
	music: Music,
	photos: Image,
	guestbook: BookHeart,
	neighbours: House,
	timeline: Milestone,
	text: Type
};

export function blockTitle(block: Pick<Block, 'kind' | 'title'>, i18n: I18n) {
	return i18n.pick(block.title) || i18n.t.blocks.titles[block.kind];
}

export function isBlockEmpty(block: Block) {
	switch (block.kind) {
		case 'intro':
		case 'guestbook':
			return false;
		case 'notes':
			return block.content.items.length === 0;
		case 'neighbours':
			return block.content.items.length === 0;
		case 'now':
			return !block.data.items.length && !Object.values(block.data.text).some(Boolean);
		case 'music': {
			const { current, anthem, artists, albums, playlist } = block.data;
			return !current.title && !anthem.title && !artists.length && !albums.length && !playlist.url;
		}
		case 'text':
			return !Object.values(block.data.body).some(Boolean);
		default:
			return block.data.items.length === 0;
	}
}
