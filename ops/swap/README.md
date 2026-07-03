# Swap Runtime Scaffold

This folder records the target swap policy for MediaBox.

The live host currently still uses the existing 8 GiB `/swapfile`. The intended next step is to add zram as the first swap tier so normal memory pressure is absorbed in RAM before the NVMe-backed fallback is used.

## Files

- [zram-generator.conf](zram-generator.conf)

## Policy

- Keep `/swapfile` in place as the backing swap device.
- Add a zram device above it so compressed swap is used first.
- Keep the compressor fast rather than chasing maximum compression ratio.
- Keep the policy system-wide; this is not a per-process swap rule.

## Install

Copy the generator config to `/etc/systemd/zram-generator.conf`, install `systemd-zram-generator`, then reload systemd or reboot:

```bash
sudo install -m 0644 zram-generator.conf /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo reboot
```

## Verify

After boot:

```bash
zramctl
swapon --show
free -h
```

The zram device should appear before `/swapfile` in swap priority order once the host config is applied.
