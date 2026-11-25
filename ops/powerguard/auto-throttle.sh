#!/usr/bin/env bash
set -euo pipefail

log_tag=powerguard
check_interval=5
step_down=400000
step_up=200000
cooldown=30
min_freq=1200000
max_freq=2600000
sysfs_root=${POWERGUARD_SYSFS_ROOT:-/sys/devices/system/cpu}
cycles=${POWERGUARD_TEST_CYCLES:-0}

get_freq() { awk '{print $1}' "$sysfs_root/cpu0/cpufreq/scaling_cur_freq"; }
get_max_freq() { awk '{print $1}' "$sysfs_root/cpu0/cpufreq/scaling_max_freq"; }
set_freq() {
  local freq=$1
  local path
  local found=0
  for path in "$sysfs_root"/cpu*/cpufreq/scaling_max_freq; do
    [[ -e "$path" ]] || continue
    printf '%s\n' "$freq" >"$path"
    found=1
  done
  (( found )) || { echo "powerguard: no CPU frequency controls found" >&2; return 1; }
  sleep 1
  current_freq=$(get_freq)
  logger -t "$log_tag" "CPU max frequency set to ${freq}kHz (current ${current_freq}kHz)"
}

current_freq=$(get_max_freq)
last_undervolt=0
stable_since=$(date +%s)
count=0
while :; do
  throttled=$(vcgencmd get_throttled | cut -d= -f2)
  now=$(date +%s)
  if (( (throttled & 1) != 0 )); then
    stable_since=$now
    if (( now - last_undervolt > 2 )); then
      next_freq=$((current_freq - step_down))
      (( next_freq < min_freq )) && next_freq=$min_freq
      if (( next_freq < current_freq )); then
        set_freq "$next_freq"
        current_freq=$next_freq
      fi
      last_undervolt=$now
    fi
  elif (( now - stable_since >= cooldown )); then
    next_freq=$((current_freq + step_up))
    (( next_freq > max_freq )) && next_freq=$max_freq
    if (( next_freq > current_freq )); then
      set_freq "$next_freq"
      current_freq=$next_freq
      stable_since=$now
    fi
  fi
  if (( cycles > 0 )); then
    (( count += 1 ))
    (( count >= cycles )) && break
  fi
  sleep "$check_interval"
done
