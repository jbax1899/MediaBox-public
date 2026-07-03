# Shoko Docker Compose Configuration

This folder keeps the checked-in reference shape for the container.

## Files

- [compose.yml](compose.yml)

## Runtime Notes

The live container:

```bash
docker compose -f compose.yml up -d
```

The active runtime:

- Mounts the existing host state tree from a local `./data` directory
- Publishes Shoko on host port `8111`
- Reads the existing credentials from a local `settings-server.json` file
- Should be reached from Jellyfin with `http://host.docker.internal:8111`
- The compose file invokes `/bin/bash /docker-entrypoint.sh` because this image tag ships that script without execute permission.
