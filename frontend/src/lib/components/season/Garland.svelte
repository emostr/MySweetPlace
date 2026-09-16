<div class="garland" aria-hidden="true">
	{#each { length: 32 }, index}
		<span class="bulb" style="--i: {index}"></span>
	{/each}
</div>

<style>
	.garland {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		z-index: 80;
		display: flex;
		justify-content: space-around;
		height: 26px;
		overflow: hidden;
		pointer-events: none;
		background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='14'%3E%3Cpath d='M0 2q15 12 30 0t30 0' fill='none' stroke='%23364a2f' stroke-width='1.6'/%3E%3C/svg%3E")
			repeat-x 0 0 / 60px 14px;
	}

	.bulb {
		width: 8px;
		height: 12px;
		margin-top: 8px;
		border-radius: 50% 50% 45% 45%;
		background: var(--color);
		box-shadow: 0 2px 10px 1px var(--color);
		animation: twinkle 1.8s ease-in-out infinite alternate;
		animation-delay: calc(var(--i) * -0.37s);
		--color: #ff5a5a;
	}

	.bulb:nth-child(4n + 2) {
		--color: #ffd34d;
	}

	.bulb:nth-child(4n + 3) {
		--color: #5ad1ff;
	}

	.bulb:nth-child(4n + 4) {
		--color: #7cff7a;
	}

	@media (max-width: 700px) {
		.bulb:nth-child(2n) {
			display: none;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.bulb {
			animation: none;
		}
	}

	@keyframes twinkle {
		from {
			opacity: 1;
		}
		to {
			opacity: 0.35;
			box-shadow: none;
		}
	}
</style>
