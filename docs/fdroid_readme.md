# MediaBox F-Droid Local Mirror

Current runtime categories and host boundary notes live in [system-map.md](system-map.md) and [secret-boundaries.md](secret-boundaries.md).

This document describes the configuration for running an **F-Droid-compatible offline app repository** on MediaBox.

Under this design:

* Keep APKs in a host-local repo directory that is mounted read-only into the serving container.
* Use a separate host-local staging area for upstream index downloads and temporary files.
* `fdroid update` sees a normal F-Droid repo and behaves as expected.
* Metadata preservation is limited to what F-Droid itself infers from APKs.

---

## Directory Layout

```
<fdroid-root>/
├── config.yml
├── sync.sh
├── keystore.p12
├── repo/              # FINAL APK STORAGE
│   ├── *.apk
│   ├── index-v1.jar
│   ├── icons/
│   └── …
└── upstream/          # ONLY for downloaded index + staging
    ├── index-v1.jar
    ├── index-v1.json
    ├── apklist.txt
    └── apks/          # TEMP download location
```

Only `/repo/` matters to F-Droid. Everything else is support infrastructure.

---

## F-Droid Configuration (config.yml)

Your final working configuration:

```
repo_url: http://<host>:8070/repo
repo_name: MediaBox Appstore
repo_description: A repository of APKs hosted on MediaBox, for local and offline use.
repo_icon: repo/icons/icon.png

accept_unknown_apks: true
trust_apk_signatures: true
scan_apk: false
scan_binary: false
disable_apk_manifest_analysis: true
allow_disabled_algorithms: true

repo_keyalias: mediabox
keystore: keystore.p12
keypass: <set a local password>
keystorepass: <set a local password>
keydname: CN=mediabox, OU=F-Droid
```

---

## Sync Script (sync.sh)

Keep the live host script outside the serving container until the storage move is complete.

This script:

1. Downloads the upstream index.
2. Extracts the JSON manifest.
3. Calculates the latest APK version for each package.
4. Downloads new APKs into `upstream/apks/`.
5. **Copies them into `/repo/` as real files**.
6. Runs `fdroid update` if anything changed.

```
#!/bin/bash
set -euo pipefail

BASE="<fdroid-root>"
UP="$BASE/upstream"
REPO="$BASE/repo"

mkdir -p "$UP/apks"
mkdir -p "$REPO"

echo "[fdroid-sync] Starting at $(date)"

# 1. Fetch upstream index
wget -q -O "$UP/index-v1.jar" https://f-droid.org/repo/index-v1.jar

# 2. Extract index-v1.json
unzip -o "$UP/index-v1.jar" index-v1.json -d "$UP" >/dev/null

# 3. Build latest-only APK list
APKLIST="$UP/apklist.txt"

jq -r '
  .packages
  | to_entries[]
  | .value
  | max_by((.versionCode | tonumber? // 0))
  | .apkName
' "$UP/index-v1.json" > "$APKLIST"

APKCOUNT=$(wc -l < "$APKLIST")
echo "[fdroid-sync] APKs to mirror (latest-only): $APKCOUNT"

# 4. Download missing APKs into upstream/apks
NEW_APKS=0

while read -r APK; do
  [ -z "$APK" ] && continue

  if [ -f "$UP/apks/$APK" ]; then
    continue
  fi

  echo "  → Downloading $APK"
  wget -q "https://f-droid.org/repo/$APK" -O "$UP/apks/$APK"
  NEW_APKS=$((NEW_APKS + 1))

done < "$APKLIST"

echo "[fdroid-sync] New downloads: $NEW_APKS"

# 5. Copy new APKs into repo
cp -u "$UP/apks/"*.apk "$REPO/" 2>/dev/null || true

# 6. Rebuild repo if changed
if [ "$NEW_APKS" -gt 0 ]; then
  echo "[fdroid-sync] Running fdroid update..."
  cd "$BASE"
  fdroid update
else
  echo "[fdroid-sync] No new APKs — skipping fdroid update."
fi

echo "[fdroid-sync] Finished at $(date)"
```

---

## Legacy Reference

The old PM2/http-server wrapper is historical. The active serving layer is the Docker scaffold in `ops/fdroid-repo/`, while the sync/update job remains host-side during the migration.

---

## Troubleshooting

### “Ignoring package without metadata”

Expected for all upstream APKs.
Since you are not maintaining per-app YAML metadata, F-Droid auto-generates minimal metadata from the APKs.
This is normal and harmless.

### “FileNotFoundError: repo/…apk”

Occurs when:

* Repo contains a symlink instead of a real file.
* Or `repo_apk_dir` was set.
* Or `.apk` listed in the index is missing in `/repo/`.

Fix:

1. Ensure `/repo/*.apk` are real files.
2. Ensure sync script copies new APKs.
3. Delete old symlink-based repos.

### “zipfile: invalid compressed data to inflate”

Means the upstream index download corrupted mid-transfer.
Run sync again.

---
