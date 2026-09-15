---
name: "project-closure"
metadata:
  category: "Workflow"
  tags:
    - project
    - closure
    - adr
description: "Complete project closure: capture the decision, the learning and the state in ADR + DB + skill. Reproducible with a script."
user-invocable: false
---

# project-closure

> Close a project completely and immortalize its knowledge in ADR + DB + skill.

## Purpose

When a project is finished, a commit is not enough. You have to **capture the decision, the learning and the state** in the three places where institutional memory persists: an ADR (decision), the database (sessions + learnings), and the associated skill documentation. All reproducible with a script.

## When to use it

- The user says "let's close the project", "let's document X", "make it stick".
- A project hits its success criterion and there will be no more iteration.
- A series of sessions closes a cycle (e.g. a new system).

**Important:** "closing a project" is not "leaving the workspace". It is documenting the work durably, not abandoning the working relationship. The knowledge stays accessible for future sessions.

## Closure workflow

```
Project finished
    │
    ▼
┌─────────────────────────────────────────────┐
│ 1. Identify what is closing and its scope    │
│    (is it a project? a system? a phase?)     │
└─────────────────┬───────────────────────────┘
                  │
    ┌─────────────▼─────────────┐
    │ 2. Write the ADR          │  docs/adr/ADR-XXX-<slug>.md
    │    (decision + rationale +│  Format: Status/Decision/Consequences/Alternatives
    │    validation)            │
    └─────────────┬─────────────┘
                  │
    ┌─────────────▼─────────────┐
    │ 3. Record in the DB       │  memory.db:
    │    - daily_notes (summary)│  sessions (T-score, model, thinking)
    │    - sessions             │  learnings (if there is a new lesson)
    └─────────────┬─────────────┘
                  │
    ┌─────────────▼─────────────┐
    │ 4. Skill + script          │  skills/<slug>/SKILL.md
    │    to make it reproducible │  + scripts/project-closure.sh
    └─────────────┬─────────────┘
                  │
    ┌─────────────▼─────────────┐
    │ 5. Commit + push + daily   │  workspace commit, skills mirror, updated daily
    └───────────────────────────┘
```

## Step-by-step

### 1. Identify the closure

Before writing anything, **clarify the scope** with the user:
- Is the whole project closing, or just a phase/system?
- What is the most important decision to leave documented?

**Don't assume:** a "closure" can be existential (the whole workspace) or specific (one system). Confirm before spending effort.

### 2. Write the ADR

Number the next ADR (`ls docs/adr/` and +1). Format:
- **Status / Deciders / Date / Origin**
- **Context:** the problem that motivated the decision.
- **Decision:** what was decided, concise and actionable.
- **Implementation:** files and components.
- **Consequences:** positives and limitations.
- **Alternatives:** what was discarded and why.
- **Validation:** empirical evidence that the decision is right.

### 3. Record in the DB

Use Python + sqlite3 against `memory/memory.db`:

```sql
-- daily_notes: closure summary (type='daily')
INSERT INTO daily_notes (date, type, content, source_file, created_at) VALUES (...);

-- sessions: with a complexity score if applicable
INSERT INTO sessions (date, title, tags, complexity_score, model_used,
  thinking_level, summary, content_bare, created_at) VALUES (...);

-- learnings: if there is a new, durable lesson
INSERT INTO learnings (category, title, content, tags, created_at, updated_at) VALUES (...);
```

### 4. Create the skill + closure script

The skill documents the workflow (this file). The script automates it:

```bash
./scripts/project-closure.sh --name "<slug>" --title "<title>" \
  --summary "<summary>" --complexity <T-score> --model "<model>" \
  --create-adr --tag "pipeline,closure" [--learning]
```

What the script does:
1. Creates the ADR from the template.
2. Records in `daily_notes` + `sessions` (+ `learnings` if requested).
3. Returns the summary for the daily markdown.

### 5. Final commit

- Commit the workspace with the ADR + script + skill.
- Sync the skills mirror.
- Push with `--rebase`.

## Key rules

1. **ADR = immutable decision.** What is documented is not re-opened unless there is new evidence.
2. **Reference is not the project.** When untracking/cleaning, never delete local data (`.env`, `*.db`, uploads). `git rm --cached` preserves the file on disk.
3. **Closure is not abandonment.** The knowledge stays in ADR + DB to be picked up again. The working relationship continues.
4. **Confirm scope first.** An existential closure and a specific one are very different jobs.
5. **Everything reproducible.** The `project-closure.sh` script should make the closure repeatable, not manual.

## Status

- Version: 1.0.0
- Created: 2026-08-31
- Depends on: `scripts/project-closure.sh`, `memory/memory.db`, `docs/adr/`
