# Webretro Runtime Scaffold

This folder contains the container runtime scaffold for `webretro`.

It keeps the service simple:

- mount a local asset checkout
- preserve the `8085` port
- keep permissive CORS-style headers
- add a container healthcheck for the web UI

## Files

- [compose.yml](compose.yml)
- [nginx.conf](nginx.conf)

## Root and Port

The scaffold expects a local asset checkout and preserves port `8085`.

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

## Notes

- Keep the assets mounted so the runtime stays generic and easy to reproduce.
- If the current front end needs different cache or CORS behavior later, adjust the nginx config rather than baking those changes into a custom image.
- The PM2 wrapper was a plain `http-server` invocation, so the Docker version stays intentionally small.
- The repository still records `webretro` in the historical PM2 service list. Verify whether the host process or this container is active; this scaffold does not establish that migration is complete.
