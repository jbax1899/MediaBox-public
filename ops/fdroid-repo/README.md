# F-Droid Repo Runtime Scaffold

This folder contains the container runtime scaffold for `fdroid-repo`.

It keeps the service simple:

- keep the repo data on the host
- serve the repo read-only
- expose the repo on port `8070`
- keep the sync/update job outside the serving container
- add a container healthcheck for the published directory listing
- preserve the `/fdroid/` directory-listing path

## Files

- [compose.yml](compose.yml)
- [nginx.conf](nginx.conf)

## Repo Root

The target repo root is a local `repo/` directory that you mount read-only into the serving container.

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

## Notes

- Keep the sync/update job outside the serving container until the migration finishes.
- If the published path needs to stay `/fdroid`, keep the nginx alias in place rather than changing the repo layout.
- If CORS needs to change later, adjust the nginx config without moving the content root.
- The current live service returns `404` at `/` and `/fdroid`, and `200` at `/fdroid/`.
