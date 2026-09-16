// Builds src/lib/stack/catalog.ts and static/icons/brands from simple-icons.
// Comma separated entries: "slug", "slug:Name" or "~id:Name:#color" for technologies without an icon.
import { readFileSync, writeFileSync, mkdirSync, rmSync } from 'node:fs';

const packageDir = new URL('../node_modules/simple-icons/', import.meta.url);
const icons = JSON.parse(readFileSync(new URL('data/simple-icons.json', packageDir), 'utf8'));
const iconsDir = new URL('icons/', packageDir);
const bySlug = new Map(icons.map((icon) => [icon.slug, icon]));

const stack = {
	languages: `
		javascript, typescript, python, ruby, go, rust, c, cplusplus:C++, ~csharp:C#:#512bd4, openjdk:Java, kotlin, swift,
		php, perl, lua, r, julia, dart, scala, haskell, elixir, erlang, clojure, fsharp:F#, ocaml, zig, nim, crystal,
		gleam, elm, purescript, rescript, coffeescript, solidity, assemblyscript, fortran, ~cobol:COBOL:#005ca5, delphi,
		gnubash:Bash, ~powershell:PowerShell:#5391fe, html5:HTML, css, sass, less, webassembly:WebAssembly,
		graphql:GraphQL, markdown, latex:LaTeX, ~sql:SQL:#e38c00, ~prolog:Prolog:#e61b23, commonlisp:Common Lisp, racket,
		d, haxe, ~matlab:MATLAB:#e16737, ~visualbasic:Visual Basic:#004e8c, ~groovy:Groovy:#4298b8, ~tcl:Tcl:#e4cc98,
		~nix:Nix:#5277c3, vala, autohotkey:AutoHotkey, ~1c:1С:#ffd200, ~assembly:Assembler:#6e4c13, ~vlang:V:#5d87bf,
		~smalltalk:Smalltalk:#596706, ~mojo:Mojo:#ff4f0f, odin`,
	frontend: `
		react, vuedotjs:Vue, svelte, angular, solid, preact, qwik, astro, nextdotjs:Next.js, nuxt, remix, gatsby,
		emberdotjs:Ember, alpinedotjs:Alpine.js, htmx, lit, stimulus, hotwire, jquery, backbonedotjs:Backbone.js,
		threedotjs:Three.js, d3, tailwindcss:Tailwind CSS, bootstrap, bulma, styledcomponents:styled-components, mui:MUI,
		chakraui:Chakra UI, shadcnui:shadcn/ui, radixui:Radix UI, storybook, vite, webpack, rollupdotjs:Rollup, esbuild,
		babel, turborepo, redux, mobx, reactquery:TanStack Query, apollographql:Apollo, framer, greensock:GSAP, lodash,
		~rxjs:RxJS:#b7178c, ~pixijs:PixiJS:#e72264, webcomponentsdotorg:Web Components`,
	backend: `
		nodedotjs:Node.js, deno, bun, express, fastify, nestjs:NestJS, koa, hono, rubyonrails:Ruby on Rails,
		~sinatra:Sinatra:#8c1a1a, django, flask, fastapi:FastAPI, laravel, symfony, spring, springboot:Spring Boot,
		quarkus, ~micronaut:Micronaut:#2a2a2a, dotnet:.NET, gin, actix, rocket, phoenixframework:Phoenix, ktor, vapor,
		strapi, directus, supabase, firebase, appwrite, pocketbase, trpc:tRPC, prisma, drizzle, sequelize, typeorm:TypeORM,
		sqlalchemy:SQLAlchemy, celery, rabbitmq:RabbitMQ, apachekafka:Kafka, ~nats:NATS:#27aae1, nginx,
		apache:Apache HTTP Server, caddy, traefikproxy:Traefik, gunicorn, socketdotio:Socket.IO, ~grpc:gRPC:#244c5a,
		openapiinitiative:OpenAPI, swagger`,
	mobile: `
		android, ios:iOS, ~reactnative:React Native:#61dafb, expo, flutter, jetpackcompose:Jetpack Compose, ionic,
		capacitor`,
	desktop: `
		electron, tauri, qt, gtk:GTK`,
	gamedev: `
		unity, unrealengine:Unreal Engine, godotengine:Godot, bevy, gamemaker:GameMaker, ~defold:Defold:#1e62fe,
		~love2d:LÖVE:#e74a99, ~phaser:Phaser:#8a2be2, raylib, roblox, aseprite`,
	databases: `
		postgresql:PostgreSQL, mysql:MySQL, mariadb:MariaDB, sqlite:SQLite, mongodb:MongoDB, redis, clickhouse:ClickHouse,
		elasticsearch, opensearch, apachecassandra:Cassandra, neo4j, duckdb:DuckDB, snowflake, influxdb:InfluxDB,
		timescale:TimescaleDB, cockroachlabs:CockroachDB, planetscale:PlanetScale, meilisearch, qdrant,
		~couchdb:CouchDB:#e42528, ~memcached:Memcached:#009ea1, ~valkey:Valkey:#6983ff, ~oracle:Oracle Database:#f80000,
		~mssql:SQL Server:#cc2927, ~tarantool:Tarantool:#ff4f4f, ~ydb:YDB:#2f6fed`,
	devops: `
		docker, kubernetes, podman, helm, terraform, opentofu:OpenTofu, ansible, puppet, chef, vagrant, packer, proxmox,
		vmware, virtualbox, githubactions:GitHub Actions, jenkins, circleci:CircleCI, travisci:Travis CI, argo, prometheus,
		grafana, sentry, datadog, newrelic:New Relic, kibana, logstash, elastic, cloudflare, googlecloud:Google Cloud,
		digitalocean:DigitalOcean, hetzner, vercel, netlify, ~heroku:Heroku:#430098, flydotio:Fly.io, render, railway,
		yandexcloud:Yandex Cloud, openstack, letsencrypt:Let’s Encrypt, ~aws:AWS:#ff9900, ~azure:Azure:#0078d4,
		~selectel:Selectel:#e30613`,
	os: `
		linux, ubuntu, debian, archlinux:Arch Linux, fedora, nixos:NixOS, alpinelinux:Alpine Linux, centos:CentOS,
		redhat:Red Hat, opensuse:openSUSE, freebsd:FreeBSD, openbsd:OpenBSD, macos:macOS, ~windows:Windows:#0078d4, gentoo,
		manjaro, linuxmint:Linux Mint, popos:Pop!_OS, kalilinux:Kali Linux, elementary, endeavouros:EndeavourOS,
		~astralinux:Astra Linux:#1a73e8`,
	editors: `
		vim, neovim, gnuemacs:Emacs, ~vscode:VS Code:#007acc, ~visualstudio:Visual Studio:#5c2d91,
		intellijidea:IntelliJ IDEA, pycharm:PyCharm, webstorm:WebStorm, rubymine:RubyMine, goland:GoLand, clion:CLion,
		rider, datagrip:DataGrip, phpstorm:PhpStorm, androidstudio:Android Studio, zedindustries:Zed,
		sublimetext:Sublime Text, xcode, cursor, helix, notepadplusplus:Notepad++, ~nano:nano:#4a2a7a`,
	tools: `
		git, github, gitlab, bitbucket, gitea, forgejo, codeberg, jira, confluence, notion, obsidian, linear, trello,
		discord, telegram, postman, insomnia, npm, pnpm, yarn, homebrew, warp, iterm2, alacritty, wezterm, tmux, zsh,
		fishshell:fish, stackoverflow:Stack Overflow, anthropic, claude, ollama, ngrok, ~slack:Slack:#4a154b,
		~chatgpt:ChatGPT:#10a37f, ~kitty:kitty:#784421`,
	testing: `
		jest, vitest, mocha, pytest, cypress, selenium, testinglibrary:Testing Library, junit5:JUnit, puppeteer, k6,
		cucumber, ~playwright:Playwright:#2ead33, ~rspec:RSpec:#cc342d, ~minitest:Minitest:#a91401`,
	data: `
		pandas, numpy, scipy, scikitlearn:scikit-learn, tensorflow, pytorch:PyTorch, keras, jupyter, anaconda,
		opencv:OpenCV, apachespark:Spark, apacheairflow:Airflow, plotly, streamlit, langchain, polars,
		huggingface:Hugging Face, mlflow:MLflow, ~dbt:dbt:#ff694b, ~tableau:Tableau:#e97627, ~powerbi:Power BI:#f2c811`,
	design: `
		figma, sketch, blender, krita, gimp:GIMP, inkscape, penpot, miro, ~photoshop:Photoshop:#31a8ff,
		~illustrator:Illustrator:#ff9a00, ~affinity:Affinity:#7e4dd2, ~canva:Canva:#00c4cc`,
	hardware: `
		raspberrypi:Raspberry Pi, arduino, espressif, kicad:KiCad, autodesk, nvidia:NVIDIA, amd:AMD, intel, arm:Arm,
		stmicroelectronics:STMicroelectronics, platformio:PlatformIO`
};

