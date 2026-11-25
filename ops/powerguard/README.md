# PowerGuard

PowerGuard checks for undervoltage every five seconds. It lowers the CPU frequency cap by 400 MHz during undervoltage and raises it by 200 MHz after 30 seconds of stable power, within 1.2–2.6 GHz.

Run `bash ops/powerguard/auto-throttle.test.sh` from the repository root to test the policy against mock CPU controls and `vcgencmd`.

## Moving from PM2 to systemd

1. Record each CPU policy's `scaling_max_freq` and save both PM2 process configurations.
2. In each manager's user context, run `pm2 delete pi-powerguard` followed by `pm2 save`. Leave unrelated PM2 apps running.
3. Verify neither PM2 copy remains. Install `auto-throttle.sh` at `/usr/local/sbin/mediabox-auto-throttle` and the systemd unit under `/etc/systemd/system`.
4. Reload systemd, enable and start `mediabox-powerguard.service`, and verify that it is the only frequency controller.

## Rollback

Stop and disable the systemd unit, restore the recorded CPU caps, and recreate one PM2 PowerGuard entry from its saved configuration. Verify that only one controller is running and save that manager's process list. Do not restore both saved lists or stop either PM2 daemon.
