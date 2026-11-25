# System Map

This is the canonical inventory of MediaBox components, repository evidence, and the questions that still require inspection of the Raspberry Pi. It describes what this checkout records or intends to run; it does not prove that a service is installed, enabled, or healthy on the live device. For local-only or secret-bearing details, see [secret-boundaries.md](secret-boundaries.md).

## How to read this map

- **Repository representation** means a Compose file, launcher, service unit, or documentation entry exists in this checkout.
- **Deployment status** is separate. Unless a current Pi inspection proves otherwise, it remains unknown.
- A historical note can preserve a useful observation without being current operating authority.
- An absent definition does not prove that a service is absent from the Pi.

The documented system is a hybrid: host networking and selected host services sit alongside external companion checkouts and several checked-in Docker scaffolds.

## Current remediation verification (2026-11-24)

This section records the completed storage reliability phase and supersedes older deployment-status questions where the rows below provide newer evidence.

| Subject | Verified live state |
|---------|---------------------|
| Docker logging | The daemon default is `local`, capped at 10 MB × 3 files. Crafty, Ollama, AnythingLLM, Navidrome, Gluetun, qBittorrent, Lidarr, Prowlarr, Gluetun WebUI, and Aurral were recreated with those limits. Dashy, VeraCrypt, Jellyfin, File Browser, and Beszel still use `json-file`; their live definitions were divergent, unmanaged, or deferred. |
| External-storage services | F-Droid, Kiwix, Shoko, and Diskover remain stopped with automatic restart disabled. Shoko's guard units are prepared but not installed: the expected filesystem UUID and device names remain unverified. Direct Docker start or an explicit `external-storage` profile can bypass the guard. |
| PowerGuard and PM2 logs | PowerGuard is a single active systemd service; neither saved PM2 process list contains its prior duplicate. PM2 log rotation is enabled on a five-minute timer. |
| NVMe monitoring | The daily SMART snapshot timer is enabled and a current sample was recorded successfully. Its root-only history is operational monitoring, not a disk diagnosis. |
| Music discovery | Aurral's Lidarr connection test succeeded through the existing host route. Lidarr and Aurral see the same generated-download directory; Lidarr, Prowlarr, and qBittorrent remain in Gluetun's network namespace. |
| Crafty / Minecraft | Crafty is healthy. The affected server's prior Discord-MC-Chat token and channel values were restored from its known-good backup, and a dedicated `/home/crafty` bind is available to the Java child user. Server startup still needs verification through Crafty because it is not auto-started. |
| Beszel alerts | Alert configuration and notification delivery were deferred. |

The Docker daemon restart interrupted running containers briefly; the daemon and managed services recovered. No external-storage transfer, filesystem repair, disk stress test, or physical drive change was performed. See [storage operations](../ops/storage/README.md), [Docker logging](../ops/docker/README.md), and [PM2 rotation](../ops/pm2/README.md) for deployment and rollback details.

## Current Mission Control observer evidence (2026-09-16)

The following is a bounded read-only observation of the registered host. It is current evidence for the selected observer resources, not a replacement for a full host inventory. The observer returned no repository contents, command output, logs, secrets, or unrestricted paths.

