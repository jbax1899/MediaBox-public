#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
cat >"$tmp/nvme" <<'EOF'
#!/usr/bin/env bash
cat "$NVME_FIXTURE"
EOF
chmod +x "$tmp/nvme"
cat >"$tmp/smart.log" <<'EOF'
critical_warning                    : 0
temperature                         : 29°C (302 Kelvin)
available_spare                     : 40%
percentage_used                     : 2%
Data Units Written                  : 34403686 (17.61 TB)
unsafe_shutdowns                    : 163
media_errors                        : 0
EOF
MEDIABOX_STORAGE_STATE_DIR="$tmp/state" PATH="$tmp:$PATH" NVME_FIXTURE="$tmp/smart.log" bash "$root/ops/storage/nvme-snapshot.sh"
sed -i 's/34403686/34405686/' "$tmp/smart.log"
MEDIABOX_STORAGE_STATE_DIR="$tmp/state" PATH="$tmp:$PATH" NVME_FIXTURE="$tmp/smart.log" bash "$root/ops/storage/nvme-snapshot.sh"
[[ $(wc -l <"$tmp/state/nvme-health.csv") -eq 3 ]]
[[ $(tail -n 1 "$tmp/state/nvme-health.csv" | cut -d, -f3) == 1.024 ]]
for ((i = 0; i < 405; i++)); do printf '2026-01-01T00:00:%02dZ,1,0,1,1,1,1,0,0\n' "$((i % 60))" >>"$tmp/state/nvme-health.csv"; done
MEDIABOX_STORAGE_STATE_DIR="$tmp/state" PATH="$tmp:$PATH" NVME_FIXTURE="$tmp/smart.log" bash "$root/ops/storage/nvme-snapshot.sh"
[[ $(wc -l <"$tmp/state/nvme-health.csv") -eq 401 ]]
[[ $(head -n 1 "$tmp/state/nvme-health.csv") == timestamp,* ]]
sed -i 's/34405686/broken/' "$tmp/smart.log"
if MEDIABOX_STORAGE_STATE_DIR="$tmp/state" PATH="$tmp:$PATH" NVME_FIXTURE="$tmp/smart.log" bash "$root/ops/storage/nvme-snapshot.sh" >/dev/null 2>&1; then
  echo "invalid SMART values should fail" >&2
  exit 1
fi
echo "NVMe snapshot tests passed (baseline, delta, invalid SMART value)"
