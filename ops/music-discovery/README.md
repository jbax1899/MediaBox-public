# Music Discovery Runtime Scaffold

This folder contains the starter container runtime for the missing-music discovery lane.

It keeps the first pass limited to:

- `lidarr` for artist and album management
- `prowlarr` for indexer management and Lidarr sync
- `aurral` for discovery and flow generation
- read-only access to local media roots
- separate host paths for config, inbox, and generated discovery output

## Files

- [compose.yml](compose.yml)

## Paths

- the owned library stays separate from staged imports
- the inbox is reserved for later staged imports
- generated discovery output stays in its own folder
- Lidarr, Aurral, and Prowlarr each keep their own state directory
- Lidarr publishes on host port `8686`
- Prowlarr publishes on host port `9696`

## Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

Prowlarr and Lidarr stay on the normal Docker network.

By default Aurral publishes on host port `3002` if `3001` is already taken.
When connecting Aurral to Lidarr, use `http://lidarr:8686` from inside Aurral.
When connecting Prowlarr to Lidarr, use `http://lidarr:8686` and `http://prowlarr:9696`.
When Lidarr connects to qBittorrent, use `http://host.docker.internal:8098` from inside the container.
Use the current qBittorrent WebUI password, not any temporary first-boot credential.

## Notes

- This is scaffolding, not the full acquisition workflow.
- Keep acquisition automation, ListenBrainz, and Ticketmaster out of the first pass.
- Keep secrets and provider credentials in local host config, not in git.
- Prowlarr manages indexers only; use the Gluetun-backed qBittorrent stack for peer-to-peer acquisition.
