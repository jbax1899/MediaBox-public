#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || "$1" != /* || -z "$2" ]]; then
  echo "usage: $0 /absolute/mountpoint expected-filesystem-uuid" >&2
  exit 2
fi

mountpoint=$1
expected_uuid=$2

if ! actual_target=$(findmnt --noheadings --raw --mountpoint "$mountpoint" --output TARGET 2>/dev/null); then
  echo "storage guard: $mountpoint is not a mountpoint" >&2
  exit 1
fi
if ! source=$(findmnt --noheadings --raw --mountpoint "$mountpoint" --output SOURCE 2>/dev/null); then
  echo "storage guard: cannot resolve the source mounted at $mountpoint" >&2
  exit 1
fi
if ! actual_uuid=$(blkid --no-encoding --output value --match-tag UUID "$source" 2>/dev/null) || [[ -z "$actual_uuid" ]]; then
  echo "storage guard: cannot read filesystem UUID for $source" >&2
  exit 1
fi

if [[ "$actual_target" != "$mountpoint" || "$actual_uuid" != "$expected_uuid" ]]; then
  echo "storage guard: expected $expected_uuid at $mountpoint; found $actual_uuid at $actual_target" >&2
  exit 1
fi

printf 'storage guard: %s has expected filesystem %s\n' "$mountpoint" "$actual_uuid"
