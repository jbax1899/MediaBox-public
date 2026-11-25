# Shoko Docker Compose Configuration

This folder keeps the checked-in reference shape for the container.

## Files

- [compose.yml](compose.yml)

## Runtime Notes

The live container:

```bash
docker compose -f compose.yml up -d
```

The checked-in Compose file places Shoko behind the `external-storage` profile and uses `restart: "no"`; Shoko should be started by the host-side guard unit only after the required filesystem is mounted and its UUID passes the preflight. The live deployment uses a separate machine-local Compose file whose path belongs in the root-only guard environment file. Its paths and profile are aligned, while the actual filesystem UUID still needs confirmation before installing the guard unit.

The active runtime:

- Mounts the existing host state tree from a local `./data` directory
- Publishes Shoko on host port `8111`
- Reads the existing credentials from a local `settings-server.json` file
- Should be reached from Jellyfin with `http://host.docker.internal:8111`
- The compose file invokes `/bin/bash /docker-entrypoint.sh` because this image tag ships that script without execute permission.
