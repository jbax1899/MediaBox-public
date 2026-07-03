# AGENTS.md

MediaBox is a Linux ARM64 homelab repo for Docker services, host ops notes, and planning docs. It is not a normal application repo with a single build/test pipeline.

Before editing:

```bash
git status --short
```

Preserve unrelated uncommitted work.

Read only what the task needs. Start with `README.md`, `repo_project.md`, `docs/system-map.md`, `docs/secret-boundaries.md`, and the relevant `ops/<service>/README.md` or `planning/*` file.

Use `docker compose`, not `docker-compose`. Prefer lightweight Compose changes and ARM64-compatible upstream images. Do not commit secrets, private env files, tokens, or machine-local credentials.

Preserve existing host paths, ports, and bind mounts unless the task explicitly changes them. Do not move host-sensitive services into Docker unless an accepted plan says to.

When checking logs, start small:

```bash
docker compose -f ops/<service>/compose.yml logs --tail=10
```

Increase to `--tail=50`, `--tail=100`, or targeted ranges only when needed.

For Compose changes, validate with:

```bash
docker compose -f ops/<service>/compose.yml config
```

For shell scripts, validate with:

```bash
bash -n path/to/script.sh
```
