---
name: "engineering-governance"
metadata:
  category: "Governance"
  tags:
    - governance
    - audit
    - continuous-improvement
description: "Engineering Governance workflow: continuous evolution of the AI Engineering OS. Audits workflows, consolidates learnings, removes duplication and proposes systemic improvements."
user-invocable: false
---

# Workflow: Engineering Governance

## Purpose

Maintain and evolve the system of workflows, principles and engineering standards.

It does not develop features.
It does not write product code.

Its client is the AI Engineering OS itself.

---

# Philosophy

> Build the system that builds the system.

The goal is not to optimize one project.

The goal is to continuously improve the organization that develops projects.

---

# When to use it

- after closing a milestone
- after closing an important epic
- after several similar PRs
- after a retrospective
- when repetitive bugs appear
- when several workflows start duplicating responsibilities
- when industry best practices change

Never during the implementation of a task.

---

# Inputs

- all workflows
- ADRs
- retrospectives
- STATUS.md
- CHANGELOG.md
- HANDOFF.md
- execution metrics
- bugs
- incidents
- human feedback
- **external incidents** (e.g. OpenAI/Hugging Face July 2026) - lessons on security, agent architecture, attack/defense patterns

---

# Phases

## 1. System Health Check

Answer:

- Which workflows are almost never used?
- Which workflows generate the most value?
- Which parts of the process generate friction?
- Where do bottlenecks appear?
- Which tasks are still manual?

---

## 2. Pattern Mining

Look for repetitive patterns.

Examples:

- same checklist copied over
- same validations
- same decisions
- same prompts
- same errors
- same solutions
- **same patterns in external incidents** (e.g. agents escaping sandboxes, zero-days in shared infrastructure)

If a pattern appears repeatedly:

propose extracting it.

---

## 3. Workflow Audit

Audit each workflow. See [audit checklist](./references/audit-checklist.md).

Classify:

🟢 Healthy

🟡 Needs Review

🔴 Needs Refactor

---

## 4. Knowledge Consistency

Look for inconsistencies between:

- ADRs
- STATUS
- ROADMAP
- TRACKER
- HANDOFF
- CHANGELOG

Detect contradictory documents.

Never modify automatically.

Generate recommendations.

---

## 5. Industry Review

Compare the AI Engineering OS against the state of the art.

Look for new practices related to:

- AI Engineering
- Agentic Systems
- MCP
- RAG
- Testing
- Accessibility
- DevOps
- Architecture
- OSS

Answer:

What should we adopt?

What should we drop?

---

## 6. Governance Review

Verify:

- obsolete workflows
- workflows that are too large
- mixed responsibilities
- skills that should be merged
- skills that are too generic

Propose:

- merge
- split
- deprecation
- new version

Never modify automatically.

---

## 7. Engineering Principles

Audit the principles.

Questions:

Are they still valid?

Are there contradictions?

Is any missing?

Examples:

- Accessibility First
- Security by Default
- Progressive Disclosure
- Small Commits
- Spec Driven Development
- HTML before ARIA
- Documentation as Code

---

## 8. Improvement Proposal

Generate RFCs. See [RFC template](./references/rfc-template.md).

Never apply changes automatically.

---

## Outputs

- GOVERNANCE_REPORT.md

- RFCs

- proposals for new workflows

- deprecation proposals

- improvements to Engineering Principles

- improvement backlog for the AI Engineering OS

---

# Quality Gates for Skills

Every change to a skill script must pass the following gates before reaching `main`:

## 1. Syntax Check

`./scripts/test-skills.sh` verifies that every `.sh` file passes `bash -n` and every `.py` file passes `python3 -m py_compile`.

- 75 bash scripts and 28 python scripts are checked in seconds.
- It runs in the pre-commit hook and in CI.

## 2. Functional Tests

`npm test` runs:

- `test-skills.sh` (syntax)
- `npx bats tests/bash/` - 17 functional tests over critical scripts
- `pytest tests/python/` - 8 functional tests over critical Python scripts

