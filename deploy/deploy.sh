#!/usr/bin/env bash
# MySweetPlace on Ubuntu Server 26.04: the first run sets the server up, next runs update the app.
set -Eeuo pipefail

APP=mysweetplace
APP_USER=mysweetplace
APP_HOME=/srv/mysweetplace
APP_DIR=$APP_HOME/app
STORAGE_DIR=$APP_HOME/storage
BUILD_TMP_DIR=$APP_HOME/tmp
ENV_DIR=/etc/mysweetplace
DB_NAME=mysweetplace_production
NODE_MAJOR=24
API_PORT=3000
WEB_PORT=3001

DOMAIN=${DOMAIN:-mysweetplace.org}
EMAIL=${EMAIL:-}
REPO=${REPO:-https://github.com/emostr/MySweetPlace.git}
BRANCH=${BRANCH:-master}
SSL=${SSL:-yes}
FIREWALL=${FIREWALL:-no}
SEED=${SEED:-no}

usage() {
	cat <<EOF
Usage: sudo $0 [options]

  --domain DOMAIN   domain name (default: $DOMAIN)
  --email EMAIL     email for Let's Encrypt certificates
  --repo URL        git repository (default: $REPO)
  --branch NAME     branch to deploy (default: $BRANCH)
  --no-ssl          don't request a certificate, serve plain http
  --firewall        allow only ssh and http(s) with ufw
  --seed            ensure the mascot @niki exists (also on an existing database)
  -h, --help        show this help
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--domain) DOMAIN=$2; shift 2 ;;
		--email) EMAIL=$2; shift 2 ;;
		--repo) REPO=$2; shift 2 ;;
		--branch) BRANCH=$2; shift 2 ;;
		--no-ssl) SSL=no; shift ;;
		--firewall) FIREWALL=yes; shift ;;
		--seed) SEED=yes; shift ;;
		-h | --help) usage; exit 0 ;;
		*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
	esac
done

step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
note() { printf '    %s\n' "$*"; }
warn() { printf '\033[1;33m!!  %s\033[0m\n' "$*" >&2; }
as_app() { sudo -u "$APP_USER" -H bash -lc "cd '$APP_HOME' && $*"; }

trap 'warn "Deployment failed on line $LINENO"' ERR

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo $0" >&2; exit 1; }

if [[ -r /etc/os-release ]]; then
	# shellcheck source=/dev/null
	. /etc/os-release
	[[ "${ID:-}" == ubuntu && "${VERSION_ID:-}" == 26.04 ]] || warn "Made for Ubuntu 26.04, this is ${PRETTY_NAME:-unknown}"
fi

if [[ $SSL == yes ]]; then
	ORIGIN="https://$DOMAIN"
	[[ -n $EMAIL ]] || { echo "--email is required for Let's Encrypt (or use --no-ssl)" >&2; exit 1; }
else
	ORIGIN="http://$DOMAIN"
fi

step "System packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq \
	git curl ca-certificates gnupg openssl build-essential pkg-config rustc \
	libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev libreadline-dev libpq-dev \
	postgresql postgresql-contrib nginx certbot python3-certbot-nginx >/dev/null

if ! command -v node >/dev/null || (($(node -p 'process.versions.node.split(".")[0]') < 22)); then
	step "Node.js $NODE_MAJOR"
	curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - >/dev/null
	apt-get install -y -qq nodejs >/dev/null
fi
note "node $(node -v)"

step "User and directories"
if ! id -u "$APP_USER" >/dev/null 2>&1; then
	useradd --system --create-home --home-dir "$APP_HOME" --shell /bin/bash "$APP_USER"
fi
install -d -o "$APP_USER" -g "$APP_USER" -m 750 "$APP_HOME" "$STORAGE_DIR"
install -d -o "$APP_USER" -g "$APP_USER" -m 700 "$BUILD_TMP_DIR"
install -d -o root -g "$APP_USER" -m 750 "$ENV_DIR"

step "Code ($REPO, $BRANCH)"
if [[ -d $APP_DIR/.git ]]; then
	as_app "git -C '$APP_DIR' fetch --quiet origin '$BRANCH' && git -C '$APP_DIR' reset --quiet --hard 'origin/$BRANCH'"