| Subject | Evidence classification | Current evidence |
|---------|------------------------|------------------|
| Live host identity | **Confirmed live** | `host.summary` reported hostname `mediabox`, Debian GNU/Linux 12 (bookworm), kernel `6.12.93+rpt-rpi-2712`, and `aarch64`. |
| Registered repository resource | **Confirmed live** | `repo.status` completed successfully for `repo:mediabox`; the controlled resource mapping is `/home/jordan/MediaBox`. |
| Current Git branch and revision | **Confirmed live** | The registered checkout is on branch `main` at revision `daea4727e6528542e084ff30e8d5510309ee62da`. |
| Current checkout cleanliness | **Confirmed live** | The registered checkout is dirty; 51 changed files were reported. Changed filenames were intentionally not collected. |
| `/home/jordan/MediaBox` authority | **Inference** | The observer's `repo:mediabox` resource is configured to this path and the operation succeeded, but `repo.status` intentionally returns the resource ID rather than an absolute path. |
| `/opt/mediabox` current relevance | **Unresolved** | The registered repository observation does not discover other checkouts or prove whether the historical `/opt/mediabox` path exists or is active. |
| Selected storage | **Confirmed live** | `storage.summary` exposed only `/` on `/dev/nvme0n1p2`, with capacity `1007674732544` bytes and `95805628416` bytes available. |
| Application persistence and backups | **Unresolved** | The selected storage result does not identify application data placement, backup jobs, archives, or restore health. |
| `eth0` state | **Confirmed live** | `network.summary` reported `eth0` present but `down`, with no addresses returned. |
| Hotspot topology | **Unresolved** | The observer does not expose routes, listeners, firewall/NAT state, Wi-Fi, hotspot behavior, or VPN topology. |
| Systemd service state | **Unresolved** | `systemd.summary` completed with an empty result because the `service:mediabox` allowlist is intentionally empty. This is not evidence that no services are installed or running. |
| `mediabox-hotspot-landing.service` live state | **Unresolved** | The repository path conflict remains documented; no service unit was authorized for live inspection. |
| Docker/Compose runtime | **Unresolved** | Compose files remain repository representation only; this observer has no Docker capability. |
| PM2 runtime | **Unresolved** | No PM2 operation is exposed by the observer. |
| Timers, boot behavior, and logs | **Unresolved** | These are outside the current typed observer contract. |

The live Git revision and dirty state above do not by themselves establish whether the checkout matches a historical working checkpoint. The observer confirms the selected checkout only; it does not search for stale or alternate deployments. Likewise, the `eth0` result does not contradict the existence of a documented hotspot design, but it does not provide current evidence that the design is active.

## App and source repositories

| Category | Repository evidence | Deployment question |
|----------|---------------------|---------------------|
| MediaBox repository | The repository is documented as `~/MediaBox`. | Verify the actual checkout path. The hotspot unit separately hard-codes `/opt/mediabox`. |
| Host-local companion checkouts | `~/anythingllm`, `~/dashy`, `~/chatbot`, `~/Kavita`, `~/NavidroFM`, `~/noVNC`, `~/shoko`, and `~/webretro` are named in the historical system map. | Verify which checkouts exist, their revisions, and which services start from them. None are included here. |

## Host networking and services

