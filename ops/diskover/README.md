# Diskover CE Runtime Scaffold

This folder contains the initial container scaffold for Diskover Community Edition.

It keeps the first pass narrow:

- Diskover web UI on `8097`
- local Elasticsearch only
- read-only mounts for the tracked media/library roots
- no scan scheduling or deletion automation yet

## Files

- [compose.yml](compose.yml)

## Host Prerequisite

Diskover's Elasticsearch container needs `vm.max_map_count=262144`.

Set it temporarily before the first boot:

```bash
sudo sysctl -w vm.max_map_count=262144
```

Persist it after validation:

```bash
printf 'vm.max_map_count=262144\n' | sudo tee /etc/sysctl.d/99-elasticsearch.conf
sudo sysctl --system
```

## Runtime Paths

Create the local state directory before starting the stack. Keep the state off the scanned media roots.

## Build and Run

From this directory:

```bash
docker compose -f compose.yml config
docker compose -f compose.yml up -d
docker compose -f compose.yml logs --tail=100
```

## First Checks

- Open `http://<mediabox-ip>:8097/`
- Log in with the initial local account and change the password immediately.
- If Elasticsearch is not detected, check the local Diskover config and confirm `ES_HOST=elasticsearch` and `ES_PORT=9200`.
- Add a new index by running one crawl per root you want to track.
- Suggested naming is one index per path, for example `diskover-music-YYYYMMDD`, `diskover-anime-YYYYMMDD`, or `diskover-incoming-YYYYMMDD`.
- Start with the most useful roots first, then reload the select-indices page after each crawl finishes.

## Main-Drive Cleanup

When the goal is reclaiming space on the root filesystem, use a dedicated cleanup index instead of trying to crawl `/` directly.

Suggested starter index:

- `diskover-rootfs-YYYYMMDD`

Start with the host-owned paths that are most likely to show real space usage on this box:

- the host home directory
- the shared Ollama model cache
- the host log directory

Keep that index separate from the media-library indexes so you can compare growth over time and avoid mixing cleanup work with library visibility.

If you need a narrower target, crawl only the host home directory first and then add the shared Ollama model cache as a second cleanup index if model-cache growth is part of the problem.
