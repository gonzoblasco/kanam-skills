#!/usr/bin/env bash
# hotfiles.sh - Identify most frequently changed files in git history
# Usage: ./hotfiles.sh [--repo <path>] [--top <n>] [--since <date>]

set -euo pipefail

REPO="."
TOP=20
SINCE=""
UNTIL=""
AUTHOR=""
FORMAT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --top) TOP="$2"; shift 2 ;;
    --since) SINCE="$2"; shift 2 ;;
    --until) UNTIL="$2"; shift 2 ;;
    --author) AUTHOR="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

cd "$REPO"

# Build git log command
CMD="git log --name-only --pretty=format:"
[[ -n "$SINCE" ]] && CMD="$CMD --since=\"$SINCE\""
[[ -n "$UNTIL" ]] && CMD="$CMD --until=\"$UNTIL\""
[[ -n "$AUTHOR" ]] && CMD="$CMD --author=\"$AUTHOR\""

echo "🔍 Hotspot file analysis: $REPO"
echo ""

# Count file changes
eval "$CMD" | sort | uniq -c | sort -rn | head -"$TOP" | while IFS= read -r line; do
  count=$(echo "$line" | awk '{print $1}')
  file=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
  echo "$count $file"
done
