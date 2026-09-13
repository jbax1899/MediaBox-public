# File Browser Runtime Scaffold

This folder contains the container runtime scaffold for `filebrowser`.

It keeps the service simple:

- mount a local content root
- preserve the File Browser database on the host
- expose the UI on port `7050`
- add a container healthcheck for the web UI

## Files

- [compose.yml](compose.yml)

## Root and Database

The scaffold expects a local content root and database file that you control on the host.

Keep the root broad enough that the current database and file tree continue to resolve. Narrowing the mount is a separate cleanup step once the container shape is stable.

## Build and Run

From this directory:

```bash
docker compose -f compose.yml up -d
```

## Notes

- Keep the database mounted so existing File Browser users and settings carry over.
- If the root should be narrowed later, do that as a follow-up cleanup after the Docker cutover is stable.
- This Compose file describes the intended Docker runtime. The repository does not prove that any prior host process was removed or that Docker is currently authoritative; verify the live process and database before changing either one.
