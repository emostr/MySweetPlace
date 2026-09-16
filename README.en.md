# MySweetPlace

**Your cozy little place on the internet.** [Русская версия](README.md)

MySweetPlace is a personal space that brings together a home page, a small blog, a portfolio, links and interests. It is not a social network and not a website builder: everyone gets a place at `mysweetplace.org/@username` to slowly decorate, change and fill with their life.

## Features

- **A place made of blocks.** Intro, links, projects, notes, now, stack, interests, music, photos, guestbook, neighbours, timeline and free text. Each block can be reordered, hidden, resized, restyled, retitled and given its own accent color.
- **Customization over templates.** 10 ready-made themes, six colors, 34 fonts with Cyrillic, color, gradient, pattern or image backgrounds, six card styles, corner radius and page width. A live preview in the editor shows every change.
- **Notes (a microblog).** Markdown, code highlighting, up to four photos, and embeds from YouTube, Yandex Music, Spotify, SoundCloud, Apple Music, Rutube, Vimeo and CodePen.
- **Guestbook.** Visitors leave entries, and the owner can hide, pin and delete them, turn on premoderation and limit who can write.
- **Neighbours instead of followers.** Being neighbours doesn't have to be mutual. Neighbours can be shown as a list or as a little neighbourhood of houses.
- **“Take me somewhere”.** A random place: no algorithms, no recommendations.
- **Stack.** A catalog of almost 400 languages, frameworks and tools with icons, plus custom ones.
- **Search by interests**, two languages (Russian first, English second, including a place's own content), snow in winter and garlands around New Year.
- Rich link previews thanks to server-side rendering.

## Stack

| | |
| --- | --- |
| Backend | Ruby 4.0, Rails 8.1 (API), PostgreSQL + JSONB, Active Storage |
| Frontend | TypeScript, Svelte 5, SvelteKit (SSR, adapter-node) |
| Server | Ubuntu Server 26.04, nginx, systemd, Let's Encrypt |

```
backend/    Rails API, everything under /api
frontend/   SvelteKit: pages, places, editor
deploy/     deployment script and nginx config
bin/        development helpers
```

## Development

You need Ruby 4.0.6 (for example via rbenv), Node.js 22+ and PostgreSQL 16+.

```bash
bin/setup   # dependencies, database and Niki's mascot place
bin/dev     # api on :3000, site on http://localhost:5173
```

Local Niki login: `niki@example.com` / `password123`. You can see the winter effects any time with `/?season=winter` or `/?season=festive`.

Checks:

```bash
cd backend && bin/rails test && bin/rubocop && bin/brakeman
cd frontend && npm run check && npm run lint && npm test
```

### How it works

- The browser talks to a single origin: `/api/*` goes to Rails (through the Vite proxy in development, through nginx in production). During SSR, SvelteKit calls Rails itself and forwards the user's cookie.
- The session lives in a signed httpOnly `SameSite=Lax` cookie. State-changing requests also have their `Origin` header checked.
- Profiles, themes and block content are stored as JSONB. Before saving, data goes through schemas (`backend/lib/schema.rb`, `backend/app/models/block/kinds.rb`) that drop unknown keys, normalize values and return errors with a path to the field.
- Images are resized in the browser before upload, so the server doesn't need libvips.
- Technology and brand icons are generated from simple-icons: `cd frontend && node scripts/icons.mjs`.
- The footer quotes live in `frontend/src/lib/mottos.ts`.

## Deployment

You need a server running Ubuntu Server 26.04, with the domain and `www` already pointing to its IP.

```bash
git clone https://github.com/emostr/MySweetPlace.git
sudo MySweetPlace/deploy/deploy.sh --domain mysweetplace.org --email you@example.com
```

The script:
- installs packages, Node.js and Ruby (via rbenv);
- creates the `mysweetplace` user and a PostgreSQL database (peer authentication, no password);
- generates secrets and builds the app into `/srv/mysweetplace`;
- sets up the systemd services `mysweetplace-backend` and `mysweetplace-frontend`, plus a daily uploads cleanup timer;
- configures nginx and obtains a Let's Encrypt certificate.

Running the same command again updates the app to the latest `master`.

On the first database setup, `db:prepare` automatically loads seed data: only the mascot `@niki`, including the avatar, theme and notes. It creates no test profiles, neighbourships or guestbook entries. In production, Niki gets a random password; set `NIKI_PASSWORD` in `/etc/mysweetplace/backend.env` before the mascot is first created to choose your own. Re-running seeds preserves the existing profile and password and does not delete previously created accounts. Use `--seed` to create Niki in an already prepared database as well.

Ruby is built from source; configuration and compilation can take several minutes. The script shows verbose build output. `^C` before `BUILD FAILED` indicates an interruption (usually Ctrl+C): rerun deployment and let it finish. If the build fails on its own, check the ruby-build output and any log path it prints; `Deployment failed on line 56` points to the command wrapper, not the underlying Ruby error.

- Settings live in `/etc/mysweetplace/backend.env` and `frontend.env`: SMTP for password reset emails and a forced season.
- Uploaded files are stored in `/srv/mysweetplace/storage`.
- Logs: `journalctl -u mysweetplace-backend -f`.
- Extra flags: `--no-ssl`, `--firewall`, `--branch`, `--repo`, `--seed`.

## License

[Apache 2.0](LICENSE). Brand icons come from [simple-icons](https://simpleicons.org) (CC0), fonts from [Fontsource](https://fontsource.org) (OFL), and UI icons from [Lucide](https://lucide.dev) (ISC).
