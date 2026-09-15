#!/usr/bin/env bash
# pomodoro-timer.sh - Simple Pomodoro timer with desktop notifications
# Usage: ./pomodoro-timer.sh [work_minutes] [break_minutes] [rounds]
# Default: 25 min work, 5 min break, 4 rounds

set -euo pipefail

WORK_MINUTES="${1:-25}"
BREAK_MINUTES="${2:-5}"
ROUNDS="${3:-4}"

WORK_SECONDS=$((WORK_MINUTES * 60))
BREAK_SECONDS=$((BREAK_MINUTES * 60))

notify() {
  local title="$1"
  local message="$2"
  if command -v osascript &>/dev/null; then
    osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
  elif command -v notify-send &>/dev/null; then
    notify-send "$title" "$message"
  else
    echo "🔔 $title: $message"
  fi
}

countdown() {
  local seconds="$1"
  local label="$2"
  while [ "$seconds" -gt 0 ]; do
    local mins=$((seconds / 60))
    local secs=$((seconds % 60))
    printf "\r⏳ %s: %02d:%02d " "$label" "$mins" "$secs"
    sleep 1
    seconds=$((seconds - 1))
  done
  printf "\r✅ %s: done!     \n" "$label"
}

echo "🍅 Pomodoro Timer"
echo "   Work: ${WORK_MINUTES}min | Break: ${BREAK_MINUTES}min | Rounds: ${ROUNDS}"
echo ""

for ((round=1; round<=ROUNDS; round++)); do
  echo "── Round $round of $ROUNDS ──"

  notify "🍅 Pomodoro" "Round $round: Focus for ${WORK_MINUTES} minutes"
  countdown "$WORK_SECONDS" "Focus"
  notify "🍅 Pomodoro" "Round $round complete! Take a ${BREAK_MINUTES}min break"

  if [ "$round" -lt "$ROUNDS" ]; then
    countdown "$BREAK_SECONDS" "Break"
    notify "🍅 Pomodoro" "Break over. Ready for round $((round + 1))?"
  fi
done

echo ""
echo "🎉 All $ROUNDS rounds complete! Great work."
notify "🍅 Pomodoro" "All rounds complete! Great work."
