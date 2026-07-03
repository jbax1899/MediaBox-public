#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "Run this script as root." >&2
  exit 1
fi

nginx_site="/etc/nginx/sites-available/default"
nginx_link="/etc/nginx/sites-available/mediabox"
iptables_rules="/etc/iptables/rules.v4"

cat > "$nginx_site" <<'EOF'
##
# Default server configuration for the MediaBox hotspot landing page.
#

server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;
	server_name _;

	location / {
		default_type text/html;
		return 200 '<html><head><meta http-equiv="refresh" content="0; url=http://10.0.0.1:4000"></head><body><p>If you are not redirected, <a href="http://10.0.0.1:4000">click here</a>.</p></body></html>';
	}
}
EOF

ln -sf "$nginx_site" "$nginx_link"

if [[ -f "$iptables_rules" ]]; then
  perl -0pi -e 's/--to-ports 4050/--to-ports 4000/g' "$iptables_rules"
fi

if command -v iptables >/dev/null 2>&1; then
  if iptables -t nat -C PREROUTING -i wlan1 -p tcp --dport 80 -j REDIRECT --to-ports 4050 2>/dev/null; then
    iptables -t nat -D PREROUTING -i wlan1 -p tcp --dport 80 -j REDIRECT --to-ports 4050
  fi
  if ! iptables -t nat -C PREROUTING -i wlan1 -p tcp --dport 80 -j REDIRECT --to-ports 4000 2>/dev/null; then
    iptables -t nat -I PREROUTING 1 -i wlan1 -p tcp --dport 80 -j REDIRECT --to-ports 4000
  fi
fi

if command -v nginx >/dev/null 2>&1; then
  nginx -t
  systemctl reload nginx
fi

if command -v netfilter-persistent >/dev/null 2>&1; then
  netfilter-persistent reload
fi
