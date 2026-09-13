# Kiwix Runtime Scaffold

This folder contains the containerized runtime scaffold for `kiwix-serve`.

It keeps the service simple:

- wait for the archive mount
- ensure `library.xml` exists
- add any new `*.zim` files to the library
- start the HTTP server on port `9191`

## Files

- [Dockerfile](Dockerfile)
- [compose.yml](compose.yml)
- [start-kiwix.sh](start-kiwix.sh)

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d --build
```

The container expects the archive directory to be mounted from a local host path you control.

## Notes

- This is the Docker migration scaffold for the Kiwix service.
- Do not remove or stop any prior host service until live validation confirms that this container has replaced it.
- If a maintained upstream Kiwix image becomes the better fit later, swap it into this scaffold and keep the startup contract intact.
