# Secret Boundaries

This doc tracks the kinds of local-only and secret-bearing details MediaBox uses. Keep the exact host inventory out of the public repo.

## Repo-Resident Files

These files are safe to commit because they reference local-only state but do not contain secrets themselves.

- `ops/opencode/start-opencode-web.sh` - launcher that sources a local env file at runtime
- `ops/opencode/README.md` - runtime note that points to local OpenCode credentials
- `ops/opencode/ecosystem.config.cjs` - PM2 config with no secret material
- `ops/ollama/compose.yml` - shared Ollama runtime definition
- `ops/ollama/README.md` - shared Ollama runtime note
- `ops/gluetun/compose.yml` - Proton VPN gateway runtime scaffold
- `ops/gluetun/.env.example` - placeholder Proton WireGuard env example with no secrets
- `ops/gluetun/config.toml.example` - placeholder local control config example
- `ops/diskover/compose.yml` - Diskover CE runtime scaffold with local-only storage mounts
- `ops/diskover/README.md` - Diskover CE runtime note and host setup steps
- `ops/storage/` - storage guard scripts and units; expected UUIDs, devices, and the live Compose path stay in the host-only environment file
- `ops/powerguard/` and `ops/pm2/` - host service and log rotation definitions without credentials
- `ops/docker/daemon.json` - bounded Docker logging defaults

## Local-Only Files

These are examples of files and data roots that should stay on the host. Do not publish the exact host inventory in this repo.

- Local env files and client configs for dashboards, AI tools, and VPNs
- Service databases, caches, logs, and generated state
- Signing material, API keys, tokens, and wireguard/private network credentials
- Media/library roots, mirror roots, and scan roots that exist only on the host
- Any runtime compose file that contains private settings or host-specific mounts
- Any troubleshooting note that captures private host state

## Local-Only Documentation

- Keep private troubleshooting notes outside the public repo
- Keep local-only Gluetun control config outside the public repo
