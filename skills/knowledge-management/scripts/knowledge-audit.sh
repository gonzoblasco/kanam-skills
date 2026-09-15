#!/usr/bin/env bash
# knowledge-audit.sh - Audit knowledge base: freshness, broken refs, orphans
# Usage: ./knowledge-audit.sh [--output <file>]

set -euo pipefail

OUTPUT_FILE="${2:-KNOWLEDGE_REPORT.md}"

echo "🔍 Auditing knowledge base..."
echo ""

cat > "$OUTPUT_FILE" << 'HEADER'
# Knowledge Audit Report

HEADER
echo "**Date:** $(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT_FILE"
echo "**Project:** $(basename "$(pwd)")" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# --- Freshness ---
echo "## Document Freshness" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Document | Age | Status |" >> "$OUTPUT_FILE"
echo "|----------|-----|--------|" >> "$OUTPUT_FILE"

for doc in STATUS.md HANDOFF.md TRACKER.md CHANGELOG.md ROADMAP.md BRIEF.md; do
  if [[ -f "$doc" ]]; then
    DAYS=$(( ($(date +%s) - $(stat -f %m "$doc" 2>/dev/null || echo "$(date +%s)")) / 86400 ))
    if [[ "$DAYS" -gt 90 ]]; then
      STATUS="🔴 Obsolete"
    elif [[ "$DAYS" -gt 30 ]]; then
      STATUS="🟠 Stale"
    elif [[ "$DAYS" -gt 7 ]]; then
      STATUS="🟡 Review"
    else
      STATUS="🟢 Fresh"
    fi
    echo "| $doc | ${DAYS}d | $STATUS |" >> "$OUTPUT_FILE"
  fi
done

echo "" >> "$OUTPUT_FILE"

# --- Broken references ---
echo "## Broken References" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

BROKEN=0
while IFS= read -r line; do
  file=$(echo "$line" | cut -d: -f1)
  ref=$(echo "$line" | grep -oP '\(\K[^)]+' | head -1 || true)
  if [[ -n "$ref" && ! -f "$ref" && "$ref" != http* ]]; then
    echo "- 🔴 $file → $ref" >> "$OUTPUT_FILE"
    BROKEN=$((BROKEN + 1))
  fi
done < <(grep -r "\.\./" --include="*.md" . 2>/dev/null | grep -v node_modules | grep -v ".github" | head -50 || true)

if [[ "$BROKEN" -eq 0 ]]; then
  echo "✅ No broken references found" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# --- Orphan documents ---
echo "## Orphan Documents" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Check for .knowledge/ dirs without active projects
shopt -s nullglob
for kdir in projects/*/.knowledge; do
  project=$(dirname "$(dirname "$kdir")")
  if [[ ! -f "$project/STATUS.md" ]]; then
    echo "- 🔴 $project/.knowledge/ (no STATUS.md)" >> "$OUTPUT_FILE"
  fi
done
shopt -u nullglob

echo "" >> "$OUTPUT_FILE"
echo "✅ Audit complete: $OUTPUT_FILE"
