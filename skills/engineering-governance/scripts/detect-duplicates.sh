#!/usr/bin/env bash
# detect-duplicates.sh - Find duplicate checklists, phases, or prompts across skills
# Usage: ./detect-duplicates.sh [--output <file>]
#
# Portable: works on bash 3.2 (macOS default) and bash 5.x (CI).
# Uses temp files + grep -c instead of associative arrays and pipefail-prone pipes.

set -euo pipefail

OUTPUT_FILE="${2:-duplicates-report.md}"
SKILLS_DIR="${SKILLS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Scanning for duplicate content across skills..."
echo ""

cat > "$OUTPUT_FILE" << 'HEADER'
# Duplicate Content Report

HEADER
echo "**Date:** $(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Collect all headings: "normalized_key<TAB>original<TAB>skill_name" per line
headings="$TMP_DIR/headings.tsv"
checklist="$TMP_DIR/checklist.tsv"

for skill_file in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$skill_file" ] || continue
  skill_name=$(basename "$(dirname "$skill_file")")

  # Section headings (## ...)
  grep -E '^## ' "$skill_file" 2>/dev/null | while IFS= read -r heading; do
    key=$(printf '%s' "$heading" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
    [ -n "$key" ] && printf '%s\t%s\t%s\n' "$key" "$heading" "$skill_name" >> "$headings"
  done || true

  # Checklist items (- [ ] ...)
  grep -E '^- \[ \] ' "$skill_file" 2>/dev/null | while IFS= read -r line; do
    item=$(printf '%s' "$line" | sed -E 's/^- \[ \] //' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    [ -n "$item" ] && printf '%s\t%s\t%s\n' "$(printf '%s' "$item" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')" "$item" "$skill_name" >> "$checklist"
  done || true
done

report_section() {
  local title="$1"
  local file="$2"
  local line_prefix="$3"

  echo "## $title" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  [ "$line_prefix" = "|" ] && echo "| Heading | Found In |" >> "$OUTPUT_FILE" && echo "|---------|----------|" >> "$OUTPUT_FILE"

  [ -f "$file" ] || return 0

  # Find keys appearing in 2+ distinct skills: cut key, sort, uniq -c
  cut -f1 "$file" | sort | uniq -c | awk '$1 >= 2 {print $2}' > "$TMP_DIR/dup_keys.txt"
  [ -s "$TMP_DIR/dup_keys.txt" ] || return 0

  while IFS= read -r key; do
    [ -n "$key" ] || continue
    # All lines matching this key
    grep -F "$key" "$file" > "$TMP_DIR/match.txt" || true
    # Distinct skills for this key
    skills=$(cut -f3 "$TMP_DIR/match.txt" | sort -u | paste -sd ',' - | sed 's/,/, /g')
    original=$(cut -f2 "$TMP_DIR/match.txt" | head -1)
    if [ "$line_prefix" = "|" ]; then
      echo "| $original | $skills |" >> "$OUTPUT_FILE"
    else
      echo "- \"$original\" appears in: $skills" >> "$OUTPUT_FILE"
    fi
  done < "$TMP_DIR/dup_keys.txt"
}

report_section "Shared Section Headings" "$headings" "|"
echo "" >> "$OUTPUT_FILE"
report_section "Shared Checklist Items" "$checklist" "-"

echo "" >> "$OUTPUT_FILE"
echo "Duplicate scan complete: $OUTPUT_FILE"
