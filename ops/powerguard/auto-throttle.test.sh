#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/sys/cpu0/cpufreq" "$tmp/sys/cpu1/cpufreq"
printf '1400000\n' >"$tmp/sys/cpu0/cpufreq/scaling_cur_freq"
printf '1300000\n' >"$tmp/sys/cpu0/cpufreq/scaling_max_freq"
printf '1400000\n' >"$tmp/sys/cpu1/cpufreq/scaling_max_freq"
cat >"$tmp/bin/vcgencmd" <<'EOF'
#!/usr/bin/env bash
head -n 1 "$POWERGUARD_THROTTLE_FILE"
tail -n +2 "$POWERGUARD_THROTTLE_FILE" >"$POWERGUARD_THROTTLE_FILE.next"
mv "$POWERGUARD_THROTTLE_FILE.next" "$POWERGUARD_THROTTLE_FILE"
EOF
cat >"$tmp/bin/date" <<'EOF'
#!/usr/bin/env bash
head -n 1 "$POWERGUARD_DATE_FILE"
tail -n +2 "$POWERGUARD_DATE_FILE" >"$POWERGUARD_DATE_FILE.next"
mv "$POWERGUARD_DATE_FILE.next" "$POWERGUARD_DATE_FILE"
EOF
cat >"$tmp/bin/sleep" <<'EOF'
#!/usr/bin/env bash
if [[ ${1:-} == 1 ]]; then
  cat "$POWERGUARD_SYSFS_ROOT/cpu0/cpufreq/scaling_max_freq" >"$POWERGUARD_SYSFS_ROOT/cpu0/cpufreq/scaling_cur_freq"
fi
EOF
cat >"$tmp/bin/logger" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$tmp/bin/"*
printf '99\n100\n' >"$tmp/dates"
printf 'throttled=0x1\n' >"$tmp/throttled"
PATH="$tmp/bin:$PATH" POWERGUARD_SYSFS_ROOT="$tmp/sys" POWERGUARD_DATE_FILE="$tmp/dates" POWERGUARD_THROTTLE_FILE="$tmp/throttled" POWERGUARD_TEST_CYCLES=1 bash "$root/ops/powerguard/auto-throttle.sh"
[[ $(<"$tmp/sys/cpu0/cpufreq/scaling_max_freq") == 1200000 ]] || { echo "frequency must clamp to 1200000" >&2; exit 1; }
[[ $(<"$tmp/sys/cpu1/cpufreq/scaling_max_freq") == 1200000 ]] || { echo "all CPU policies must be updated" >&2; exit 1; }
cat >"$tmp/bin/vcgencmd" <<'EOF'
#!/usr/bin/env bash
head -n 1 "$POWERGUARD_THROTTLE_FILE"
tail -n +2 "$POWERGUARD_THROTTLE_FILE" >"$POWERGUARD_THROTTLE_FILE.next"
mv "$POWERGUARD_THROTTLE_FILE.next" "$POWERGUARD_THROTTLE_FILE"
EOF
printf '2500000\n' >"$tmp/sys/cpu0/cpufreq/scaling_cur_freq"
printf '2500000\n' >"$tmp/sys/cpu0/cpufreq/scaling_max_freq"
printf '2500000\n' >"$tmp/sys/cpu1/cpufreq/scaling_max_freq"
printf '100\n140\n' >"$tmp/dates"
printf 'throttled=0x0\n' >"$tmp/throttled"
PATH="$tmp/bin:$PATH" POWERGUARD_SYSFS_ROOT="$tmp/sys" POWERGUARD_DATE_FILE="$tmp/dates" POWERGUARD_THROTTLE_FILE="$tmp/throttled" POWERGUARD_TEST_CYCLES=1 bash "$root/ops/powerguard/auto-throttle.sh"
[[ $(<"$tmp/sys/cpu0/cpufreq/scaling_max_freq") == 2600000 ]] || { echo "frequency must clamp to 2600000" >&2; exit 1; }
[[ $(<"$tmp/sys/cpu1/cpufreq/scaling_max_freq") == 2600000 ]] || { echo "all CPU policies must be updated" >&2; exit 1; }
printf '1400000\n' >"$tmp/sys/cpu0/cpufreq/scaling_cur_freq"
printf '2600000\n' >"$tmp/sys/cpu0/cpufreq/scaling_max_freq"
printf '2600000\n' >"$tmp/sys/cpu1/cpufreq/scaling_max_freq"
printf '100\n140\n' >"$tmp/dates"
printf 'throttled=0x0\n' >"$tmp/throttled"
PATH="$tmp/bin:$PATH" POWERGUARD_SYSFS_ROOT="$tmp/sys" POWERGUARD_DATE_FILE="$tmp/dates" POWERGUARD_THROTTLE_FILE="$tmp/throttled" POWERGUARD_TEST_CYCLES=1 bash "$root/ops/powerguard/auto-throttle.sh"
[[ $(<"$tmp/sys/cpu0/cpufreq/scaling_max_freq") == 2600000 ]] || { echo "low current frequency must not lower the configured cap" >&2; exit 1; }
[[ $(<"$tmp/sys/cpu0/cpufreq/scaling_cur_freq") == 1400000 ]] || { echo "cap check should not change current frequency" >&2; exit 1; }
printf '1200000\n' >"$tmp/sys/cpu0/cpufreq/scaling_cur_freq"
printf '1200000\n' >"$tmp/sys/cpu0/cpufreq/scaling_max_freq"
printf '1200000\n' >"$tmp/sys/cpu1/cpufreq/scaling_max_freq"
printf '99\n100\n135\n140\n170\n' >"$tmp/dates"
printf 'throttled=0x1\nthrottled=0x1\nthrottled=0x0\nthrottled=0x0\n' >"$tmp/throttled"
PATH="$tmp/bin:$PATH" POWERGUARD_SYSFS_ROOT="$tmp/sys" POWERGUARD_DATE_FILE="$tmp/dates" POWERGUARD_THROTTLE_FILE="$tmp/throttled" POWERGUARD_TEST_CYCLES=4 bash "$root/ops/powerguard/auto-throttle.sh"
[[ $(<"$tmp/sys/cpu0/cpufreq/scaling_max_freq") == 1400000 ]] || { echo "recovery must wait 30 stable seconds after the last undervoltage sample" >&2; exit 1; }
[[ $(<"$tmp/sys/cpu1/cpufreq/scaling_max_freq") == 1400000 ]] || { echo "recovery must update all CPU policies" >&2; exit 1; }
echo "PowerGuard tests passed (frequency clamps, configured cap, multi-policy, stable recovery)"
