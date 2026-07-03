#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
export PATH="${HOME}/.opencode/bin:${PATH}"

OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
OPENCODE_HOSTNAME="${OPENCODE_HOSTNAME:-0.0.0.0}"
OPENCODE_PORT="${OPENCODE_PORT:-4096}"

if [[ -f "${HOME}/.config/opencode/env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${HOME}/.config/opencode/env"
  set +a
elif [[ -f "${HOME}/.config/opencode-web/env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${HOME}/.config/opencode-web/env"
  set +a
fi

cd "$REPO_ROOT"
exec "$OPENCODE_BIN" serve --hostname "$OPENCODE_HOSTNAME" --port "$OPENCODE_PORT"
