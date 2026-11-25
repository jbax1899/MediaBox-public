# Docker logging

`daemon.json` sets the `local` logging driver with 10 MB files and three retained files as the live Docker default. Existing containers keep their current driver until they are recreated with an explicit Compose logging setting.

For live services whose Compose source diverges from this checkout, keep the mount and network reconciliation in root-only host overrides under `/etc/mediabox-storage/compose-overrides`; do not replace the dirty MediaBox checkout with this scaffold. Recreate one service at a time with its recorded Compose files, `--no-deps`, and `--pull never`. Save a short root-only log tail first. Leave suspended services stopped; their prepared per-service logging takes effect on their next deliberate start.

The live daemon was restarted on 2026-11-24. Crafty, Ollama, AnythingLLM, Navidrome, Gluetun, qBittorrent, Lidarr, Prowlarr, Gluetun WebUI, and Aurral were recreated with `local` logging capped at 10 MB × 3. qBittorrent, Lidarr, and Prowlarr still share Gluetun's network namespace. Crafty also has a narrow `/home/crafty` bind for its Java child process. F-Droid, Kiwix, Shoko, and Diskover remain stopped with restart disabled.

Dashy, VeraCrypt, Jellyfin, File Browser, and the Beszel hub and agent still use `json-file`; their live Compose source was divergent, unmanaged, or deferred, so they were not recreated. Suspended containers also retain their existing driver until a controlled Compose start. Do not blindly apply the repository Compose scaffolds to these live services.

Restarting Docker applies the daemon default and interrupts running containers unless live-restore is enabled. The brief restart on 2026-11-24 was followed by service recovery; the daemon reported `local` as its default. The daemon default alone does not convert existing containers.

## Rollback

Before the restart, `/etc/docker/daemon.json` did not exist. If the daemon fails to start after a logging change, remove only the newly added file and restart Docker; this restores the prior daemon default. That does not change the logging driver stored on already-created containers. Revert a per-service override only after saving the current live Compose source and mounts; recreate just that service with image pulls and dependency recreation disabled. Root-only pre-recreation log tails are kept in the host's storage evidence directory.
