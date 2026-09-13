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
- `docs/system-map.md` is the canonical inventory of repository evidence and live-state questions
- `docs/secret-boundaries.md` is the current local-only and secret boundary map
- `reference/` is the factual record of the specific MediaBox build
- Setup docs in: `README.md`, `docs/device_manual.md`, `docs/fdroid_readme.md`, `ops/kiwix/README.md`, and `ops/opencode/README.md`
- Jellyfin, F-Droid, File Browser, and Kiwix have checked-in Docker migration scaffolds; live cutover status is not established here
- The music discovery stack has a checked-in Docker scaffold; its full acquisition workflow is intentionally outside this repository
- Diskover CE has a checked-in container scaffold under `ops/diskover`
- `webretro` has both a checked-in container scaffold and a historical host-PM2 entry; the active runtime needs verification
- OpenCode has a checked-in PM2 configuration; deployment and boot enablement need verification
- Older planning material lives in `planning/` and `drafts/`
