# repo_project

Temporary working notes for reorganizing MediaBox into a repo that other people can use to build their own setup.

## Cleanup Plan

See [planning/cleanup_plan.md](planning/cleanup_plan.md) for the current cleanup-first plan.

## TODO (Current Focus)

- [ ] Keep path and storage truth in the canonical docs only
- [ ] Keep host-only services out of the Docker queue unless a cleanup actually requires a move
- [ ] Treat legacy migration notes as history, not current operating instructions

## DOING

- Trimming the canonical docs pass

## DONE (Observations/Findings)

- Repo is mostly a documentation and launcher hub
- `docs/system-map.md` is the current inventory of services and paths
- `docs/secret-boundaries.md` is the current local-only and secret boundary map
- `reference/` is the factual record of the specific MediaBox build
- Setup docs in: `README.md`, `docs/device_manual.md`, `docs/fdroid_readme.md`, `docs/kiwix_service_readme.md`, `ops/opencode/README.md`
- The recent Docker cutovers are Jellyfin, F-Droid, File Browser, and Kiwix
- The music discovery stack now has a checked-in Docker scaffold and a local Dashy section
- Diskover CE now has a checked-in container scaffold under `ops/diskover`
- `webretro` has a checked-in container scaffold; `novnc-vnc` stays on the host for now
- OpenCode remains the PM2 host-side browser service
- Older planning material lives in `planning/` and `drafts/`
