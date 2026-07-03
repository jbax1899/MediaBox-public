# MediaBox Hotspot Troubleshooting Note

Status: local-only reference

## Summary

The MediaBox hotspot is intended to run on the USB Wi-Fi dongle at `wlan1`, while onboard Wi-Fi and Ethernet stay available for LAN and headless SSH access.

Observed failure:

- The RaspAP dashboard can bring `wlan1` up, but starting the hotspot drops it back down.
- `hostapd` fails while initializing `wlan1`.
- The log shows `Could not read interface wlan1 flags: No such device` and `nl80211 driver initialization failed`.
- The later failure loop was traced to `rfkill: WLAN soft blocked` on the USB dongle's `phy1` entry.

Relevant live config at the time:

- `/etc/hostapd/hostapd.conf` points `hostapd` at `wlan1`.
- `/etc/raspap/hostapd.ini` had `WifiInterface = wlan1` and `WifiManaged = wlan1`.
- `/etc/dhcpcd.conf` had a static block for `wlan1` and also `denyinterfaces wlan1`.

## What was done

The first corrective change was to remove the stray `denyinterfaces wlan1` line from `/etc/dhcpcd.conf`.

The remaining `wlan1` block now keeps the AP-side static address in place:

- `interface wlan1`
- `static ip_address=10.0.0.1/24`
- `static routers=10.0.0.1`
- `static domain_name_server=1.1.1.1 8.8.8.8`
- `nogateway`
- `nohook wpa_supplicant`

That keeps `wlan1` aligned with the AP role instead of telling `dhcpcd` to ignore it outright.

A later pass found the actual blocker was persisted rfkill state for the USB dongle:

- `rfkill2` for `phy1` was soft blocked
- `systemd-rfkill` had restored that state on boot
- `rfkill unblock 2` cleared the block
- restarting `hostapd` and `dnsmasq` brought `wlan1` back to `AP-ENABLED`
## Why this was the first fix

The MediaBox network design depends on the USB dongle being the hotspot radio and leaving the onboard interfaces alone. A blanket `denyinterfaces wlan1` is too aggressive for that layout and can interfere with the hotspot bring-up path.

## Follow-up work

If the hotspot re-blocks after reboot, the next phase is to inspect why `systemd-rfkill` is restoring the USB dongle state before RaspAP starts.

Candidate settings from the driver notes:

- `rtw_vht_enable=2`
- `rtw_power_mgnt=1`
- `rtw_beamform_cap=1`
- `rtw_dfs_region_domain=1`
- optionally `rtw_drv_log_level=1` while debugging

Suggested next checks:

1. Reboot and confirm `phy1`/`wlan1` stays unblocked.
2. If rfkill restores the block again, trace the saved state in `systemd/rfkill` and any boot-time restore path.
3. If the interface stays unblocked but hotspot still fails, revisit Realtek 8821CU driver tuning in `/etc/modprobe.d/8821cu.conf`.
4. Keep AP-only behavior on `wlan1`; do not point client-mode management at the same interface unless intentionally switching to AP-STA mode.
