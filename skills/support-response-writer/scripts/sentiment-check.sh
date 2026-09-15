#!/usr/bin/env bash
# sentiment-check.sh - Quick tone/sentiment analysis of a support response draft
# Usage: ./sentiment-check.sh <file> or echo "text" | ./sentiment-check.sh

set -euo pipefail

FILE="${1:-}"

if [ -n "$FILE" ] && [ -f "$FILE" ]; then
  TEXT=$(cat "$FILE")
elif [ ! -t 0 ]; then
  TEXT=$(cat)
else
  echo "Usage: sentiment-check.sh <file>"
  echo "       echo 'your text' | sentiment-check.sh"
  exit 1
fi

echo "🔍 Tone Check"
echo "============="
echo ""

# ── Red flags ──────────────────────────────────────────────

RED_FLAGS=0

# Passive-aggressive patterns
if echo "$TEXT" | grep -qiE 'as (I|we) (said|mentioned|stated)'; then
  echo "🔴 Passive-aggressive: 'as I said/mentioned' - sounds condescending"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'actually|unfortunately|regrettably'; then
  echo "🟡 Softening words: 'actually/unfortunately' - can sound dismissive"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'you (should|must|need to|have to)'; then
  echo "🔴 Demanding: 'you should/must/need to' - sounds bossy"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE "that's (not|never) (our|my) (problem|fault|responsibility)"; then
  echo "🔴 Defensive: 'not our problem/fault' - never say this"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'calm down|relax|chill|take it easy'; then
  echo "🔴 Inflammatory: 'calm down/relax' - will escalate anger"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'per our (policy|terms|agreement)'; then
  echo "🟡 Policy-speak: 'per our policy' - sounds robotic, rephrase"
  RED_FLAGS=$((RED_FLAGS + 1))
fi

# ── Green flags ────────────────────────────────────────────

GREEN_FLAGS=0

if echo "$TEXT" | grep -qiE "I('m| am) (sorry|apologize)"; then
  echo "✅ Apology present"
  GREEN_FLAGS=$((GREEN_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'thank you|thanks for'; then
  echo "✅ Gratitude expressed"
  GREEN_FLAGS=$((GREEN_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE 'I (understand|hear|see)'; then
  echo "✅ Empathy/validation present"
  GREEN_FLAGS=$((GREEN_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE '(here|this) is what (I|we).*(doing|will do|going to do)'; then
  echo "✅ Action-oriented: clear next steps"
  GREEN_FLAGS=$((GREEN_FLAGS + 1))
fi

if echo "$TEXT" | grep -qiE '(reply|reach out|let me know|contact)'; then
  echo "✅ Open door: invitation to continue conversation"
  GREEN_FLAGS=$((GREEN_FLAGS + 1))
fi

# ── Summary ────────────────────────────────────────────────

echo ""
echo "── Summary ──"
echo "Red flags:  $RED_FLAGS"
echo "Green flags: $GREEN_FLAGS"

if [ "$RED_FLAGS" -eq 0 ] && [ "$GREEN_FLAGS" -ge 3 ]; then
  echo "✅ Tone looks good!"
elif [ "$RED_FLAGS" -gt 0 ]; then
  echo "⚠️  Review red flags above before sending."
else
  echo "💡 Consider adding: apology, empathy, clear next steps, and an open door."
fi
