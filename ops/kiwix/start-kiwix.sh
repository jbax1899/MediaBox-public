#!/usr/bin/env bash
set -euo pipefail

ARCHIVE_PATH="${KIWIX_ARCHIVE_PATH:-/archive}"
PORT="${KIWIX_PORT:-9191}"
LIBRARY_FILE="${ARCHIVE_PATH}/library.xml"
WAIT_SECONDS="${KIWIX_WAIT_SECONDS:-5}"

mkdir -p "$ARCHIVE_PATH"

echo "[Kiwix] Waiting for ZIM archives in ${ARCHIVE_PATH}..." >&2
while ! find "$ARCHIVE_PATH" -maxdepth 1 -type f -name '*.zim' -print -quit | grep -q .; do
  sleep "$WAIT_SECONDS"
done

if [[ ! -f "$LIBRARY_FILE" ]]; then
  printf '<?xml version="1.0" encoding="UTF-8"?><library/>\n' > "$LIBRARY_FILE"
fi

echo "[Kiwix] Synchronizing library metadata..." >&2
while IFS= read -r -d '' zim; do
  if ! grep -Fq -- "$zim" "$LIBRARY_FILE"; then
    echo "[Kiwix] Adding $(basename "$zim")" >&2
    kiwix-manage "$LIBRARY_FILE" add "$zim"
  fi
done < <(find "$ARCHIVE_PATH" -maxdepth 1 -type f -name '*.zim' -print0)

echo "[Kiwix] Launching Kiwix server on port ${PORT}..." >&2
exec kiwix-serve --port "$PORT" --library "$LIBRARY_FILE"