else
	as_app "git clone --quiet --branch '$BRANCH' '$REPO' '$APP_DIR'"
fi
note "$(as_app "git -C '$APP_DIR' log -1 --format='%h %s'")"

step "Ruby"
RUBY_VERSION=$(tr -d '[:space:]' <"$APP_DIR/backend/.ruby-version")
if [[ ! -d $APP_HOME/.rbenv ]]; then
	as_app "git clone --quiet https://github.com/rbenv/rbenv.git ~/.rbenv"
	as_app "git clone --quiet https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build"
	as_app "echo 'eval \"\$(~/.rbenv/bin/rbenv init - bash)\"' >> ~/.bashrc"
else
	as_app "git -C ~/.rbenv/plugins/ruby-build pull --quiet"
fi
RBENV="$APP_HOME/.rbenv/bin/rbenv"
if ! as_app "$RBENV versions --bare | grep -qx '$RUBY_VERSION'"; then
	note "compiling ruby $RUBY_VERSION from source; this can take several minutes"
	note "temporary build files: $BUILD_TMP_DIR (requires free disk space)"
	note "build output follows; wait for completion (Ctrl+C interrupts deployment)"
	as_app "TMPDIR='$BUILD_TMP_DIR' RUBY_CONFIGURE_OPTS=--disable-install-doc $RBENV install -s -v '$RUBY_VERSION'"
fi
as_app "cd '$APP_DIR/backend' && $RBENV exec gem install bundler --conservative --no-document >/dev/null"

