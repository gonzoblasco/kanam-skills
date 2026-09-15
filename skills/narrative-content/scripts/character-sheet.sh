#!/usr/bin/env bash
# character-sheet.sh - Generate character sheet template
# Usage: ./character-sheet.sh <name> [--role protagonist|antagonist|supporting]

set -euo pipefail

NAME="${1:?Usage: $0 <name> [--role protagonist|antagonist|supporting]}"
ROLE="${3:-protagonist}"

OUTPUT="character-${NAME// /-}-$(date +%Y%m%d).md"

echo "📝 Creating character sheet for: $NAME"
echo ""

cat > "$OUTPUT" << CHAR
# Character: $NAME

**Role:** $ROLE

## External
- **Age:**
- **Occupation:**
- **Appearance:**
- **Distinctive features:**
- **Mannerisms:**

## Internal
- **Core desire:**
- **Fear:**
- **Flaw:**
- **Lie they believe:**
- **Truth they need to learn:**

## Arc
- **Starting point:**
- **Midpoint shift:**
- **Ending point:**
- **Key moment of change:**

## Relationships

| Character | Relationship |
|-----------|-------------|
| | |

## Voice
- **Speech patterns:**
- **Catchphrases:**
- **Vocabulary level:**

## Notes

CHAR

echo "✅ Character sheet created: $OUTPUT"
