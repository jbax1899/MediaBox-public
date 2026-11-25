# Docker logging

Use Docker's `local` driver with 10 MB files and three retained files. The daemon settings are in [daemon.json](daemon.json). Existing containers keep their logging configuration until recreated. Use `docker logs` rather than reading the driver's internal files.

## Deployment

- Back up the existing daemon configuration before applying the default. A Docker restart interrupts running containers unless live-restore is enabled.
- Check the live Compose files, mounts and networks before recreating a service. Keep host-specific overrides in the root-only `/etc/mediabox-storage/compose-overrides` directory.
- Save any needed log excerpts privately, then recreate one service at a time with `--no-deps` and `--pull never`. Leave suspended services stopped.

Gluetun is an exception: stop qBittorrent, Lidarr and Prowlarr before recreating the gateway. Wait for VPN readiness, then recreate all three clients so they join the new network namespace. Refresh the WebUI if needed. Follow the same order during rollback.

## Rollback

Restore the previous daemon configuration (or remove the new file if none existed) and restart Docker. To revert a service-specific change, restore its previous Compose settings and recreate it without pulling images or starting dependencies. Restoring the daemon defaults does not change existing containers.

See the [system map](../../docs/system-map.md) for the current rollout status.
