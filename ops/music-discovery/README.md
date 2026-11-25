# Music discovery

[compose.yml](compose.yml) contains the reference stack: Lidarr for library management, Prowlarr for indexers and Aurral for discovery. Keep the owned library separate from staged imports and generated downloads. Each service has its own state directory.

## Networking

On MediaBox, Lidarr, Prowlarr and qBittorrent share Gluetun's network namespace. Keep that isolation when changing the deployment; the reference Compose file alone does not reproduce the live VPN setup.

- From Aurral, use `http://host.docker.internal:8686` to reach Lidarr through Gluetun's existing host port. Do not publish an additional port. A standalone Compose setup on a common network can use `http://lidarr:8686` instead.
- Use the existing qBittorrent endpoint from Lidarr. The standalone Compose setup uses `http://host.docker.internal:8098`. Keep the live namespace configuration unchanged unless it needs correction.
- Aurral's default host port is `3002`; Lidarr and Prowlarr use `8686` and `9696`.

For a standalone setup only, run `docker compose -f compose.yml up -d` from this directory. Prowlarr can reach Lidarr at `http://lidarr:8686`; its own endpoint is `http://prowlarr:9696` on that network. Do not use this startup command to replace MediaBox's Gluetun-backed deployment.

## Downloads

Aurral and Lidarr must see the same generated-download directory at `/app/downloads`. Align their host bind mounts; use a Lidarr remote path mapping if different container paths are necessary.

Keep provider credentials in local configuration. Use the current qBittorrent WebUI password, not a first-boot credential. Acquisition automation, ListenBrainz and Ticketmaster are outside this scaffold's scope. Prowlarr manages indexers only; use the Gluetun-backed qBittorrent stack for peer-to-peer acquisition.
