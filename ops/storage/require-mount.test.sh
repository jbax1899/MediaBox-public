#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT

cat >"$tmp/findmnt" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  *--output\ TARGET*)
    [[ ${FIXTURE_MOUNTED:-yes} == yes ]] || exit 1
    printf '%s\n' "${FIXTURE_TARGET:-/mnt/test}"
    ;;
  *--output\ SOURCE*)
    [[ ${FIXTURE_MOUNTED:-yes} == yes ]] || exit 1
    printf '%s\n' "${FIXTURE_SOURCE:-/dev/test1}"
    ;;
  *) exit 2 ;;
esac
EOF
cat >"$tmp/blkid" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${FIXTURE_UUID:-fixture-uuid}"
EOF
chmod +x "$tmp/findmnt" "$tmp/blkid"

guard="$root/ops/storage/require-mount.sh"
if ! PATH="$tmp:$PATH" "$guard" /mnt/test fixture-uuid >/dev/null; then
  echo "expected matching mount to pass" >&2
  exit 1
fi
if PATH="$tmp:$PATH" FIXTURE_MOUNTED=no "$guard" /mnt/test fixture-uuid >/dev/null 2>&1; then
  echo "expected missing mount to fail" >&2
  exit 1
fi
if ! PATH="$tmp:$PATH" FIXTURE_MOUNTED=yes "$guard" /mnt/test fixture-uuid >/dev/null; then
  echo "expected matching mount to recover after a missing-mount failure" >&2
  exit 1
fi
if PATH="$tmp:$PATH" FIXTURE_UUID=wrong-uuid "$guard" /mnt/test fixture-uuid >/dev/null 2>&1; then
  echo "expected wrong filesystem UUID to fail" >&2
  exit 1
fi
if PATH="$tmp:$PATH" FIXTURE_TARGET=/ "$guard" /mnt/test fixture-uuid >/dev/null 2>&1; then
  echo "expected a parent mount to fail" >&2
  exit 1
fi

runtime_guard="$root/ops/storage/detect-kernel-error.sh"
if printf '%s\n' 'blk_update_request: I/O error, dev sdb, sector 4' | bash "$runtime_guard" sda,sda2 >/dev/null 2>&1; then :; else
  echo "unrelated device error should be ignored" >&2
  exit 1
fi
if printf '%s\n' 'Buffer I/O error on dev sda2, logical block 8' | bash "$runtime_guard" sda,sda2 >/dev/null 2>&1; then
  echo "expected mapped partition error to fail" >&2
  exit 1
fi
if printf '%s\n' 'sd 0:0:0:0: [sda] Sense Key : 0x3 [current]' | bash "$runtime_guard" sda,sda2 >/dev/null 2>&1; then
  echo "expected device medium-error record to fail" >&2
  exit 1
fi
if ! printf '%s\n' 'sd 0:0:0:0: [sda] device is ready' | bash "$runtime_guard" sda,sda2 >/dev/null 2>&1; then
  echo "expected a clean subsequent stream to pass after the error fixture" >&2
  exit 1
fi
grep -q '^Requires=docker.service mnt-4TB.mount mediabox-storage-watch-shoko.service$' "$root/ops/storage/mediabox-shoko.service"
grep -q '^BindsTo=mnt-4TB.mount$' "$root/ops/storage/mediabox-shoko.service"
grep -q '^Restart=no$' "$root/ops/storage/mediabox-shoko.service"
grep -q 'docker compose -f ${SHOKO_COMPOSE_FILE}' "$root/ops/storage/mediabox-shoko.service"
grep -q '^OnFailure=mediabox-storage-contain-shoko.service$' "$root/ops/storage/mediabox-storage-watch-shoko.service"
grep -q 'profiles: \[external-storage\]' "$root/ops/shoko/compose.yml"
grep -q 'restart: "no"' "$root/ops/shoko/compose.yml"

echo "storage guard tests passed (mount match/missing/recovery/wrong UUID/parent; runtime unrelated/error/medium-error/recovery; lifecycle no-restart/watcher/containment)"
