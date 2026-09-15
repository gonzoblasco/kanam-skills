---
name: "knowledge-management"
metadata:
  category: "Governance"
  tags:
    - knowledge
    - documentation
    - memory
description: "Knowledge Management workflow: governance, synchronization and evolution of the project knowledge base. Maintains a single source of truth."
user-invocable: false
---

# Workflow: Knowledge Management

## Purpose

Manage the project's persistent knowledge throughout its entire lifecycle.

It does not develop features.

It does not modify business code.

Its responsibility is to keep documentation consistent, updated and useful for humans and agents.

---

# Philosophy

> Every decision deserves a home.

Documentation is not a deliverable.

It is a shared memory.

All important knowledge must exist only once and be easily discoverable.

---

# When to Use It

- when finishing a workflow
- before starting a new session
- before creating a PR
- after closing an epic
- after a retrospective
- when architectural decisions change
- when inconsistencies appear

---

# Known Artifacts

See [artifact catalog](./references/artifacts.md).

---

# Principles

Single Source of Truth.

Do not duplicate knowledge.

Document decisions, not conversations.

Prefer updating over creating new files.

Eliminate obsolete knowledge.

Maintain traceability.

---

# Phases

## 1. Discovery

Detect:

- which documents exist
- which are missing
- which are empty
- which seem abandoned

Build a knowledge map.

---

## 2. Ownership

Determine the owner of each piece of information.

Examples:

Architecture

↓

ARCHITECTURE.md

Technical decision

↓

ADR

Current state

↓

STATUS.md

History

↓

CHANGELOG.md

Never duplicate.

---

## 3. Consistency Audit

Look for contradictions. See [knowledge checklist](./references/checklist.md).

Generate a report.

Never modify automatically.

---

## 4. Freshness

Detect old knowledge.

Questions:

How long since it was last updated?

Is it still valid?

Does it reference deleted files?

Does it talk about features that no longer exist?

Classify:

🟢 Current

🟡 Review

🔴 Obsolete

---

## 5. Knowledge Graph

Relate information.

Example:

Feature

↓

Epic

↓

ADR

↓

PR

↓

CHANGELOG

↓

HANDOFF

↓

STATUS

Build cross-references.

---

## 6. Compression

Reduce redundancy.

Search for:

- repeated text
- repeated tables
- repeated examples
- duplicated decisions

Propose consolidation.

Never delete automatically.

---

## 7. Evolution

Detect:

- documents that should be split
- documents that are too small
- new documents needed
- unnecessary documents

Propose improvements.

---

## 8. Publishing

Update index.

Verify links.

Verify references.

Update dates.

**Synchronize CONTRIBUTING.md:** if there are changes in open PRs, target repos, or contribution chains, update the PR registry in CONTRIBUTING.md using the full chain format (issue → third-party PR → our contribution → our PR → context).

Generate final report.

---

# Outputs

KNOWLEDGE_REPORT.md

Knowledge Map

Inconsistencies found

Obsolete documents

Missing documents

Consolidation proposals

Knowledge Graph

---

## Helper Scripts

Scripts in `skills/knowledge-management/scripts/`:

| Script | Usage |
|---|---|
| `check-refs.sh` | Verifies that internal documentation links exist and are not broken. Use in Phase 1 (Discovery) and before merging docs. |
| `knowledge-audit.sh` | Audits knowledge files that are empty, duplicated, without an owner, or without recent updates. Generates a report. Use in Phase 1 and Phase 5 (Maintenance). |
| `knowledge-graph.py` | Builds a relationship graph between documents. Use in Phase 1 to understand dependencies. |

---

# Decisions

Can:

✔ detect inconsistencies

✔ recommend consolidations

✔ build a knowledge map

✔ generate reports

✔ update indexes

Never:

✖ invent decisions

✖ overwrite ADRs

✖ delete documentation

✖ change STATUS automatically

✖ modify knowledge without approval

---

# Checklist

Is there a single source for each decision?

Are there contradictions?

Are there abandoned documents?

Are there broken references?

Is there duplication?

Is there undocumented knowledge?

Can the project be understood without reading the chat history?

## Learning Signals - When to Log Automatically

Do not wait for the user to tell you "write this down". These signals trigger automatic logging to `docs/LEARNINGS.md` or `memory/YYYY-MM-DD.md`:

**Explicit corrections:**
- "No, that's not how it is..." / "It should actually be..."
- "You got it wrong on..." / "That is wrong"
- "I told you before..." / "I always do X, not Y"
- "Stop doing X" / "Why do you keep doing..."

**Explicit preferences:**
- "I like it when..." / "Always do X for me"
- "Never do Y" / "My style is..."
- "For [project], use..."

**Recurring patterns:**
- Same instruction 3+ times
- A workflow that works well repeatedly
- the user praises a specific approach

**Do not log:**
- One-off instructions ("do X now")
- File-specific context ("in this file...")
- Hypotheses ("what if...")