step "PostgreSQL"
systemctl enable --now postgresql >/dev/null
if [[ -z $(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname = '$APP_USER'") ]]; then
	sudo -u postgres createuser "$APP_USER"
fi
if [[ -z $(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'") ]]; then
	sudo -u postgres createdb --owner "$APP_USER" "$DB_NAME"
fi

step "Environment ($ENV_DIR)"
BACKEND_ENV=$ENV_DIR/backend.env
FRONTEND_ENV=$ENV_DIR/frontend.env
if [[ ! -f $BACKEND_ENV ]]; then
	cat >"$BACKEND_ENV" <<EOF
RAILS_ENV=production
SECRET_KEY_BASE=$(openssl rand -hex 64)
APP_ORIGIN=$ORIGIN
DATABASE_NAME=$DB_NAME
DATABASE_USER=$APP_USER
STORAGE_PATH=$STORAGE_DIR
PORT=$API_PORT
RAILS_MAX_THREADS=5
RAILS_LOG_LEVEL=info
MAIL_FROM="MySweetPlace <noreply@$DOMAIN>"
# SMTP_ADDRESS=smtp.example.com
# SMTP_PORT=587
# SMTP_USERNAME=
# SMTP_PASSWORD=
EOF
	note "created $BACKEND_ENV"
fi
sed -i "s|^APP_ORIGIN=.*|APP_ORIGIN=$ORIGIN|" "$BACKEND_ENV"

if [[ ! -f $FRONTEND_ENV ]]; then
	cat >"$FRONTEND_ENV" <<EOF
NODE_ENV=production
HOST=127.0.0.1
PORT=$WEB_PORT
ORIGIN=$ORIGIN
API_INTERNAL_URL=http://127.0.0.1:$API_PORT
ADDRESS_HEADER=X-Forwarded-For
XFF_DEPTH=1
# SEASON=winter
EOF
	note "created $FRONTEND_ENV"
fi
sed -i "s|^ORIGIN=.*|ORIGIN=$ORIGIN|" "$FRONTEND_ENV"
chown root:"$APP_USER" "$BACKEND_ENV" "$FRONTEND_ENV"
chmod 640 "$BACKEND_ENV" "$FRONTEND_ENV"

step "Backend"
note "installing gems one at a time to reduce peak memory use"
as_app "cd '$APP_DIR/backend' \
	&& $RBENV exec bundle config set --local deployment true \
	&& $RBENV exec bundle config set --local without 'development test' \
	&& TMPDIR='$BUILD_TMP_DIR' MAKEFLAGS=-j1 $RBENV exec bundle install --jobs 1 \
	&& set -a && . '$BACKEND_ENV' && set +a \
	&& $RBENV exec bin/rails db:prepare"
if [[ $SEED == yes ]]; then
	as_app "cd '$APP_DIR/backend' && set -a && . '$BACKEND_ENV' && set +a && $RBENV exec bin/rails db:seed"
fi

step "Frontend"
as_app "cd '$APP_DIR/frontend' && npm ci --no-audit --no-fund --loglevel=error && npm run build >/dev/null"

step "Services"
cat >/etc/systemd/system/$APP-backend.service <<EOF
[Unit]
Description=MySweetPlace api (Rails)
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR/backend
EnvironmentFile=$BACKEND_ENV
Environment=RBENV_ROOT=$APP_HOME/.rbenv
ExecStart=$RBENV exec bundle exec puma -C config/puma.rb
Restart=always
RestartSec=3
TimeoutStopSec=20
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/$APP-frontend.service <<EOF
[Unit]
Description=MySweetPlace web (SvelteKit)
After=network.target $APP-backend.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR/frontend
EnvironmentFile=$FRONTEND_ENV
ExecStart=$(command -v node) build
Restart=always
RestartSec=3
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/$APP-cleanup.service <<EOF
[Unit]
Description=MySweetPlace unused uploads cleanup

[Service]
Type=oneshot
User=$APP_USER
WorkingDirectory=$APP_DIR/backend
EnvironmentFile=$BACKEND_ENV
Environment=RBENV_ROOT=$APP_HOME/.rbenv
ExecStart=$RBENV exec bin/rails uploads:cleanup
EOF

cat >/etc/systemd/system/$APP-cleanup.timer <<EOF
[Unit]
Description=Daily MySweetPlace uploads cleanup

[Timer]
OnCalendar=daily
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable $APP-backend $APP-frontend $APP-cleanup.timer >/dev/null 2>&1
systemctl restart $APP-backend $APP-frontend
systemctl start $APP-cleanup.timer

step "nginx"
sed "s|__DOMAIN__|$DOMAIN|g; s|__API_PORT__|$API_PORT|g; s|__WEB_PORT__|$WEB_PORT|g" \
	"$APP_DIR/deploy/nginx.conf" >/etc/nginx/sites-available/$APP.conf
ln -sf /etc/nginx/sites-available/$APP.conf /etc/nginx/sites-enabled/$APP.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t -q
systemctl reload nginx

if [[ $SSL == yes ]]; then
	step "Let's Encrypt"
	if certbot --nginx --non-interactive --agree-tos --redirect -m "$EMAIL" -d "$DOMAIN" -d "www.$DOMAIN" --keep-until-expiring >/dev/null; then
		note "certificate is ready"
	else
		warn "certbot failed: check that $DOMAIN and www.$DOMAIN point to this server, then run the script again"
	fi
fi

if [[ $FIREWALL == yes ]]; then
	step "Firewall"
	apt-get install -y -qq ufw >/dev/null
	ufw allow OpenSSH >/dev/null
	ufw allow 'Nginx Full' >/dev/null
	ufw --force enable >/dev/null
fi

step "Health check"
healthy=yes
for _ in {1..30}; do
	curl -fsS "http://127.0.0.1:$API_PORT/up" >/dev/null 2>&1 && curl -fsS "http://127.0.0.1:$WEB_PORT/" >/dev/null 2>&1 && break
	sleep 2
done
for check in "api http://127.0.0.1:$API_PORT/up" "web http://127.0.0.1:$WEB_PORT/"; do
	if curl -fsS "${check#* }" >/dev/null 2>&1; then
		note "${check%% *}: ok"
	else
		warn "${check%% *} is not responding"
		healthy=no
	fi
done

cat <<EOF

MySweetPlace is deployed: $ORIGIN

  settings:  $BACKEND_ENV, $FRONTEND_ENV
  uploads:   $STORAGE_DIR
  logs:      journalctl -u $APP-backend -f
             journalctl -u $APP-frontend -f
  update:    sudo $APP_DIR/deploy/deploy.sh --domain $DOMAIN${EMAIL:+ --email $EMAIL}$([[ $SSL == no ]] && echo " --no-ssl")
EOF

[[ $healthy == yes ]]
