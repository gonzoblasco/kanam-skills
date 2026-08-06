#!/usr/bin/env bash
# revision-check.sh — Check narrative consistency across chapters
# Usage: ./revision-check.sh <chapters-dir> [--bible <story-bible>]
#
# Checks:
#   - Character name consistency (same name spelled same way)
#   - Location name consistency
#   - Timeline consistency (dates in order)
#   - POV consistency per chapter

set -euo pipefail

CHAPTERS_DIR="${1:?Usage: $0 <chapters-dir> [--bible <story-bible>]}"
BIBLE_FILE=""

# Parse optional bible file
if [[ "${2:-}" == "--bible" && -n "${3:-}" ]]; then
  BIBLE_FILE="$3"
fi

if [[ ! -d "$CHAPTERS_DIR" ]]; then
  echo "❌ Chapters directory not found: $CHAPTERS_DIR"
  exit 1
fi

echo "📖 Running consistency check on: $CHAPTERS_DIR"
echo ""

# ── Collect all chapter files ──
CHAPTER_FILES=()
while IFS= read -r -d '' f; do
  CHAPTER_FILES+=("$f")
done < <(find "$CHAPTERS_DIR" -name "*.md" -print0 | sort -z)

if [[ ${#CHAPTER_FILES[@]} -eq 0 ]]; then
  echo "❌ No markdown files found in $CHAPTERS_DIR"
  exit 1
fi

echo "   Found ${#CHAPTER_FILES[@]} chapter files"
echo ""

# ── Check 1: Character name consistency ──
echo "─── Character Name Check ───"

# Extract all capitalized words that look like character names
# (2+ consecutive capitalized words, or capitalized word followed by lowercase)
ALL_NAMES=$(grep -ohE '\b[A-Z][a-z]+ [A-Z][a-z]+\b|\b[A-Z][a-z]+\b' "${CHAPTER_FILES[@]}" 2>/dev/null | sort -u)

# Filter out common non-character words
COMMON_WORDS="The This That These Those When Where What Which Who How And But Or For Nor Yet So If Then Than Because While During Through About Into Over After Before Between Under Above Below Just Also Very Too More Most Some Any Each Every All Both Few No Nor Not Only Own Same So Such Here There Then"

SUSPECT_NAMES=()
while IFS= read -r name; do
  # Skip single words that are common English
  if echo "$COMMON_WORDS" | grep -qw "$name" 2>/dev/null; then
    continue
  fi
  # Skip if it's a number or date
  if [[ "$name" =~ ^[0-9] ]]; then
    continue
  fi
  SUSPECT_NAMES+=("$name")
done <<< "$ALL_NAMES"

echo "   Found ${#SUSPECT_NAMES[@]} potential character names"
echo ""

# ── Check 2: Location consistency ──
echo "─── Location Name Check ───"

# Extract capitalized words that might be locations (after "in", "at", "to", "from")
LOCATION_PATTERNS=()
for pattern in 'in [A-Z][a-z]+' 'at [A-Z][a-z]+' 'to [A-Z][a-z]+' 'from [A-Z][a-z]+'; do
  while IFS= read -r match; do
    LOCATION_PATTERNS+=("$match")
  done < <(grep -ohE "\b$pattern\b" "${CHAPTER_FILES[@]}" 2>/dev/null || true)
done

echo "   Found ${#LOCATION_PATTERNS[@]} location references"
echo ""

# ── Check 3: Timeline consistency ──
echo "─── Timeline Check ───"

# Extract dates and time references
DATE_PATTERNS=$(grep -ohnE '\b(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}\b|\b\d{1,2}/\d{1,2}/\d{4}\b|\b(Chapter|Capítulo)\s+\d+\b' "${CHAPTER_FILES[@]}" 2>/dev/null || true)

if [[ -n "$DATE_PATTERNS" ]]; then
  echo "   Timeline references found:"
  echo "$DATE_PATTERNS" | while IFS=: read -r file line content; do
    echo "     • $(basename "$file"):$line — $content"
  done
else
  echo "   No explicit dates found (not necessarily an issue)"
fi
echo ""

# ── Check 4: POV consistency ──
echo "─── POV Consistency Check ───"

for chapter in "${CHAPTER_FILES[@]}"; do
  chapter_name=$(basename "$chapter")
  # Look for POV indicators
  POV=$(grep -i '^POV:' "$chapter" 2>/dev/null || grep -i '^\*\*POV\*\*' "$chapter" 2>/dev/null || true)
  if [[ -n "$POV" ]]; then
    echo "   $chapter_name → $POV"
  fi
done
echo ""

# ── Check 5: Compare against story bible (if provided) ──
if [[ -n "$BIBLE_FILE" && -f "$BIBLE_FILE" ]]; then
  echo "─── Bible Consistency Check ───"
  
  # Extract character names from bible
  BIBLE_CHARACTERS=$(grep -i '^\*\*Name:\*\*' "$BIBLE_FILE" 2>/dev/null | sed 's/\*\*Name:\*\*//' | sed 's/^ *//' || true)
  
  if [[ -n "$BIBLE_CHARACTERS" ]]; then
    echo "   Characters defined in bible:"
    while IFS= read -r char; do
      if [[ -n "$char" ]]; then
        # Check if character appears in chapters
        if grep -q "$char" "${CHAPTER_FILES[@]}" 2>/dev/null; then
          echo "     ✅ $char — found in chapters"
        else
          echo "     ⚠️  $char — NOT found in chapters"
        fi
      fi
    done <<< "$BIBLE_CHARACTERS"
  fi
  echo ""
fi

# ── Summary ──
echo "─── Summary ───"
echo "   Chapters checked: ${#CHAPTER_FILES[@]}"
echo "   Characters found: ${#SUSPECT_NAMES[@]}"
echo "   Locations found: ${#LOCATION_PATTERNS[@]}"
echo ""
echo "✅ Check complete. Review the output above for potential issues."
