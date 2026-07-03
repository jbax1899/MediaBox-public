# Gluetun Runtime Scaffold

This folder contains the container runtime scaffold for the Proton VPN lane.

It keeps the phase-1 shape simple:

- run Gluetun as a standalone VPN gateway
- keep the WireGuard config file on the host
- keep qBittorrent as the first routed consumer
- expose the Gluetun WebUI on host port `3000` while keeping the control API inside the Docker network

## Files

- [compose.yml](compose.yml)
- [.env.example](.env.example)
- [config.toml.example](config.toml.example)

## Host Paths

The scaffold uses explicit host bind mounts so runtime state stays visible and backup-friendly:

- a local Gluetun state directory

Local-only runtime files should stay on the host:

- the WireGuard config file used by the VPN lane
- the local Gluetun control config

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

## Notes

- This is the initial VPN scaffold, not the full routed music stack.
- qBittorrent is the first consumer in this compose file and shares Gluetun's network namespace.
- gluetun-webui is the dashboard for the VPN gateway; it talks to `http://gluetun:8000` and is published on host port `3000` on all host interfaces.
- Keep any other consumer services out of this compose file until they are explicitly added.
- qBittorrent's WebUI is published on host port `8098`; its state lives in a local qBittorrent state directory.
- If you add a Dashy tile for gluetun-webui, point it at `http://10.0.0.1:3000` or the MediaBox host IP on your LAN.
- If you add a Dashy tile for qBittorrent, point it at `http://10.0.0.1:8098` or the MediaBox host IP on your LAN.
- The Gluetun runtime reads the local Proton WireGuard `.conf` directly and mounts it as `/gluetun/wireguard/wg0.conf`.
- Generate or refresh the config in the Proton account portal under Downloads -> WireGuard configuration.
- Keep the local `.conf` out of git; use the host-only file as the source of truth.
