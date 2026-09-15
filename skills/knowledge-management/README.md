# Knowledge Management

Manages the project's knowledge base.

## What Is It For?

To **keep documentation consistent, updated and useful** for humans and agents. A single source of truth. It does not develop features or modify business code.

**Philosophy:** Every decision deserves a home. Documentation is not a deliverable; it is shared memory.

## When to Use It?

- When finishing a workflow
- Before starting a new session
- After closing an epic
- When architectural decisions change
- When inconsistencies appear between documents

## How Is It Used?

### Full Workflow

1. **Discovery** - detect which docs exist, which are missing, which are abandoned
2. **Ownership** - determine the owner of each piece of information
3. **Consistency Audit** - look for contradictions between documents
4. **Freshness** - detect old knowledge (🟢 Current / 🟡 Review / 🔴 Obsolete)
5. **Knowledge Graph** - relate information (Feature → ADR → PR → CHANGELOG)
6. **Compression** - reduce redundancy, propose consolidation
7. **Evolution** - detect docs that should be split or merged
8. **Publishing** - update index, verify links

### Useful Scripts

```bash
# Audit the knowledge base
./scripts/knowledge-audit.sh

# Verify cross-references
./scripts/check-refs.sh

# Generate knowledge graph
python3 scripts/knowledge-graph.py
```

## References

| File | Contents |
|---|---|
| `references/artifacts.md` | Complete catalog of knowledge artifacts |
| `references/checklist.md` | Checklist: discovery, consistency, freshness, graph, compression |
| `references/knowledge-graph.md` | How to build the knowledge graph |
| `references/freshness-policy.md` | Update and archival policy |

## Related Skills

- [Engineering Governance](../engineering-governance) - To audit knowledge quality
- [Technical Documentation](../tech-docs) - To create and maintain technical documentation
