# Freshness Policy - Knowledge Management Reference

Política de actualización y obsolescencia de documentación.

## Freshness Tiers

| Tier | Max Age | Action |
|---|---|---|
| 🟢 **Active** | < 7 days | No action needed |
| 🟡 **Review** | 7-30 days | Quick review, update if needed |
| 🟠 **Stale** | 30-90 days | Full review, update or archive |
| 🔴 **Obsolete** | > 90 days | Archive or delete |

## Per-Document Policy

| Document | Max Age | Review Trigger |
|---|---|---|
| `STATUS.md` | 7 days | After any session |
| `HANDOFF.md` | 1 day | Every session start/end |
| `TRACKER.md` | 7 days | After task changes |
| `CHANGELOG.md` | Per release | After PR merge |
| `ADRs` | Per decision | When architecture changes |
| `BRIEF.md` | Per milestone | When scope changes |
| `ROADMAP.md` | Per quarter | Planning cycle |
| `ARCHITECTURE.md` | Per major change | When architecture changes |

## Archival Process

1. Mark document as `[ARCHIVED]` in filename or header
2. Add archival date and reason
3. Update all cross-references
4. Move to `archive/` directory if applicable
5. Never delete without archival trail

## Freshness Check Script

```bash
#!/usr/bin/env bash
# Check document freshness
for doc in STATUS.md HANDOFF.md TRACKER.md; do
  if [[ -f "$doc" ]]; then
    DAYS=$(( ($(date +%s) - $(stat -f %m "$doc")) / 86400 ))
    if [[ "$DAYS" -gt 30 ]]; then
      echo "🔴 $doc: $DAYS days old (stale)"
    elif [[ "$DAYS" -gt 7 ]]; then
      echo "🟡 $doc: $DAYS days old (review)"
    else
      echo "🟢 $doc: $DAYS days old (fresh)"
    fi
  fi
done
```

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [Artifacts](../references/artifacts.md) - Catálogo de artefactos
- [Knowledge Graph](./knowledge-graph.md) - Grafo de conocimiento
