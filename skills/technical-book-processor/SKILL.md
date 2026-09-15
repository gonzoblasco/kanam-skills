---
name: "technical-book-processor"
description: "Process technical books chapter by chapter: extract learnings, formalize ADRs, implement exercises, commit atomically"
---

# Technical Book Processor

Process technical books chapter by chapter, extracting learnings, formalizing architectural decisions as ADRs, implementing exercises in a companion project, and committing atomically.

## When to Use

- You have a technical book (PDF, text, or chapters) and want to work through it actively
- You want to generate documentation, ADRs, and a working project from the book
- You want to leave a public trail of your learning (portfolio value)

## Workflow

### 1. Project Setup

```bash
mkdir -p projects/<book-slug>/.knowledge
```

Create the following files in `.knowledge/`:

- **BRIEF.md** - origin, objective, stack, format
- **DEFINITION.md** - book details, structure, criteria
- **ROADMAP.md** - phases (reading, implementation, publication)
- **STATUS.md** - chapter progress table
- **LEARNINGS.md** - cumulative, one section per chapter

### 2. Per-Chapter Processing

For each chapter the user provides:

#### a. Read & Extract
Read the chapter text and extract:
- Key concepts (numbered list)
- Quotes worth remembering
- Questions for further exploration
- Connections to existing experience

#### b. Write LEARNINGS
Append a new section to `LEARNINGS.md` with:
- `## Chapter N - Title`
- `### Key concepts`
- `### Quotes to remember`
- `### Questions to explore`
- `### Connections to prior experience`

Write it in the same language as the working session.

#### c. Create ADR (if applicable)
If the chapter introduces a significant architectural pattern or decision, create an ADR:

```bash
projects/<book-slug>/.knowledge/ADR-NNN-pattern-name.md
```

ADR template:
```markdown
# ADR-NNN - Pattern Name

**Date:** YYYY-MM-DD
**Context:** Chapter N of "Book Title"
**Source:** Author / Framework team

## Decision

[One-line decision statement]

## Detail

[Explanation of the pattern, when to use, tradeoffs]

## Consequences

**Positive:** [...]
**Negative:** [...]

## Notes

[Optional: connections to other ADRs, framework-specific notes]
```

#### d. Implement (if applicable)
If the chapter has exercises or code:
1. Get the base code (start folder from book repo, or previous chapter's solution)
2. Apply the chapter's changes
3. Run build and verify
4. Commit atomically to the project repo

#### e. Update STATUS
Mark the chapter as completed in `STATUS.md`.

### 3. Commit Strategy

**Workspace commits** (`.knowledge/`):
```
docs(<book-slug>): add chapter N - title
```

**Project commits** (companion app):
```
feat: chapter N feature description
```

Always `git pull --rebase` before push. Use `git -c core.hooksPath=/dev/null` if pre-commit hooks interfere.

### 4. Companion Project

If the book has a demo app:
- Initialize git in the project folder
- Create `.gitignore` (node_modules, build, .env, etc.)
- Push to its own GitHub repo
- One commit per chapter (or per logical group of chapters)

### 5. Completion

When all chapters are processed:
- Mark STATUS as COMPLETE
- Push final workspace commit
- Celebrate 🎉

## Example Output

After processing a 17-chapter book:
- 17 LEARNINGS sections
- 17 ADRs
- 1 working demo app
- 5-10 commits across workspace + project repos

## Rules

- Write LEARNINGS in the same language as the session
- ADRs and commits in English
- Verify build before marking a chapter as complete
- Skip purely conceptual chapters (no code changes needed)
- Use a plain hyphen (-), never an em dash
