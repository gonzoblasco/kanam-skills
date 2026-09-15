# Narrative Content

Planning and writing fiction.

## What is it for?

To **write novels, short stories and fiction** with professional structure. It covers planning (premise, structure, characters, worldbuilding), assisted drafting, consistency revision, and export to DOCX, EPUB or Markdown.

## When to use it?

- When you want to start writing a novel or short story
- When you need to structure an existing story
- When you want to export narrative content into a publishable format

## How is it used?

### Full workflow

1. **Premise** - central idea, genre, tone, audience, main conflict
2. **Structure** - narrative arc, chapters, characters, worldbuilding
3. **Drafting** - writing chapters, scenes, dialogue
4. **Revision** - narrative coherence, consistency, plot holes
5. **Export** - DOCX, EPUB, Markdown

### Useful scripts

```bash
# Generate an outline from a premise
./scripts/outline-generator.sh premise.txt --structure hero

# Create a character sheet
./scripts/character-sheet.sh "Arya Stark" --role protagonist

# Export chapters to EPUB
python3 scripts/export-novel.py ./chapters/ --format epub --output novel.epub
```

## References

| File | What it contains |
|---|---|
| `references/narrative-structures.md` | 4 structures: Three-Act, Hero's Journey, Save the Cat, Snowflake |
| `references/character-development.md` | Character sheets, archetypes, motivation matrix |
| `references/worldbuilding.md` | Worldbuilding bible, consistency checklist, show don't tell |

## Related skills

- [Copy Editing](../copy-editing) - To edit narrative text
- [Technical Documentation](../tech-docs) - To document narrative structure
