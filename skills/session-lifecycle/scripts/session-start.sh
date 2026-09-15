#!/usr/bin/env bash
# session-start.sh - Initialize session context
# Usage: ./session-start.sh --project "<name>" --objective "<objective>"

set -euo pipefail

PROJECT=""
OBJECTIVE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT="$2"; shift 2 ;;
    --objective) OBJECTIVE="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

if [[ -z "$PROJECT" || -z "$OBJECTIVE" ]]; then
  echo "Usage: $0 --project \"<name>\" --objective \"<objective>\""
  exit 1
fi

DATE=$(date '+%Y-%m-%d %H:%M')
HANDOFF_DIR="projects/$PROJECT/.knowledge"
HANDOFF_FILE="$HANDOFF_DIR/HANDOFF.md"

echo "🔧 Starting session for: $PROJECT"
echo ""

# --- Complexity score (complexity-driven-pipeline, 2026-08-30) ---
# Score the objective upfront so model/thinking/pipeline depth is decided
# together before spawning any agent.
SCORER="scripts/complexity-scorer.sh"
if [[ -f "$SCORER" ]] && command -v python3 >/dev/null 2>&1; then
  echo "📊 Scoring complexity of objective..."
  SCORE_OUT=$("$SCORER" "$OBJECTIVE" 2>/dev/null | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(f\"{d.get('score','?')} ({d.get('bucket','unknown')}) - {d.get('pipeline','')}\")
except Exception:
    print('not scored')
" 2>/dev/null || echo "not scored") || true
  echo "   📈 Complexity T-score: $SCORE_OUT"
  echo ""
else
  echo "   ⚠️  Scorer not available - starting without T-score"
  echo ""
  SCORE_OUT="not scored"
fi

# Check for existing HANDOFF
if [[ -f "$HANDOFF_FILE" ]]; then
  echo "📋 Previous HANDOFF found:"
  head -10 "$HANDOFF_FILE"
  echo ""
  echo "---"
  echo ""
fi

# --- Semantic memory injection (2026-08-31) ---
# Search past sessions + learnings relevant to the objective and surface them
# as context, so the session starts with relevant memory instead of cold.
SEARCHER="scripts/memory-search.py"
if [[ -f "$SEARCHER" ]] && command -v python3 >/dev/null 2>&1; then
  echo "🧠 Searching memory for relevant context..."
  echo ""
  python3 "$SEARCHER" "$OBJECTIVE" --top 3 2>/dev/null | head -40 || echo "   (no memory results)"
  echo ""
  echo "---"
  echo ""
else
  echo "   ⚠️  memory-search.py not available - starting without semantic context"
  echo ""
fi

# Create session log
MEMORY_DIR="memory"
mkdir -p "$MEMORY_DIR"
SESSION_LOG="$MEMORY_DIR/$(date +%Y-%m-%d).md"

if [[ ! -f "$SESSION_LOG" ]]; then
  cat > "$SESSION_LOG" << LOG
# Session Log - $(date '+%Y-%m-%d')

## $PROJECT
**Objective:** $OBJECTIVE
**Complexity T-score:** $SCORE_OUT
**Start:** $DATE

LOG
fi

echo "✅ Session started"
echo "   Project: $PROJECT"
echo "   Objective: $OBJECTIVE"
echo "   Log: $SESSION_LOG"
