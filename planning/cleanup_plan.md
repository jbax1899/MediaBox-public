# MediaBox Cleanup Plan

## Goal

Clean up the repo documentation and organization first. Do not spend time making the project reproducible for outsiders yet.

## What the repo should be right now

- `README.md` is the front door
- `docs/device_manual.md` is the current user-facing manual
- `docs/system-map.md` is the inventory of paths and services
- `docs/secret-boundaries.md` is the local-only / secret boundary reference
- `docs/fdroid_readme.md` and the service readmes under `ops/` are the current runbooks
- `ops/opencode/README.md` is an ops note for one service
- `planning/` and `drafts/` are for future ideas, prototypes, and writing plans only
- `reference/` is for the factual record of the specific MediaBox build

## Cleanup priorities

### 1. Remove duplicate truth

- Keep the service and path inventory in one place
- Trim `README.md` so it points to the canonical docs instead of repeating inventories
- Trim `docs/device_manual.md` so it does not re-explain the same service map or path map

### 2. Separate current docs from drafts

- Mark draft-heavy files as draft or planning material
- Keep prototype hardware ideas out of the current manual unless they are actually in use
- Move future expansion notes out of the active manual and into planning

### 3. Tighten machine-specific notes

- Replace unnecessary hard-coded paths with short, consistent references where possible
- Keep explicit local-only paths in `docs/secret-boundaries.md`
- Make it obvious which paths are source checkouts, runtime data, and private config

### 4. Keep ops docs narrow

- Leave `docs/fdroid_readme.md` and the service readmes under `ops/` as runbooks
- Keep `ops/opencode/README.md` focused on launch/runtime behavior
- Do not mix runbook instructions with broader repo organization notes

## File-by-file actions

### `README.md`

- Keep a short overview of what MediaBox is
- Link to the canonical docs
- Remove duplicated service inventory if it is already covered in `docs/system-map.md`

### `repo_project.md`

- Keep this as the working cleanup ledger
- Track current focus, completed observations, and open cleanup items
- Link to this plan instead of repeating the same next steps

### `docs/device_manual.md`

- Keep the user-facing device overview
- Remove or shorten prototype and future-phase sections
- Link out to system inventory, secret boundaries, and planning docs instead of repeating them

### `docs/system-map.md`

- Make this the single source for current app repos, runtime/config paths, and service ownership
- Update it when a path or service changes
- Avoid narrative explanation here

### `docs/secret-boundaries.md`

- Expand this enough to cover all local-only files that matter
- Keep secrets out of the repo and out of any “normal docs” sections

### `reference/build_notes.md`

- Treat this as build-history material for the specific MediaBox instance
- Move any current operational facts into the appropriate canonical doc
- Leave the enclosure and power experiments here only if they are still exploratory

### `drafts/blog_writing_plan.md`

- Keep as writing/planning material only
- Do not reference it from active operational docs unless needed

### `planning/extension_pi3_sensors_monitor.md`

- Keep as a future idea or extension proposal
- Do not mix it into the current manual as if it were part of the active build

### `ops/opencode/README.md`

- Keep the launch path and runtime note
- Keep secret handling references out of the repo itself

## Suggested execution order

1. Update `README.md` to point at the canonical docs
2. Update `repo_project.md` to reference this cleanup plan
3. Prune duplicate inventory from `docs/device_manual.md`
4. Make `docs/system-map.md` the authoritative inventory
5. Expand `docs/secret-boundaries.md` if any local-only files are missing
6. Reclassify or trim the planning/draft docs so they are clearly non-canonical

## Definition of done for this cleanup pass

- One doc clearly owns current system inventory
- One doc clearly owns secret/local-only boundaries
- The main manual no longer repeats the same inventory data
- Planning and draft docs are visibly separate from current operational docs
- The repo reads like an organized documentation hub, not a pile of overlapping notes