Tests live in `tests/bash/` and `tests/python/`. When you add or modify a script with regression risk, add a test.

## 3. Pre-commit Hook

`.git/hooks/pre-commit` runs syntax + bats + pytest. If it fails, the commit is not created.

Installation:

```bash
cp scripts/pre-commit.template .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## 4. CI on GitHub Actions

`.github/workflows/skills-ci.yml` runs the same `npm test` on Ubuntu for every push/PR.

## When to require tests

- If the script uses `eval`, pipes with `grep -c`, macOS-specific `date`, or arithmetic with counters.
- If the script touches the filesystem, git, or parses files.
- If the script is used by another skill in its normal flow.

## Documented anti-patterns

- `eval "$cmd"` - replace with named functions.
- `grep -c ... || echo "0"` - produces `0\n0`; use `|| true` + `${VAR:-0}`.
- `sed 's/.*/\u&/'` - GNU-only; use `awk` or `perl`.
- `find A -name B -o -name C -exec ...` - applies `-exec` only to the second `-name`; use `\( ... \)`.
- `PASS=***` or `PASS=*** + 1))` - breaks counters; initialize to `0` and use `$((PASS + 1))`.
- `sed -i ''` - macOS-only; use `sed -i.bak` + `rm .bak`.

# Decisions

It can:

✔ recommend

✔ prioritize

✔ detect

✔ compare

✔ generate RFCs

Never:

✖ modify workflows automatically

✖ edit ADRs

✖ change principles

✖ delete documentation

Every change requires human approval.

---

# Principles

Stability is worth more than novelty.

Do not optimize without evidence.

Remove complexity before adding features.

Every workflow must have a single responsibility.

Improvements must be incremental.

Decisions must be documented.

Governance exists to reduce the entropy of the system.

---

# Final checklist

- Is there duplication?

- Are there contradictions?

- Is there process debt?

- Are there obsolete workflows?

- Is there undocumented knowledge?

- Are there new patterns that deserve a workflow?

- Is the system better today than a month ago?

## Related Skills

- [Knowledge Management](../knowledge-management): To keep the knowledge base up to date
- [Observability](../observability-and-instrumentation): To measure system health

## Growth Loops - Continuous Improvement Cycles

Four cycles that keep the system evolving:

### 1. Curiosity
Periodically, ask yourself: "What don't I know that would help me do my job better?" Research skills on ClawHub, read documentation, explore new tools.

### 2. Pattern Recognition
When a situation repeats 3+ times, it is not a coincidence - it is a pattern. Document it in LEARNINGS.md and consider promoting it to SOUL/TOOLS/AGENTS.

### 3. Capability Expansion
When a task is done 2+ times and requires the same manual process, consider: can it be skill-ified? can it be automated? can it be documented as a workflow?

### 4. Outcome Tracking
After implementing an improvement, verify: did it actually improve anything? Or did it only add complexity? If there is no measurable improvement, revert.

**Lesson:** continuous improvement is not automatic - it needs explicit cycles. Without them, the system stagnates or gets worse.

## Evaluating External Skills - How to Decide

When reviewing skills from ClawHub (or any external skill), follow this process:

1. **Read the full SKILL.md** - understand what it actually does
2. **Identify what it overlaps** - do we already have an equivalent? in AGENTS.md, LEARNINGS.md, MEMORY.md?
3. **Identify what it adds** - does it have patterns, frameworks or ideas we don't have?
4. **Decide:**
   - **Install** - only if it adds something we don't have AND we cannot integrate it as a convention
   - **Steal ideas** - if it has useful patterns we can adopt in our system
   - **Pass** - if it overlaps what we have or is not relevant
5. **If we steal:** document it in LEARNINGS.md, update AGENTS.md/MEMORY.md as appropriate

**Rule:** prefer integrating patterns as your own convention over installing external skills. Fewer skills = less context burned = a faster and more predictable system.
