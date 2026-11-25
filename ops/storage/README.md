# Storage protection

## External drives

Before starting a service that uses external storage, run `require-mount.sh /absolute/mountpoint expected-uuid`. It checks that the exact path is mounted and the filesystem UUID matches. Use Compose bind mounts with `create_host_path: false` to prevent missing source directories from being created on the root disk. This option alone does not verify the filesystem behind an existing directory.

Shoko requires its media drive at `/mnt/4TB`. Install the guard units only after confirming the filesystem UUID and kernel device names. Create a root-only `/etc/mediabox-storage/shoko.env` with:

- `SHOKO_MEDIA_UUID`: expected filesystem UUID.
- `SHOKO_STORAGE_DEVICES`: comma-separated kernel device and partition names.
- `SHOKO_COMPOSE_FILE`: absolute path to the live Compose file.

Install the guard scripts under `/usr/local/lib/mediabox` and the three Shoko units under `/etc/systemd/system`. See [Shoko](../shoko/README.md) for startup instructions.

The Shoko unit requires the mount and its kernel-error watcher. Mount loss stops the service. If the watcher detects a medium or I/O error on a configured device, its failure handler stops Shoko. Check the drive and failed units before manually restarting; a successful file listing or health check does not establish disk health. Beszel must remain independent of the external mount.

## NVMe monitoring

Install `nvme-cli`, place `nvme-snapshot.sh` under `/usr/local/lib/mediabox`, install the associated systemd service and timer, and enable `nvme-snapshot.timer`.

The daily snapshot records cumulative host writes, writes since the last sample, wear, available spare, unsafe shutdowns, temperature, critical warnings and media errors. It retains 400 samples in the root-only `/var/lib/mediabox-storage/nvme-health.csv`. The default device is `/dev/nvme0`; override `MEDIABOX_NVME_DEVICE` locally if needed. These readings help track trends but do not guarantee drive health.

## Tests

From the repository root:

```bash
bash ops/storage/require-mount.test.sh
bash ops/storage/nvme-snapshot.test.sh
```

Both suites use fixtures and do not access host disks.

See the [system map](../../docs/system-map.md) for deployment status and the [Docker](../docker/README.md), [PM2](../pm2/README.md) and [PowerGuard](../powerguard/README.md) runbooks for related maintenance.
