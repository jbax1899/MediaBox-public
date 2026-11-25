#!/usr/bin/env bash
set -euo pipefail

state_dir=${MEDIABOX_STORAGE_STATE_DIR:-/var/lib/mediabox-storage}
device=${MEDIABOX_NVME_DEVICE:-/dev/nvme0}
mkdir -p -- "$state_dir"
snapshot=$(LC_ALL=C nvme smart-log "$device")

value() {
  local key=$1
  awk -F: -v key="$key" '
    {
      label = tolower($1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", label)
      gsub(/[[:space:]]+/, "_", label)
      if (label == key) {
        value = $2
        sub(/^[[:space:]]+/, "", value)
        if (match(value, /^[0-9]+/)) {
          print substr(value, RSTART, RLENGTH)
          exit
        }
      }
    }
  ' <<<"$snapshot"
}

data_units=$(value data_units_written)
used=$(value percentage_used)
spare=$(value available_spare)
unsafe=$(value unsafe_shutdowns)
temperature=$(value temperature)
critical_raw=$(awk -F: '
  {
    label = tolower($1)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", label)
    if (label == "critical_warning") {
      value = $2
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
      print value
      exit
    }
  }
' <<<"$snapshot")
if [[ "$critical_raw" =~ ^0[xX]([[:xdigit:]]+)$ ]]; then
  critical=$((16#${BASH_REMATCH[1]}))
elif [[ "$critical_raw" =~ ^[0-9]+$ ]]; then
  critical=$((10#$critical_raw))
else
  echo "nvme snapshot: missing or invalid critical_warning value" >&2
  exit 1
fi
media_errors=$(value media_errors)
for number in "$data_units" "$used" "$spare" "$unsafe" "$temperature" "$media_errors"; do
  [[ "$number" =~ ^[0-9]+$ ]] || { echo "nvme snapshot: missing or invalid SMART value" >&2; exit 1; }
done

last_file="$state_dir/nvme-data-units-written"
interval_gb=0
if [[ -s "$last_file" ]]; then
  read -r previous <"$last_file"
  [[ "$previous" =~ ^[0-9]+$ ]] || { echo "nvme snapshot: invalid previous counter" >&2; exit 1; }
  if (( data_units >= previous )); then
    scaled=$(( (data_units - previous) * 512 ))
    printf -v interval_gb '%d.%03d' "$((scaled / 1000000))" "$(((scaled % 1000000) / 1000))"
  fi
fi
timestamp=$(date --utc +%Y-%m-%dT%H:%M:%SZ)
csv="$state_dir/nvme-health.csv"
if [[ ! -e "$csv" ]]; then
  printf 'timestamp,data_units_written,interval_gb,percentage_used,available_spare_percent,unsafe_shutdowns,temperature_c,critical_warning,media_errors\n' >"$csv"
fi
printf '%s,%s,%s,%s,%s,%s,%s,%s,%s\n' "$timestamp" "$data_units" "$interval_gb" "$used" "$spare" "$unsafe" "$temperature" "$critical" "$media_errors" >>"$csv"
if (( $(wc -l <"$csv") > 401 )); then
  { head -n 1 "$csv"; tail -n 400 "$csv"; } >"$csv.tmp"
  mv -- "$csv.tmp" "$csv"
fi
printf '%s\n' "$data_units" >"$last_file"
