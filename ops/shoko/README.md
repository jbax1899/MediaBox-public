# Shoko

[compose.yml](compose.yml) is the reference container configuration.

- State is stored in `./data`, including the local `settings-server.json`.
- Shoko listens on port `8111`. Jellyfin can reach it at `http://host.docker.internal:8111`.
- The entrypoint runs through Bash because the image's script lacks execute permission.

## Startup

Shoko uses the `external-storage` Compose profile and has automatic restart disabled. Keep it stopped until the required media drive is verified and the [storage guard](../storage/README.md) is installed and configured.

Start it through systemd:

```bash
sudo systemctl start mediabox-shoko.service
```

Direct Docker startup or explicitly enabling the Compose profile bypasses the mount check. Use the live Compose file in the guard configuration rather than assuming the reference file matches the host.
