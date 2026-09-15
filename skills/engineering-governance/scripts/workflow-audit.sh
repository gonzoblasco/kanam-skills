#!/usr/bin/env bash
# workflow-audit.sh - Audit all skills, apply audit checklist, generate health report
# Usage: ./workflow-audit.sh [--output <file>]

set -euo pipefail

OUTPUT_FILE="${2:-GOVERNANCE_REPORT.md}"
SKILLS_DIR="${SKILLS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

echo "🔍 Auditing all workflows..."
echo ""

cat > "$OUTPUT_FILE" << 'HEADER'
# Governance Report - Workflow Audit

HEADER
echo "**Date:** $(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

PASS=0
WARN=0
FAIL=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    echo "⚠️  No SKILL.md in $skill_name"
    continue
  fi

  echo "## $skill_name" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  # Count lines
  LINES=$(wc -l < "$skill_file" | tr -d ' ')

  # Check for references
  REF_COUNT=$(find "$skill_dir" -path "*/references/*" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

  # Check for scripts
  SCRIPT_COUNT=$(find "$skill_dir" -path "*/scripts/*" -type f 2>/dev/null | wc -l | tr -d ' ')

  # Check for description
  HAS_DESC=$(grep -c "description:" "$skill_file" 2>/dev/null || true)
  HAS_DESC=${HAS_DESC:-0}

  # Check for related skills
  HAS_RELATED=$(grep -c "Related Skills" "$skill_file" 2>/dev/null || true)
  HAS_RELATED=${HAS_RELATED:-0}

  # Check for phases
  HAS_PHASES=$(grep -c "^## " "$skill_file" 2>/dev/null || true)
  HAS_PHASES=${HAS_PHASES:-0}

  echo "| Check | Status |" >> "$OUTPUT_FILE"
  echo "|-------|--------|" >> "$OUTPUT_FILE"

  # Size check
  if [[ "$LINES" -gt 300 ]]; then
    echo "| Size | 🔴 $LINES lines (consider split) |" >> "$OUTPUT_FILE"
    FAIL=$((FAIL + 1))
  elif [[ "$LINES" -lt 30 ]]; then
    echo "| Size | 🔴 $LINES lines (too short) |" >> "$OUTPUT_FILE"
    FAIL=$((FAIL + 1))
  else
    echo "| Size | 🟢 $LINES lines |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  # References
  if [[ "$REF_COUNT" -eq 0 ]]; then
    echo "| References | 🟡 None |" >> "$OUTPUT_FILE"
    WARN=$((WARN + 1))
  else
    echo "| References | 🟢 $REF_COUNT files |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  # Scripts
  if [[ "$SCRIPT_COUNT" -eq 0 ]]; then
    echo "| Scripts | 🟡 None |" >> "$OUTPUT_FILE"
    WARN=$((WARN + 1))
  else
    echo "| Scripts | 🟢 $SCRIPT_COUNT files |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  # Description
  if [[ "$HAS_DESC" -eq 0 ]]; then
    echo "| Description | 🔴 Missing |" >> "$OUTPUT_FILE"
    FAIL=$((FAIL + 1))
  else
    echo "| Description | 🟢 Present |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  # Related skills
  if [[ "$HAS_RELATED" -eq 0 ]]; then
    echo "| Related Skills | 🟡 Missing |" >> "$OUTPUT_FILE"
    WARN=$((WARN + 1))
  else
    echo "| Related Skills | 🟢 Present |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  # Phases
  if [[ "$HAS_PHASES" -lt 3 ]]; then
    echo "| Structure | 🟡 Only $HAS_PHASES sections |" >> "$OUTPUT_FILE"
    WARN=$((WARN + 1))
  else
    echo "| Structure | 🟢 $HAS_PHASES sections |" >> "$OUTPUT_FILE"
    PASS=$((PASS + 1))
  fi

  echo "" >> "$OUTPUT_FILE"
done

echo "## Summary" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Result | Count |" >> "$OUTPUT_FILE"
echo "|--------|-------|" >> "$OUTPUT_FILE"
echo "| 🟢 Pass | $PASS |" >> "$OUTPUT_FILE"
echo "| 🟡 Warning | $WARN |" >> "$OUTPUT_FILE"
echo "| 🔴 Fail | $FAIL |" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "✅ Audit complete: $PASS passed, $WARN warnings, $FAIL failures"
echo "   Report: $OUTPUT_FILE"
