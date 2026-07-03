# MediaBox Device Manual

## Overview

MediaBox is a portable offline knowledge server in a Pelican 1400 case. It provides Wi-Fi-accessible access to books, reference archives, media, retro games, local AI tools, and system utilities without an internet connection.

For current paths and services, see [system-map.md](system-map.md). For local-only and secret-bearing files, see [secret-boundaries.md](secret-boundaries.md).

## Connecting

1. Power on the device.
2. Wait about 30 to 60 seconds for the Wi-Fi network to appear.
3. Connect to the `MediaBox` network.
4. Open `http://10.0.0.1` in a browser.

The homepage is Dashy. The hotspot admin UI stays available on `http://10.0.0.1:8080` if you need RaspAP.

## What It Provides

- Kiwix for offline reference archives
- Kavita for local ebooks
- Kolibri for lessons and curricula
- ROMM for retro games
- Jellyfin for local media streaming
- Navidrome for music playback
- Aurral and Lidarr for music discovery and import review
- Crafty for Minecraft server management
- AnythingLLM for document-aware chat
- A lighter chat UI for quick queries
- SDR browsing and manual tuning
- File management, hotspot control, device health, and remote desktop tools

## Power and Safety

MediaBox uses a battery-backed 12V power system with AC/solar input selection, fused distribution, a buck converter for the Pi, and a UPS HAT for backup.

The case is normally run open for airflow. Optional cooling and dust shielding can be added when needed.

Prototype switch-map notes are archived in [reference/build_notes.md](../reference/build_notes.md). Treat that file as build history, not current operating authority. Keep the fuses matched to the actual measured load before operating, and verify each circuit independently.

## Maintenance

- If the Pi fails to boot, check startup config, service logs, power, and boot media.
- If services fail, restart Docker and check the container logs.
- Crafty is served on `http://<LAN-IP>:8443/`.
- If the Wi-Fi hotspot is missing, confirm Pi power and the hotspot service, then reboot from a known-good power state.
- For battery or power issues, verify fuse continuity, check the voltmeter, and test AC and solar paths independently.
