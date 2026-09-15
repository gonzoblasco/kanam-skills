#!/usr/bin/env bash
# update-changelog.sh - Add entry to CHANGELOG
# Usage: ./update-changelog.sh --type added|changed|fixed|removed --message "<message>"

set -euo pipefail

TYPE=""
MESSAGE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="$2"; shift 2 ;;
    --message) MESSAGE="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

if [[ -z "$TYPE" || -z "$MESSAGE" ]]; then
  echo "Usage: $0 --type added|changed|fixed|removed --message \"<message>\""
  exit 1
fi

if [[ ! -f "CHANGELOG.md" ]]; then
  echo "❌ CHANGELOG.md not found"
  exit 1
fi

# Capitalize type (macOS BSD sed does not support \u)
TYPE_CAPS=$(echo "$TYPE" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

# Insert entry under [Unreleased]
sed -i '' "s/## \[Unreleased\]/## [Unreleased]\n\n### $TYPE_CAPS\n- $MESSAGE/" CHANGELOG.md

echo "✅ CHANGELOG updated: $TYPE_CAPS: $MESSAGE"
