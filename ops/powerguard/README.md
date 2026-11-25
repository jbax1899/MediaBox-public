# PowerGuard consolidation

`auto-throttle.sh` preserves the current 5-second sampling loop, 400 MHz step-down, 200 MHz recovery step, 30-second stable period, and 1.2–2.6 GHz limits. `auto-throttle.test.sh` runs it against fixture sysfs and mocked `vcgencmd`, including multiple CPU policies.

On 2026-11-24, the live PowerGuard moved to `mediabox-powerguard.service`. The root and Jordan PM2 `pi-powerguard` entries were removed and saved out of both startup lists; their pre-handoff process and CPU-limit snapshots are kept in the host's root-only storage evidence directory. The systemd unit is enabled, active as root, and verified as the only PowerGuard process. The other Jordan PM2 applications remain online. The live policy was 2.6 GHz before handoff; the service later raised its cap through the same 2.4 GHz step used by the old controller and back to 2.6 GHz.

## Handoff and rollback

Before a future handoff, record `scaling_max_freq` for each CPU policy and save the two PM2 process lists. Stop only the `pi-powerguard` entry in the root and Jordan PM2 homes, leaving both PM2 systemd units and all unrelated applications running. Verify no PM2 PowerGuard process remains, then start the systemd unit and confirm it is the sole frequency controller.

To roll back, stop and disable `mediabox-powerguard.service`, restore the recorded frequency limits, and restart one selected PM2 `pi-powerguard` entry. Keep the other copy stopped, verify exactly one controller is active, and confirm the other PM2 applications remain running. Do not use `pm2 kill` or stop either whole PM2 service.