const brands = `x telegram youtube instagram twitch tiktok pinterest reddit medium devdotto spotify soundcloud lastdotfm steam
	itchdotio behance dribbble patreon bandcamp rubygems npm odnoklassniki wakatime threads signal whatsapp matrix element
	keybase substack wordpress tumblr sourcehut mastodon bluesky habr boosty kofi applemusic letterboxd goodreads leetcode vk
	github gitlab codeberg discord facebook gmail protonmail buymeacoffee liberapay opencollective githubsponsors hashnode
	deviantart artstation flickr unsplash vimeo mixcloud deezer tidal youtubemusic anilist myanimelist shikimori trakt imdb
	chessdotcom lichess strava duolingo kaggle orcid researchgate googlescholar hackerrank codewars`;

const outDir = new URL('../static/icons/brands/', import.meta.url);
rmSync(outDir, { recursive: true, force: true });
mkdirSync(outDir, { recursive: true });

const copyIcon = (slug) => {
	const svg = readFileSync(new URL(`${slug}.svg`, iconsDir), 'utf8').replace(
		/<title>.*?<\/title>/,
		''
	);
	writeFileSync(new URL(`${slug}.svg`, outDir), svg);
};

const catalog = [];
const seen = new Set();
const missing = [];

for (const [category, list] of Object.entries(stack)) {
	for (const token of list
		.split(',')
		.map((entry) => entry.trim())
		.filter(Boolean)) {
		if (token.startsWith('~')) {
			const [id, name, color] = token.slice(1).split(':');
			catalog.push({ id, name, category, color, icon: false });
			seen.add(id);
			continue;
		}
		const [slug, name] = token.split(/:(.*)/s);
		const icon = bySlug.get(slug);
		if (!icon) {
			missing.push(slug);
			continue;
		}
		if (seen.has(slug)) throw new Error(`duplicate ${slug}`);
		seen.add(slug);
		catalog.push({
			id: slug,
			name: name || icon.title,
			category,
			color: `#${icon.hex.toLowerCase()}`,
			icon: true
		});
		copyIcon(slug);
	}
}

for (const slug of brands.split(/\s+/).filter(Boolean)) {
	if (bySlug.has(slug)) copyIcon(slug);
	else missing.push(slug);
}

const categories = Object.keys(stack);
writeFileSync(
	new URL('../src/lib/stack/catalog.ts', import.meta.url),
	`// generated by scripts/icons.mjs, icons: simple-icons (CC0)\n` +
		`export const STACK_CATEGORIES = ${JSON.stringify(categories)} as const;\n\n` +
		`export type StackCategory = (typeof STACK_CATEGORIES)[number];\n\n` +
		`export interface Tech {\n\tid: string;\n\tname: string;\n\tcategory: StackCategory;\n\tcolor: string;\n\ticon: boolean;\n}\n\n` +
		`export const CATALOG: Tech[] = [\n${catalog.map((tech) => `\t${JSON.stringify(tech)}`).join(',\n')}\n];\n`
);

console.log(
	`${catalog.length} technologies, ${catalog.filter((tech) => tech.icon).length} with icons`
);
if (missing.length) console.log('missing:', missing.join(' '));
