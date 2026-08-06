#!/usr/bin/env bash
# check-refs.sh — Verify all cross-references between documents are valid
# Usage: ./check-refs.sh [--fix]

set -euo pipefail

FIX_MODE="${1:-}"
BROKEN=0

echo "🔗 Checking cross-references..."
echo ""

# Find all markdown links to local files
grep -rn '\[.*\](\.\./' --include="*.md" . 2>/dev/null | grep -v node_modules | grep -v ".github" | while IFS=: read -r file line content; do
  # Extract the link target
  TARGET=$(echo "$content" | grep -oP '\(\K[^)]+' | head -1 || true)
  
  if [[ -z "$TARGET" ]]; then
    continue
  fi

  # Resolve relative to file location
  DIR=$(dirname "$file")
  RESOLVED="$DIR/$TARGET"

  if [[ ! -f "$RESOLVED" && ! -d "$RESOLVED" ]]; then
    echo "🔴 $file:$line → $TARGET (not found)"
    BROKEN=$((BROKEN + 1))
  fi
done

if [[ "$BROKEN" -eq 0 ]]; then
  echo "✅ All references are valid!"
else
  echo ""
  echo "⚠️  $BROKEN broken references found"
fi
