#!/usr/bin/env bash
# outline-generator.sh - Generate story outline from premise
# Usage: ./outline-generator.sh <premise-file> [--structure 3act|hero|savethecat]

set -euo pipefail

PREMISE_FILE="${1:?Usage: $0 <premise-file> [--structure 3act|hero|savethecat]}"
STRUCTURE="${2:-3act}"

if [[ ! -f "$PREMISE_FILE" ]]; then
  echo "❌ Premise file not found: $PREMISE_FILE"
  exit 1
fi

PREMISE=$(cat "$PREMISE_FILE")
OUTPUT="outline-$(date +%Y%m%d-%H%M%S).md"

echo "📖 Generating outline..."
echo "   Structure: $STRUCTURE"
echo "   Premise: $(head -1 "$PREMISE_FILE")"
echo ""

cat > "$OUTPUT" << 'HEADER'
# Story Outline

HEADER
echo "**Generated:** $(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT"
echo "**Structure:** $STRUCTURE" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## Premise" >> "$OUTPUT"
echo "" >> "$OUTPUT"
cat "$PREMISE_FILE" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "" >> "$OUTPUT"

case "$STRUCTURE" in
  hero)
    cat >> "$OUTPUT" << 'HERO'
## Hero's Journey Outline

1. **Ordinary World** - [ ]
2. **Call to Adventure** - [ ]
3. **Refusal of the Call** - [ ]
4. **Meeting the Mentor** - [ ]
5. **Crossing the Threshold** - [ ]
6. **Tests, Allies, Enemies** - [ ]
7. **Approach to the Inmost Cave** - [ ]
8. **Ordeal** - [ ]
9. **Reward** - [ ]
10. **The Road Back** - [ ]
11. **Resurrection** - [ ]
12. **Return with the Elixir** - [ ]
HERO
    ;;
  savethecat)
    cat >> "$OUTPUT" << 'SAVETHECAT'
## Save the Cat! Outline

1. **Opening Image** - [ ]
2. **Theme Stated** - [ ]
3. **Set-Up** - [ ]
4. **Catalyst** - [ ]
5. **Debate** - [ ]
6. **Break into Two** - [ ]
7. **B Story** - [ ]
8. **Fun and Games** - [ ]
9. **Midpoint** - [ ]
10. **Bad Guys Close In** - [ ]
11. **All Is Lost** - [ ]
12. **Dark Night of the Soul** - [ ]
13. **Break into Three** - [ ]
14. **Finale** - [ ]
15. **Final Image** - [ ]
SAVETHECAT
    ;;
  *)
    cat >> "$OUTPUT" << 'THREEACT'
## Three-Act Structure Outline

### Act I - Setup
- [ ] Inciting Incident
- [ ] Establish world, characters, conflict
- [ ] First Plot Point

### Act II - Confrontation
- [ ] Rising action
- [ ] Midpoint
- [ ] Darkest moment
- [ ] Second Plot Point

### Act III - Resolution
- [ ] Climax
- [ ] Falling action
- [ ] Denouement
THREEACT
    ;;
esac

echo "" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## Notes" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "- " >> "$OUTPUT"

echo "✅ Outline generated: $OUTPUT"
