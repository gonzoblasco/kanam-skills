# Technical Documentation

Technical documentation: ADRs, diagrams, CHANGELOG.

## What is it for?

To **create and manage project technical documentation**: ADRs (Architecture Decision Records), README, API docs, CHANGELOG, contribution guides and C4 architecture diagrams with Mermaid.

## When to use it?

- When starting a new project (initial docs + design)
- When you change an API or feature (update docs)
- When closing an epic or milestone (CHANGELOG + ADRs)
- When you need to document an architectural decision

## How is it used?

### Full workflow

1. **Audience** - who reads these docs?
2. **Architectural Design** - C4 diagrams, trade-offs, dependencies, risks
3. **Structure** - which docs the project needs
4. **ADRs** - create or sync architectural decisions
5. **Technical Writing** - concrete examples, real code
6. **Review** - coherence, completeness, no broken links
7. **Publication** - commit + push

### Useful scripts

```bash
# Create a new ADR
./scripts/generate-adr.sh --title "Use Supabase for the backend" --status proposed

# Add a CHANGELOG entry
./scripts/update-changelog.sh --type added --message "Sign in with Google"

# Generate diagrams from the code
python3 scripts/analyze_codebase.py ./src --type architecture
```

## References

| File | What it contains |
|---|---|
| `references/adr-patterns.md` | ADR template, common patterns, lifecycle |
| `references/architecture-diagrams.md` | C4 model with Mermaid: context, containers, components |
| `references/changelog-guide.md` | Keep a Changelog format, when to update |

## Related skills

- [Knowledge Management](../knowledge-management) - To keep the knowledge base up to date
- [Spec-Driven Development](../spec-driven-development) - To document scaffolding decisions
