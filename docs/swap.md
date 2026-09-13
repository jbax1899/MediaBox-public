# Swap

This note records a host inspection of the swap setup on MediaBox. It is not proof of the current live state; verify the host before treating these values as operational facts.

## Recorded State

- Root filesystem is `/dev/nvme0n1p2` on the NVMe drive.
- The active swap device is `/swapfile`.
- The live swapfile size is 8 GiB.
- `free -h` showed about 7.9 GiB of RAM and about 1.5 GiB of swap used at the time of inspection.
- `vm.swappiness` is set to `10`.
- `vm.overcommit_memory` is `0` and `vm.overcommit_ratio` is `50`.
- No active `zswap` setting was present.
- No `zram` devices were active.

## Management Method

- Boot-time activation comes from `/etc/fstab`.
- `dphys-swapfile` is installed, but the live setup does not appear to be driven by an active boot-time `dphys-swapfile` start link.
- `/etc/dphys-swapfile` currently sets `CONF_SWAPSIZE=4096` and `CONF_SWAPFACTOR=2`, but the existing live swapfile is 8 GiB, so the config and live state do not match.

## Notes

- The current setup favors a disk-backed swapfile on NVMe with a low swappiness value.
- There is no compression layer in front of swap right now, so anonymous memory pressure goes straight to NVMe-backed swap.
- If the goal is to reduce wear or latency, the next design question is whether to shrink the swapfile, add `zram`, or use both with an explicit policy for memory-heavy services.
- `zram` is system-wide rather than process-specific, so any Ollama-specific preference would need a separate policy layer rather than simple global compression alone.
- The target zram overlay policy is tracked in [ops/swap](../ops/swap/README.md) until the host-level config can be applied with root access.
