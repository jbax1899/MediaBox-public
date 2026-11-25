# Beszel

The live Compose file is maintained separately. Keep its key, token and host-specific paths out of Git.

The host-networked agent connects to the hub over loopback. If collection stops, check this connection and the timestamp of the latest sample before recreating the agent.

The agent does not have raw device access. NVMe SMART history is collected by the [host-side timer](../storage/README.md). Beszel must not depend on external media mounts.

See the [system map](../../docs/system-map.md) for alert and deployment status.
