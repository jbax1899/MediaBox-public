# Ollama Runtime

This is the shared Ollama runtime scaffold for MediaBox.
The live AnythingLLM stack already points at this container with the Docker network name `ollama`.

## Layout

- Compose file: `ops/ollama/compose.yml`
- Shared model cache: `/var/lib/ollama`

## Notes

- The container publishes `127.0.0.1:11434` on the host so host tools can reuse the same Ollama instance without a second install.
- AnythingLLM talks to the container over the Docker network name `ollama`.
- OpenCode talks to the same instance from the host with `http://127.0.0.1:11434/v1`.
- Keep the model blobs on the host so they persist across container rebuilds.
- Use the same shared host path if another stack needs to point at this Ollama instance later.
- Avoid a project-specific Ollama data directory unless there is a strong reason to split the cache.
