#!/usr/bin/env bash
# check-output.sh - Heuristic lint for ADHD-friendly output format
#
# Usage:
#   check-output.sh <file>
#   echo "text" | check-output.sh
#
# Output: list of violations per rule, or "OK" if it passes.
# Exit 0 = no violations, 1 = violations found.

set -uo pipefail

if [ $# -ge 1 ] && [ -f "$1" ]; then
  INPUT=$(cat "$1")
else
  INPUT=$(cat)
fi

if [ -z "${INPUT// }" ]; then
  echo "ERROR: no input. Usage: check-output.sh <file> or echo \"text\" | check-output.sh"
  exit 2
fi

VIOLATIONS=0
report() { printf '  - [%s] %s\n' "$1" "$2"; VIOLATIONS=$((VIOLATIONS + 1)); }

echo "== ADHD output lint =="

# Rule 10: preamble
PRE=$(printf '%s\n' "$INPUT" | grep -inE '^\s*(great question|good question|excellent question|let me think|of course!|sure thing!)' || true)
if [ -n "$PRE" ]; then
  report "R10 preamble" "$(printf '%s' "$PRE" | head -1)"
fi

# Rule 10: closings
CLO=$(printf '%s\n' "$INPUT" | grep -inE '(hope this (helps|is helpful)|let me know if|feel free to reach out|don.t hesitate)' || true)
if [ -n "$CLO" ]; then
  report "R10 closing" "$(printf '%s' "$CLO" | head -1)"
fi

# Rule 10: long apologies
SORRY=$(printf '%s\n' "$INPUT" | grep -inE '(i apologi[sz]e|sorry for the inconvenience|my apologies|i.m so sorry)' || true)
if [ -n "$SORRY" ]; then
  report "R8 apology" "$(printf '%s' "$SORRY" | head -1)"
fi

# Rule 7: empty praise
CHEER=$(printf '%s\n' "$INPUT" | grep -inE '(great job|nice work|excellent work|well done!)' || true)
if [ -n "$CHEER" ]; then
  report "R7 empty adjective" "$(printf '%s' "$CHEER" | head -1)"
fi

# Rule 6: vague estimates
VAGUE=$(printf '%s\n' "$INPUT" | grep -inE '\b(a bit|a while|in a bit|pretty quick|fairly fast|some time)\b' || true)
if [ -n "$VAGUE" ]; then
  report "R6 vague estimate" "$(printf '%s' "$VAGUE" | head -1)"
fi

# Rule 9: lists longer than 5 items (consecutive bullet blocks)
BULLETS=$(printf '%s\n' "$INPUT" | grep -cE '^\s*([-*]|[0-9]+\.)\s' || true)
MAXB=0
RUN=0
while IFS= read -r line; do
  if printf '%s' "$line" | grep -qE '^\s*([-*]|[0-9]+\.)\s'; then
    RUN=$((RUN + 1))
    [ "$RUN" -gt "$MAXB" ] && MAXB=$RUN
  else
    RUN=0
  fi
done <<< "$INPUT"
if [ "$MAXB" -gt 5 ]; then
  report "R9 long list" "block of $MAXB items (max 5; use a table if the list is the deliverable)"
fi

# Writing rule: em dash / en dash
# grep with a UTF-8 locale fails on macOS/zsh ("character not in range"); python3 is portable.
DASH=$(printf '%s' "$INPUT" | python3 -c '
import sys
d = sys.stdin.read()
hits = [i + 1 for i, l in enumerate(d.splitlines()) if "\u2014" in l or "\u2013" in l]
if hits:
    print("lines " + ", ".join(map(str, hits)))
' 2>/dev/null || true)
if [ -n "$DASH" ]; then
  report "dash" "em/en dash on $DASH - use a plain hyphen (-)"
fi

if [ "$VIOLATIONS" -eq 0 ]; then
  echo "OK - no violations ($BULLETS bullets total)"
  exit 0
fi

echo ""
echo "Total: $VIOLATIONS violation(s). Review before sending."
exit 1
