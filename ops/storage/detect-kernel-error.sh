#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[[:alnum:]_.-]+(,[[:alnum:]_.-]+)*$ ]]; then
  echo "usage: $0 kernel-device[,partition...]" >&2
  exit 2
fi

IFS=, read -r -a devices <<< "$1"
while IFS= read -r line; do
  lower=${line,,}
  for device in "${devices[@]}"; do
    if [[ "$line" == *"[$device]"* || "$line" == *"dev $device,"* || "$line" == *"dev $device "* ]]; then
      case "$lower" in
        *"i/o error"*|*"medium error"*|*"sense key : 0x3"*)
          printf 'storage runtime guard: storage error on %s; fail dependent services closed\n' "$device" >&2
          exit 1
          ;;
      esac
    fi
  done
done