| Component | Intended role | Repository representation | Deployment status / verification needed |
|-----------|---------------|---------------------------|-----------------------------------------|
| Hotspot and landing path | RaspAP, hostapd, dnsmasq, nginx, and an iptables redirect provide the `wlan1` access point and route port 80 toward Dashy. | [Hotspot README](../ops/hotspot/README.md), [landing script](../ops/hotspot/apply-landing.sh), and [systemd unit](../ops/hotspot/mediabox-hotspot-landing.service). | The intended addresses and interface are documented. Verify installed services, interface state, firewall rules, and whether the unit is enabled. |
| PM2 services | The historical inventory names `novnc-vnc`, `pi-powerguard`, `webretro`, and `opencode`. | The PM2 list is documented here; only [OpenCode's PM2 config](../ops/opencode/ecosystem.config.cjs) and launcher are checked in. | Verify which processes exist, how PM2 starts at boot, and whether Webretro is still host-served or has moved to the container scaffold below. |
| systemd services | The historical inventory names `kavita`, `kolibri`, and `openwebrx`. | Names are documented here; their unit files are not in this checkout. | Verify installed units, enablement, source paths, and current state. |
| Swap and memory policy | The recorded host used an NVMe-backed `/swapfile`; the checked-in target adds zram above it. | [Recorded swap note](swap.md) and [zram scaffold](../ops/swap/README.md). | The note records an earlier inspection. Verify current swap, zram, sysctl values, and whether the target was applied. |

The hotspot unit currently executes `/opt/mediabox/ops/hotspot/apply-landing.sh`, while the repository documentation commonly uses `~/MediaBox`. This is an unresolved deployment-path conflict, not a decision about which path should win.

## Checked-in Docker scaffolds

Each row means that the repository contains a Compose definition. It does not mean the stack is deployed on the Pi.

| Stack / service | Intended role and documented runtime details | Repository evidence | Deployment status / verification needed |
|-----------------|----------------------------------------------|---------------------|-----------------------------------------|
| Diskover and Elasticsearch | File inventory and search on port `8097`; read-only scan mounts; requires `vm.max_map_count=262144`. | [ops/diskover](../ops/diskover/README.md) and [compose.yml](../ops/diskover/compose.yml). | Scaffold only. Verify host preparation, state directories, and whether scans have been configured. |
| F-Droid repository | Read-only nginx serving on port `8070`, with the repository at `/fdroid/`; sync/update remains host-side in the documentation. | [ops/fdroid-repo](../ops/fdroid-repo/README.md), [compose.yml](../ops/fdroid-repo/compose.yml), and [F-Droid notes](fdroid_readme.md). | Repository representation is present. Verify the repo contents, signing material, sync job, and whether Docker replaced the historical server. |
| File Browser | File management on port `7050`, with a host database and content root. | [ops/filebrowser](../ops/filebrowser/README.md) and [compose.yml](../ops/filebrowser/compose.yml). | The scaffold describes a Docker target. Verify the actual database path and whether the old PM2 process is stopped. |
| Gluetun, WebUI, and qBittorrent | VPN gateway with WebUI on `3000` and qBittorrent WebUI on `8098`; qBittorrent shares Gluetun's network namespace. | [ops/gluetun](../ops/gluetun/README.md) and [compose.yml](../ops/gluetun/compose.yml). | Scaffold only. Verify the WireGuard file, local state, container attachment, VPN readiness, and exposed interfaces. |
| Jellyfin | Media streaming on port `8096`, with a named config volume and read-only media mounts. | [ops/jellyfin](../ops/jellyfin/README.md) and [compose.yml](../ops/jellyfin/compose.yml). | Migration scaffold. Verify the active server, library paths, Shoko integration, and whether any prior host service remains. |
| Kiwix | Offline ZIM archive server on port `9191`; startup waits for archives and updates `library.xml`. | [ops/kiwix](../ops/kiwix/README.md), [compose.yml](../ops/kiwix/compose.yml), and [start-kiwix.sh](../ops/kiwix/start-kiwix.sh). | Migration scaffold. Verify archive location, library state, and the active startup mechanism before changing anything. |
| Music discovery: Lidarr, Aurral, and Prowlarr | Discovery and import-review lane on ports `8686`, `3002`, and `9696`, with separate state and media paths. | [ops/music-discovery](../ops/music-discovery/README.md) and [compose.yml](../ops/music-discovery/compose.yml). | Starter scaffold, explicitly not the full acquisition workflow. Verify state paths, provider credentials, and integration with qBittorrent. |
| Ollama | Shared local model runtime on loopback port `11434`, with model data under `/var/lib/ollama`. | [ops/ollama](../ops/ollama/README.md) and [compose.yml](../ops/ollama/compose.yml). | Verify whether this container is deployed, which models exist, and whether AnythingLLM/OpenCode use it. |
| Shoko | Anime metadata and library service on port `8111`, with host state and media mounts. | [ops/shoko](../ops/shoko/README.md) and [compose.yml](../ops/shoko/compose.yml). | Verify the active checkout/container, settings file, credentials, and Jellyfin integration. |
| Webretro | Static retro-game web assets on port `8085`. | [ops/webretro](../ops/webretro/README.md), [compose.yml](../ops/webretro/compose.yml), and [nginx.conf](../ops/webretro/nginx.conf). | The repository contains a container scaffold while the host PM2 inventory still names `webretro`. Verify which runtime is active; do not infer that migration is complete. |

The Compose files generally define restart policies and healthchecks. These are configuration features only: `docker compose config` validates syntax and interpolation, not ARM compatibility, successful startup, health, or deployment.

## Documented services without checked-in runtime definitions

The following services appear in the recorded system inventory or device manual but have no service definition in this checkout: Dashy, AnythingLLM, ROMM, Navidrome, NavidroFM, Filebot, Beszel, Beszel Agent, Crafty, Kavita, Kolibri, OpenWebRX, noVNC, and the lighter chat UI. Their absence here may reflect external checkouts or host-local configuration rather than removal from MediaBox.

Verify each service's actual source, revision, startup mechanism, ports, persistent state, and migration status on the Pi.

## Persistent data and configuration model

The repository separates runtime state from checked-in definitions, but the exact live paths are not established.

| Data category | Repository examples | What must be supplied or verified |
|---------------|---------------------|-----------------------------------|
| Service state | Compose-local `./data` trees, Jellyfin's `jellyfin-data` volume, `/var/lib/ollama`, `/var/opt/minecraft/crafty/crafty-4`, and recorded roots such as `<service-state-root>/DiskoverData/{config,esdata}` and `<service-state-root>/MusicData/{lidarr,aurral,prowlarr,qbittorrent}`. | Which paths hold the live databases and whether they are backed up. |
| Media and archives | `<media-root>/library`, `Music`, `MusicInbox`, `MusicAurral`, `KiwixArchives`, Anime, Incoming, and the Compose-local media/archive mounts. | Actual mount points, ownership, capacity, and library compatibility. |
| Local configuration | Recorded examples include `~/anythingllm/storage`, `~/Kavita/config`, `~/dashy/user-data/conf.yml`, `~/shoko/Shoko.CLI/settings-server.json`, `~/anythingllm/docker-compose.yml`, `~/shoko/docker-compose.yml`, and `~/start_vnc.sh`. | Which checkout/configuration is authoritative. These are examples from repository records, not verified current paths. |
| Cache and logs | Recorded examples include `~/.cache/jellyfin`, `~/.local/share/jellyfin/log`, `~/beszel/beszel_agent_data`, `~/beszel/beszel_data`, `~/webretro/assets`, and `/var/log`. | Which paths are active, how fast they grow, and whether they are included in backups. |
| Secrets and credentials | OpenCode environment/config, F-Droid signing material, provider credentials, and Gluetun's WireGuard file. | Presence and safe handling; do not export or publish secret contents. |

A clean checkout provides documentation, Compose files, a few host launchers, and examples. It does not provide runtime data, media, databases, secrets, companion repositories, host packages, or proof that the documented paths exist. See [secret-boundaries.md](secret-boundaries.md) before adding local configuration.

## Future Pi inspection checklist

Collect the following read-only facts, reviewing output locally for secrets before sharing:

1. Service inventory: `docker compose ls`, selected `docker ps` fields, `systemctl list-unit-files --state=enabled`, and `pm2 list`.
2. Source identity: deployed Compose file paths, repository revisions, image names/IDs, and companion checkout revisions.
3. Boot behavior: Docker enablement, PM2 startup configuration, enabled systemd units, and hotspot unit status.
4. Storage: mount points, filesystem usage, and narrowly selected container mount sources for known services.
5. Network: interfaces, addresses, listeners, firewall rules, hotspot state, and VPN/container network attachment.
6. Health/resources: container health, uptime, RAM, disk, swap/zram, and the relevant recent service status or log summaries.
7. Recovery: names and timestamps of existing backup jobs or archives, without dumping their contents or credentials.

Do not collect indiscriminate environment dumps, PM2 environment exports, raw Docker inspection output, or broad logs. Restarting, updating, migrating, changing firewall/swap settings, and testing restores are separate mutating actions requiring explicit approval.

## Swap record

The historical swap details are maintained in [swap.md](swap.md). Treat its “current” wording as a recorded observation until the live host is inspected.
