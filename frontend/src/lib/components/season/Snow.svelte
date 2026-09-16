<script lang="ts">
	import { onMount } from 'svelte';
	import Snowflake from '@lucide/svelte/icons/snowflake';
	import { getI18n } from '$lib/i18n';

	const i18n = getI18n();
	let enabled = $state(false);
	let canvas = $state<HTMLCanvasElement>();

	onMount(() => {
		const stored = (() => {
			try {
				return localStorage.getItem('snow');
			} catch {
				return null;
			}
		})();
		const calm = matchMedia('(prefers-reduced-motion: reduce)').matches;
		enabled = stored ? stored === 'on' : !calm;
	});

	function sprite(radius: number) {
		const size = radius * 2 + 4;
		const sprite = document.createElement('canvas');
		sprite.width = sprite.height = size;
		const ctx = sprite.getContext('2d')!;
		const gradient = ctx.createRadialGradient(size / 2, size / 2, 0, size / 2, size / 2, size / 2);
		gradient.addColorStop(0, 'rgba(255,255,255,1)');
		gradient.addColorStop(0.55, 'rgba(255,255,255,0.9)');
		gradient.addColorStop(0.8, 'rgba(150,165,185,0.35)');
		gradient.addColorStop(1, 'rgba(150,165,185,0)');
		ctx.fillStyle = gradient;
		ctx.fillRect(0, 0, size, size);
		return sprite;
	}

	$effect(() => {
		if (!enabled || !canvas) return;
		const element = canvas;
		const ctx = element.getContext('2d')!;
		const image = sprite(6);
		const ratio = Math.min(devicePixelRatio || 1, 2);
		let width = 0;
		let height = 0;
		let frame = 0;
		let last = performance.now();

		type Flake = {
			x: number;
			y: number;
			size: number;
			speed: number;
			phase: number;
			sway: number;
			alpha: number;
		};
		const spawn = (anywhere: boolean): Flake => ({
			x: Math.random() * width,
			y: anywhere ? Math.random() * height : -12,
			size: 3 + Math.random() * 6,
			speed: 0.35 + Math.random() * 0.8,
			phase: Math.random() * Math.PI * 2,
			sway: 0.2 + Math.random() * 0.6,
			alpha: 0.55 + Math.random() * 0.45
		});

		const resize = () => {
			width = innerWidth;
			height = innerHeight;
			element.width = width * ratio;
			element.height = height * ratio;
			ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
		};
		resize();

		const flakes = Array.from({ length: Math.min(110, Math.round((width * height) / 16000)) }, () =>
			spawn(true)
		);

		const tick = (now: number) => {
			const step = Math.min(50, now - last) / 16.7;
			last = now;
			ctx.clearRect(0, 0, width, height);
			for (const flake of flakes) {
				flake.y += flake.speed * step;
				flake.phase += 0.012 * step;
				flake.x += Math.sin(flake.phase) * flake.sway * 0.5 * step;
				if (flake.y > height + 12) Object.assign(flake, spawn(false));
				ctx.globalAlpha = flake.alpha;
				ctx.drawImage(image, flake.x, flake.y, flake.size, flake.size);
			}
			frame = requestAnimationFrame(tick);
		};
		frame = requestAnimationFrame(tick);

		const visibility = () => {
			cancelAnimationFrame(frame);
			if (!document.hidden) {
				last = performance.now();
				frame = requestAnimationFrame(tick);
			}
		};
		addEventListener('resize', resize);
		document.addEventListener('visibilitychange', visibility);
		return () => {
			cancelAnimationFrame(frame);
			removeEventListener('resize', resize);
			document.removeEventListener('visibilitychange', visibility);
		};
	});

	function toggle() {
		enabled = !enabled;
		try {
			localStorage.setItem('snow', enabled ? 'on' : 'off');
		} catch {
			// private mode
		}
	}
</script>

{#if enabled}
	<canvas bind:this={canvas} class="snow" aria-hidden="true"></canvas>
{/if}

<button
	class="snow-toggle"
	class:off={!enabled}
	onclick={toggle}
	title={enabled ? i18n.t.season.snowOff : i18n.t.season.snowOn}
	aria-label={enabled ? i18n.t.season.snowOff : i18n.t.season.snowOn}
	aria-pressed={enabled}
>
	<Snowflake size={16} />
</button>

<style>
	.snow {
		position: fixed;
		inset: 0;
		z-index: 90;
		width: 100%;
		height: 100%;
		pointer-events: none;
	}

	.snow-toggle {
		position: fixed;
		right: 14px;
		bottom: 14px;
		z-index: 91;
		display: grid;
		place-items: center;
		width: 34px;
		height: 34px;
		color: #fff;
		background: rgba(42, 46, 51, 0.75);
		border: 1px solid rgba(255, 255, 255, 0.25);
		border-radius: 50%;
		cursor: pointer;
		backdrop-filter: blur(4px);
	}

	.snow-toggle.off {
		opacity: 0.55;
	}
</style>
