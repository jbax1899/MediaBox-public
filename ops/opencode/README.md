# OpenCode Runtime

Secret handling for this service is documented in [docs/secret-boundaries.md](../../docs/secret-boundaries.md).

This folder contains the runnable bits for serving OpenCode from the MediaBox repo root.

Preferred launch path:

```bash
pm2 start ops/opencode/ecosystem.config.cjs
pm2 save
```

The PM2 app name is `opencode`.

The launcher script starts the headless server with the repository as its working directory, which avoids the "no folders found" behavior that happens when OpenCode is started from `~`.

The launcher sources `~/.config/opencode/env` if it exists, and still accepts the legacy `~/.config/opencode-web/env` path as a fallback. That keeps the PM2 service compatible while the local env file is renamed.

If you need to run it manually:

```bash
./ops/opencode/start-opencode-web.sh
```

## Ollama Provider

To point OpenCode at the shared Ollama server, add a provider entry in `~/.config/opencode/opencode.jsonc`.
The shared instance is the Docker Ollama service published on `http://127.0.0.1:11434` from the host and exposed on `http://ollama:11434` inside Docker.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "enabled": true,
      "headers": {
        "CONTEXT7_API_KEY": "..."
      }
    }
  },
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://127.0.0.1:11434/v1"
      },
      "models": {
        "YOUR_OLLAMA_MODEL_ID": {
          "name": "Your Ollama Model"
        }
      }
    }
  }
}
```

Replace `YOUR_OLLAMA_MODEL_ID` with the model identifier you actually want OpenCode to use. The OpenCode docs also support `opencode models` for listing configured providers.
