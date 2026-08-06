#!/usr/bin/env bash
# progress-tracker.sh — Track writing progress
# Usage: ./progress-tracker.sh [--log <log-file>] [--add <words>] [--status]
#
# Tracks word count, sessions, streaks. ADHD-friendly, no guilt.

set -euo pipefail

LOG_FILE="writing-log.md"
ACTION="status"
ADD_WORDS=0

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --log)
      LOG_FILE="$2"
      shift 2
      ;;
    --add)
      ACTION="add"
      ADD_WORDS="$2"
      shift 2
      ;;
    --status)
      ACTION="status"
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--log <file>] [--add <words>] [--status]"
      echo ""
      echo "  --add <words>   Log today's word count"
      echo "  --status        Show current stats (default)"
      echo "  --log <file>    Use custom log file (default: writing-log.md)"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# ── Initialize log if needed ──
if [[ ! -f "$LOG_FILE" ]]; then
  cat > "$LOG_FILE" << 'HEADER'
# Writing Log

## Stats
- **Project:**
- **Started:**
- **Target words:**

## Daily Log

| Date | Words | Time | Notes |
|------|-------|-------|-------|
HEADER
  echo "📝 Created new log: $LOG_FILE"
fi

# ── Add today's words ──
if [[ "$ACTION" == "add" ]]; then
  TODAY=$(date '+%Y-%m-%d')
  TIME_NOW=$(date '+%H:%M')
  
  # Check if today already has an entry
  if grep -q "^| $TODAY |" "$LOG_FILE" 2>/dev/null; then
    # Update existing entry
    EXISTING=$(grep "^| $TODAY |" "$LOG_FILE" | awk -F'|' '{print $3}' | tr -d ' ')
    NEW_TOTAL=$((EXISTING + ADD_WORDS))
    
    # Use sed to update the line
    if [[ "$(uname)" == "Darwin" ]]; then
      sed -i '' "s/^| $TODAY |.*/| $TODAY | $NEW_TOTAL | | |/" "$LOG_FILE"
    else
      sed -i "s/^| $TODAY |.*/| $TODAY | $NEW_TOTAL | | |/" "$LOG_FILE"
    fi
    echo "✅ Updated today: +$ADD_WORDS words (total: $NEW_TOTAL)"
  else
    # Add new entry
    echo "| $TODAY | $ADD_WORDS | | |" >> "$LOG_FILE"
    echo "✅ Logged: $ADD_WORDS words"
  fi
fi

# ── Show status ──
if [[ "$ACTION" == "status" ]]; then
  echo ""
  echo "📊 WRITING PROGRESS"
  echo "==================="
  echo ""
  
  # Date helpers that work on macOS and GNU Linux
date_add_days() {
  local base="$1"
  local days="$2"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date -j -v"${days}"d -f "%Y-%m-%d" "$base" +%Y-%m-%d
  else
    date -d "$base ${days} days" +%Y-%m-%d
  fi
}

date_yesterday() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date -v-1d +%Y-%m-%d
  else
    date -d yesterday +%Y-%m-%d
  fi
}

# Count total words
  TOTAL_WORDS=$(grep -E '^\| [0-9]' "$LOG_FILE" 2>/dev/null | awk -F'|' 'NF>=4 {gsub(/[[:space:]]/, "", $3); sum += $3} END {print sum+0}')
  TOTAL_WORDS=${TOTAL_WORDS:-0}

  # Count sessions
  SESSIONS=$(grep -cE '^\| [0-9]' "$LOG_FILE" 2>/dev/null | head -1)
  SESSIONS=${SESSIONS:-0}
  
  # Calculate streak
  STREAK=0
  TODAY=$(date '+%Y-%m-%d')
  YESTERDAY=$(date_yesterday)
  
  # Check if wrote today
  if grep -q "^| $TODAY |" "$LOG_FILE" 2>/dev/null; then
    STREAK=$((STREAK + 1))
    # Count backwards
    CHECK_DATE="$YESTERDAY"
    while [[ -n "$CHECK_DATE" ]]; do
      if grep -q "^| $CHECK_DATE |" "$LOG_FILE" 2>/dev/null; then
        STREAK=$((STREAK + 1))
        CHECK_DATE=$(date_add_days "$CHECK_DATE" -1)
      else
        break
      fi
    done
  fi
  
  # Average per session
  AVG=0
  if [[ "$SESSIONS" -gt 0 ]]; then
    AVG=$((TOTAL_WORDS / SESSIONS))
  fi
  
  echo "   Total words:  $TOTAL_WORDS"
  echo "   Sessions:     $SESSIONS"
  echo "   Avg/session:  $AVG"
  echo "   Current streak: $STREAK days"
  echo ""
  
  # Show last 7 days
  echo "   Last 7 days:"
  echo "   ─────────────"
  for i in $(seq 0 6); do
    DAY=$(date_add_days "$TODAY" -$i)
    if [[ -n "$DAY" ]]; then
      ENTRY=$(grep "^| $DAY |" "$LOG_FILE" 2>/dev/null || true)
      if [[ -n "$ENTRY" ]]; then
        WORDS=$(echo "$ENTRY" | awk -F'|' '{print $3}' | tr -d ' ')
        echo "     ✅ $DAY — $WORDS words"
      else
        echo "     ❌ $DAY — no writing"
      fi
    fi
  done
  echo ""
  
  # Progress bar (if target is set)
  TARGET=$(grep -i "target words:" "$LOG_FILE" 2>/dev/null | grep -oE '[0-9]+' || echo "0")
  if [[ "$TARGET" -gt 0 ]]; then
    PCT=$((TOTAL_WORDS * 100 / TARGET))
    BAR_LEN=30
    FILLED=$((PCT * BAR_LEN / 100))
    BAR=$(printf '%*s' "$FILLED" | tr ' ' '█')
    BAR="$BAR$(printf '%*s' $((BAR_LEN - FILLED)) | tr ' ' '░')"
    echo "   Progress: [$BAR] $PCT% ($TOTAL_WORDS / $TARGET words)"
  fi
fi
