# Jellyfin Runtime Scaffold

This folder contains the container runtime scaffold for `jellyfin`.

It keeps the service simple:

- keep Jellyfin config in a named Docker volume
- keep cache on the host or in a local cache directory
- mount media roots read-only at stable in-container paths
- expose the web UI on port `8096`
- add a container healthcheck for the web UI

## Files

- [compose.yml](compose.yml)

## Media Roots

The scaffold expects you to point it at your own local media roots.

Mount those roots read-only at stable in-container paths so the existing Jellyfin library entries still resolve after the cutover.

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

## Notes

- This is the migration scaffold for the Jellyfin service.
- Do not remove or stop any prior host service until live validation confirms that this container has replaced it.
- If the upstream image or healthcheck command needs adjustment during validation, keep the runtime contract the same and change only the image-specific detail.
- The `jellyfin-data` volume holds the config and database state; the host bind mount only keeps cache and media roots visible to the container.
- Configure the Shokofin plugin to use `http://host.docker.internal:8111` so Jellyfin talks to the live Shoko container on the host bridge.
