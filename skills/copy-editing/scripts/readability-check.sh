#!/usr/bin/env bash
# readability-check.sh - Quick readability metrics for a text file
# Usage: ./readability-check.sh <file>

set -euo pipefail

FILE="${1:-}"

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "Usage: readability-check.sh <file>"
  exit 1
fi

TEXT=$(cat "$FILE")

# Count syllables (rough approximation: count vowel groups)
count_syllables() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z]/ /g' | while read -r word; do
    echo "$word" | sed 's/[^aeiouy]//g' | wc -c
  done | awk '{s+=$1} END {print s}'
}

WORDS=$(echo "$TEXT" | wc -w | tr -d ' ')
SENTENCES=$(echo "$TEXT" | tr '\n' ' ' | grep -oE '[^.!?]+[.!?]' | wc -l | tr -d ' ')
SYLLABLES=$(count_syllables "$TEXT")

# Flesch-Kincaid Grade Level
# 0.39 * (words/sentences) + 11.8 * (syllables/words) - 15.59
if [ "$SENTENCES" -gt 0 ] && [ "$WORDS" -gt 0 ]; then
  FK=$(echo "scale=1; 0.39 * ($WORDS / $SENTENCES) + 11.8 * ($SYLLABLES / $WORDS) - 15.59" | bc)
else
  FK="N/A"
fi

# Flesch Reading Ease
# 206.835 - 1.015 * (words/sentences) - 84.6 * (syllables/words)
if [ "$SENTENCES" -gt 0 ] && [ "$WORDS" -gt 0 ]; then
  FRE=$(echo "scale=1; 206.835 - 1.015 * ($WORDS / $SENTENCES) - 84.6 * ($SYLLABLES / $WORDS)" | bc)
else
  FRE="N/A"
fi

echo "📖 Readability: $FILE"
echo "===================="
echo "Flesch-Kincaid Grade: ${FK}"
echo "Flesch Reading Ease:  ${FRE}/100"
echo ""

# Interpret
if [ "$FK" != "N/A" ]; then
  FK_INT=$(echo "$FK" | cut -d. -f1)
  if [ "$FK_INT" -le 6 ]; then
    echo "✅ Grade $FK_INT - Very easy to read (5th-6th grade)"
  elif [ "$FK_INT" -le 8 ]; then
    echo "✅ Grade $FK_INT - Conversational (7th-8th grade)"
  elif [ "$FK_INT" -le 12 ]; then
    echo "⚠️  Grade $FK_INT - Somewhat difficult (high school)"
  else
    echo "🔴 Grade $FK_INT - Difficult (college level)"
  fi
fi

if [ "$FRE" != "N/A" ]; then
  FRE_INT=$(echo "$FRE" | cut -d. -f1)
  if [ "$FRE_INT" -ge 60 ]; then
    echo "✅ Ease $FRE - Plain English, easy to consume"
  elif [ "$FRE_INT" -ge 30 ]; then
    echo "⚠️  Ease $FRE - Somewhat difficult"
  else
    echo "🔴 Ease $FRE - Very difficult, academic/legal"
  fi
fi

echo ""
echo "💡 For marketing copy: aim for Grade 6-8, Ease 60+"
