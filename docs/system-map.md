# System Map

This doc tracks the current app/source repos, runtime paths, and service ownership for MediaBox. For local-only or secret-bearing details, see [secret-boundaries.md](secret-boundaries.md).

## App/Source Repos

| Category | Examples |
|----------|----------|
| MediaBox repo | `~/MediaBox` |
| Host-local companion checkouts | `~/anythingllm`, `~/dashy`, `~/chatbot`, `~/Kavita`, `~/NavidroFM`, `~/noVNC`, `~/shoko`, `~/webretro` |

## Checked-In Service Scaffolds

| Path |
|------|
| `~/MediaBox/ops/opencode` |
| `~/MediaBox/ops/webretro` |
| `~/MediaBox/ops/gluetun` |
| `~/MediaBox/ops/filebrowser` |
| `~/MediaBox/ops/diskover` |
| `~/MediaBox/ops/ollama` |
| `~/MediaBox/ops/swap` |
| `~/MediaBox/ops/fdroid-repo` |
| `~/MediaBox/ops/kiwix` |
| `~/MediaBox/ops/jellyfin` |
| `~/MediaBox/ops/music-discovery` |

## Runtime/Config Directories

| Category | Examples |
|----------|----------|
| App state and configs | `~/anythingllm/storage`, `~/Kavita/config`, `~/dashy/user-data/conf.yml`, `~/shoko/Shoko.CLI/settings-server.json`, `~/filebrowser.db` |
| Cache and logs | `~/.cache/jellyfin`, `~/.local/share/jellyfin`, `~/.local/share/jellyfin/log`, `~/beszel/beszel_agent_data`, `~/beszel/beszel_data`, `~/webretro/assets` |
| Local compose and launcher files | `~/anythingllm/docker-compose.yml`, `~/anythingllm/.env`, `~/anythingllm/storage/.env`, `~/shoko/docker-compose.yml`, `~/start_vnc.sh` |
| Media and archive roots | `<media-root>/library`, `<media-root>/Music`, `<media-root>/MusicInbox`, `<media-root>/MusicAurral`, `<media-root>/MusicData`, `<archive-root>/KiwixArchives`, `<storage-root>/fdroid`, `<storage-root>/Anime`, `<storage-root>/Incoming` |
| Service state roots | `<service-state-root>/DiskoverData/config`, `<service-state-root>/DiskoverData/esdata`, `<service-state-root>/MusicData/lidarr`, `<service-state-root>/MusicData/aurral`, `<service-state-root>/MusicData/prowlarr`, `<service-state-root>/MusicData/qbittorrent`, `/var/lib/ollama`, `/var/opt/minecraft/crafty/crafty-4`, `/var/log` |

## Docker Volumes

| Volume | Notes |
|--------|-------|
| `jellyfin-data` | Jellyfin config volume mounted at `/config` |

## Swap

Current swap behavior is documented in [swap.md](swap.md).

| Path | Notes |
|------|-------|
| `/swapfile` | Live 8 GiB swapfile on the NVMe-backed root filesystem. |
| `/etc/fstab` | Mounts and activates `/swapfile` at boot. |
| `/etc/dphys-swapfile` | Installed package config; currently sets `CONF_SWAPSIZE=4096`, which does not match the live file size. |
| `/etc/sysctl.d/99-swappiness.conf` | Sets `vm.swappiness=10`. |

## Host Services

### PM2 Services

| Service |
|---------|
| `novnc-vnc` |
| `pi-powerguard` |
| `webretro` |
| `opencode` |

### Systemd Services

| Service |
|---------|
| `kavita` |
| `kolibri` |
| `openwebrx` |

## Docker Services

| Service |
|---------|
| `dashy` |
| `anythingllm` |
| `ollama` |
| `romm` |
| `navidrome` |
| `NavidroFM` |
| `filebot` |
| `shoko` |
| `gluetun` |
| `gluetun-webui` |
| `prowlarr` |
| `qbittorrent` |
| `beszel` |
| `beszel-agent` |
| `crafty` |
| `filebrowser` |
| `kiwix-serve` |
| `jellyfin` |
| `fdroid-repo` |
