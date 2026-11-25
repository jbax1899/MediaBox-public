# Beszel monitoring

The live Compose definition is maintained outside this repository. Keep its agent key, token, and host-specific paths out of Git.

On 2026-11-24, the host-networked agent's hub target was corrected to loopback after the previous route timed out. Only `beszel-agent` was recreated, with dependencies and image pulls disabled. Its WebSocket connection and a new system sample were verified afterward. The live Compose backup remains in the root-only evidence directory.

Beszel remains a low-privilege Docker agent; it has no NVMe device mapping or raw-I/O capabilities. The host-side daily SMART collector is documented in [storage](../storage/README.md).

Alert configuration and notification delivery were deferred for this remediation phase.
