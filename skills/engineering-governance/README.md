# Engineering Governance

Continuous evolution of the AI Engineering OS.

## What is it for?

To **maintain and improve the system of workflows, principles and engineering standards**. It is the meta-workflow: its client is the AI Engineering OS itself, not a particular project. It does not develop features, it does not write product code.

## When to use it?

- After closing an important milestone
- When repetitive bugs appear
- When several workflows start duplicating responsibilities
- When industry best practices change
- Periodically, to keep the system healthy

## How is it used?

### Full workflow

1. **System Health Check** - which workflows go unused? what generates friction?
2. **Pattern Mining** - look for repetitive patterns worth extracting
3. **Workflow Audit** - audit each workflow with the checklist
4. **Knowledge Consistency** - look for contradictions between documents
5. **Industry Review** - compare against the state of the art
6. **Governance Review** - detect obsolete, oversized or mixed workflows
7. **Engineering Principles** - audit the principles in force
8. **Improvement Proposal** - generate RFCs

### Useful scripts

```bash
# Audit all skills
./scripts/workflow-audit.sh

# Detect duplicated content across skills
./scripts/detect-duplicates.sh

# Generate governance report
python3 scripts/generate-governance-report.py

# Analyze hotspots in git history
./scripts/hotfiles.sh --top 10

# Code ownership by contributor
./scripts/ownership.sh

# Scan git history for secrets
./scripts/secret-scan.sh
```

## References

| File | What it contains |
|---|---|
| `references/audit-checklist.md` | Checklist to audit each workflow |
| `references/rfc-template.md` | Template to propose improvements |
| `references/metrics-definitions.md` | Metrics: workflow health, knowledge, deps, code quality |
| `references/industry-sources.md` | Sources to monitor: blogs, newsletters, papers |

## Related skills

- [Knowledge Management](../knowledge-management) - To keep the knowledge base up to date
- [Observability](../observability-and-instrumentation) - To measure system health
