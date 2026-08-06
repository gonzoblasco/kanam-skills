# Metrics Definitions — Engineering Governance Reference

Qué métricas trackear, cómo interpretarlas y thresholds.

## Workflow Health Metrics

| Metric | Definition | Threshold | Action |
|---|---|---|---|
| **Usage frequency** | Times workflow is invoked per week | < 1 → consider deprecation | Audit if still needed |
| **Completion rate** | % of invocations that reach final output | < 70% → needs review | Check for friction points |
| **Time to complete** | Average duration from start to output | > 30 min → too slow | Optimize or split |
| **Error rate** | % of invocations with errors | > 10% → needs fix | Debug and patch |
| **Handoff rate** | % that require human intervention | > 20% → too manual | Automate more |

## Knowledge Base Health

| Metric | Definition | Threshold | Action |
|---|---|---|---|
| **Staleness** | Days since last update per doc | > 90 days → stale | Review and update |
| **Coverage** | % of projects with .knowledge/ | < 80% → low coverage | Create missing docs |
| **Contradictions** | ADRs that conflict | > 0 → needs resolution | Governance review |
| **Orphan docs** | Docs without active project | > 3 → cleanup needed | Archive or delete |

## Dependency Health

| Metric | Definition | Threshold | Action |
|---|---|---|---|
| **Vulnerability count** | Open CVEs | > 0 critical → immediate | Fix ASAP |
| **Outdated ratio** | % deps behind latest major | > 20% → tech debt | Plan updates |
| **Dependency count** | Total runtime deps | > 50 → review | Audit necessity |
| **Lock-in score** | Deps without alternatives | > 3 → risk | Plan migration |

## Code Quality

| Metric | Definition | Threshold | Action |
|---|---|---|---|
| **TypeScript strict** | % of files with strict mode | < 80% → improve | Enable strict |
| **Test coverage** | Line coverage | < 60% → low | Add tests |
| **Lint errors** | Biome errors | > 0 → fix | Run lint |
| **Build time** | CI build duration | > 5 min → slow | Optimize |

## Governance Health

| Metric | Definition | Threshold | Action |
|---|---|---|---|
| **Workflow count** | Total skills in workspace | > 25 → too many | Consider merges |
| **Duplicate phases** | Phases shared across 3+ workflows | > 3 → extract | Create shared reference |
| **RFC adoption** | % of RFCs implemented | < 50% → low adoption | Review process |
| **Retro frequency** | Days since last retro | > 30 → overdue | Schedule retro |

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
- [Audit Checklist](../references/audit-checklist.md) — Checklist de auditoría
- [RFC Template](../references/rfc-template.md) — Template de propuestas