## Conflict Resolution - Contradictory Lessons

When two lessons in `docs/LEARNINGS.md` contradict each other:

1. **More specific wins** - project > domain > global
2. **More recent wins** - same level of specificity
3. **If ambiguous** - ask the user

## Common Traps - Typical Learning Mistakes

- **Learning from silence** - do not infer preferences because the user did not say anything. Wait for an explicit correction or repeated evidence.
- **Promoting too fast** - one occurrence is not a pattern. Wait for 3+ repetitions before promoting to SOUL/TOOLS/AGENTS.
- **Always reading everything** - do not load entire files when not needed. Load only what the context requires.
- **Compacting by deleting** - do not delete old lessons. Merge, summarize or archive, but do not lose history.

## DREAMS.md - Scheduled Memory Consolidation

The daily logs (`memory/YYYY-MM-DD.md`) are raw data. Periodically, consolidate what matters into `MEMORY.md` and archive the old stuff.

**When:** every ~7 days or when MEMORY.md approaches its limit, or when `memory/` exceeds 30 files.

**Process:**
1. Read recent daily logs (last 7 days)
2. Identify patterns, decisions, preferences worth keeping
3. Update MEMORY.md with the new content
4. **Consolidate memory/:** archive individual sessions (`YYYY-MM-DD-HHMM.md`) and keep only one consolidated file per day (`YYYY-MM-DD.md`). If the consolidated file already exists, move the individual ones to `memory/archive/`.
5. Archive old daily logs (>90 days) to `memory/archive/`
6. Leave a note in the day's daily log: "Consolidation executed. X entries promoted to MEMORY.md. memory/: N files → M files."

**Lesson:** memory does not maintain itself. Scheduled consolidation prevents MEMORY.md from filling with noise or valuable insights getting lost in forgotten daily logs.

### Anti-Repetition in Consolidation (idea borrowed from memory-lancedb-dreaming)

The real problem with consolidating periodically is that it **repeats the same material** day after day (the same topics, the same lessons, reworded). To avoid it, apply these brakes when consolidating:

1. **Exclude promoted** - if a topic/lesson is already in MEMORY.md or LEARNINGS.md, DO NOT promote it again. Only update it if it changed (do not duplicate it).
2. **Text-level dedupe** - before promoting something, compare its text against what was already consolidated in the last ~30 days. If it is similar (paraphrase of the same topic), discard or merge, do not create a new entry.
3. **Theme cooldown** - if a topic was consolidated less than ~7 days ago, do not promote it again (it would come out again under another wording). Wait for real progress, not a repetition.
4. **Narrative freshness** - if there is not enough new material in the period, do NOT force a long consolidation. Better to consolidate only the specific items or skip the cycle. Do not fabricate narrative from recycled content.
5. **Idle novelty** - if you go several cycles (e.g. 7 days) without promoting anything new, check whether the consolidation is stuck in a loop of repeating the same thing; adjust to look for only genuinely new material.

**Anti-repetition flow when consolidating:**
```
read recent dailies
  -> for each candidate topic:
     - already in MEMORY.md?  → skip (exclude promoted)
     - similar to something consolidated <30 days ago? → merge or skip (dedupe)
     - same topic as <7 days ago? → skip (cooldown)
     - if no news → do not force narrative (freshness)
  → promote only what is genuinely new to MEMORY.md/LEARNINGS.md
```

**Lesson:** consolidation is not a copy-paste of the dailies; it is distilling only what is new. Repeating consolidated material dirties MEMORY.md and wastes the exercise.

## Noise Filtering - What Not to Persist to Memory

Idea borrowed from the Honcho Memory plugin (ClawHub): filter the noise before it enters memory, so the system does not fill with operational junk. In our setup the capture is curated (Kanam consciously writes the daily), but there are patterns that must NOT persist:

**Do NOT write in dailies / memory:**
- **HEARTBEAT_OK** - heartbeat acknowledgments (we already have HEARTBEAT.md for that)
- **Cron/reminder boilerplate** - "cron X fired", "reminder triggered" - only if it adds something new, not the mere event
- **Queued message headers** - headers of queued messages
- **Startup/session boilerplate** - the startup ritual itself (unless something important emerges from it)
- **Obvious confirmations** - "done", "ok", "finished" without context worth keeping
- **Execution noise** - commands that ran fine, green build without incident, routine checks that passed

**If the idea appears:**
- Is it a decision/preference/lesson? → MEMORY.md or LEARNINGS.md
- Is it task progress? → todos/STATUS
- Is it session context? → the daily, but only the substantive part
- Is it just operational noise? → do NOT persist

This rule keeps memory curated and prevents it from filling with operational noise that adds no value. The same principle applies to DREAMS: when consolidating, discard noise (HEARTBEAT, cron, confirmations) that may have entered the daily logs.

## Related Skills

- [Engineering Governance](../engineering-governance): To audit knowledge quality
- [Technical Documentation](../tech-docs): To create and maintain technical documentation
