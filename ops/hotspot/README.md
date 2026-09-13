# Hotspot Landing

This directory tracks the bare `http://10.0.0.1` landing behavior for the MediaBox hotspot.

This is a repository record of the intended host configuration, not proof that the hotspot is currently installed or working. The unit file executes a hard-coded `/opt/mediabox` path; verify that path against the live checkout before enabling the unit. The repository commonly documents the checkout as `~/MediaBox`, and this slice does not choose between them.

Goal:

- `10.0.0.1` should land on Dashy
- `10.0.0.1:8080` should keep serving RaspAP
- `10.0.0.1:4000` should continue to reach Dashy directly

The implementation is intentionally narrow:

- nginx on port 80 serves a small landing page that immediately redirects to Dashy
- the AP firewall redirects inbound hotspot HTTP traffic from port 80 to Dashy on port 4000
- no changes are made to the RaspAP admin port on 8080

Apply the host-side changes with:

```bash
sudo bash ops/hotspot/apply-landing.sh
```

If the rule ever drifts after reboot or a package update, rerun the script to restore the expected behavior.

To make it persistent across reboots, install and enable the systemd unit:

```bash
sudo install -m 644 ops/hotspot/mediabox-hotspot-landing.service /etc/systemd/system/mediabox-hotspot-landing.service
sudo systemctl daemon-reload
sudo systemctl enable --now mediabox-hotspot-landing.service
```
