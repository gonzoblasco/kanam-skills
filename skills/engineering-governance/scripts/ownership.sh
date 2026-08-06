#!/usr/bin/env bash
# ownership.sh — Analyze code ownership by contributor
# Usage: ./ownership.sh [--repo <path>] [--path <subpath>] [--top <n>]

set -euo pipefail

REPO="."
SUBPATH=""
TOP=10
SINCE=""
FORMAT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --path) SUBPATH="$2"; shift 2 ;;
    --top) TOP="$2"; shift 2 ;;
    --since) SINCE="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

cd "$REPO"

echo "🔍 Code ownership analysis: $REPO"
echo ""

# Build git shortlog command
CMD="git shortlog -sn"
[[ -n "$SUBPATH" ]] && CMD="$CMD -- \"$SUBPATH\""
[[ -n "$SINCE" ]] && CMD="$CMD --since=\"$SINCE\""

echo "| Contributor | Commits | % | Last Active |"
echo "|-------------|---------|---|-------------|"

eval "$CMD" | head -"$TOP" | while IFS= read -r line; do
  commits=$(echo "$line" | awk '{print $1}')
  name=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
  last=$(git log --author="$name" --format="%ai" -1 2>/dev/null | cut -d' ' -f1 || echo "unknown")
  echo "| $name | $commits | | $last |"
done
