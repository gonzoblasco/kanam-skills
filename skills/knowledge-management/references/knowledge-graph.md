# Knowledge Graph - Knowledge Management Reference

Cómo construir y mantener el grafo de conocimiento del proyecto.

## Node Types

| Type | File | Connections |
|---|---|---|
| **Feature** | `BRIEF.md` | → Epic → ADR → PR → CHANGELOG |
| **Decision** | `docs/adr/XXX-*.md` | → PR → CHANGELOG → STATUS |
| **State** | `STATUS.md` | ← ADR ← HANDOFF ← TRACKER |
| **Session** | `HANDOFF.md` | → STATUS → TRACKER → CHANGELOG |
| **Change** | `CHANGELOG.md` | ← PR ← ADR ← HANDOFF |
| **Task** | `TRACKER.md` | → HANDOFF → STATUS |

## Graph Structure

```
BRIEF.md ──→ ROADMAP.md ──→ STATUS.md
                │                │
                ↓                ↓
           EPIC-001.md ──→ ADR-001.md ──→ PR #42 ──→ CHANGELOG.md
                │                                         ↑
                ↓                                         │
           EPIC-002.md ──→ ADR-002.md ──→ PR #43 ────────┘
                                              │
                                              ↓
                                         HANDOFF.md ──→ TRACKER.md
```

## Cross-Reference Format

```markdown
## Related

- [ADR-001: Use Supabase for backend](../docs/adr/001-use-supabase.md)
- [PR #42: Implement auth flow](https://github.com/owner/repo/pull/42)
- [CHANGELOG: v1.2.0](../CHANGELOG.md#120)
- [STATUS: Current state](../STATUS.md)
```

## Automated Checks

```bash
# Check for broken references
grep -r "\.\./" --include="*.md" . | grep -v node_modules | grep -v ".github" | while IFS= read -r line; do
  file=$(echo "$line" | cut -d: -f1)
  ref=$(echo "$line" | grep -oP '\(\K[^)]+')
  if [[ ! -f "$ref" ]]; then
    echo "🔴 Broken reference in $file: $ref"
  fi
done
```

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [Artifacts](../references/artifacts.md) - Catálogo de artefactos
- [Checklist](../references/checklist.md) - Checklist de conocimiento
