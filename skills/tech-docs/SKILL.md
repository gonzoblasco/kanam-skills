---
name: "tech-docs"
metadata:
  category: "Content"
  tags:
    - documentation
    - adr
    - changelog
description: "Technical Documentation workflow: ADRs, README, API docs, CHANGELOG, technical guides and architectural design."
user-invocable: false
---

# Workflow: Technical Documentation

## Skills it replaces
- `adr-framework`
- `adr-sync`

## Purpose
Creation and management of project technical documentation: ADRs, README, API docs, CHANGELOG, contribution guides and architectural design.

## Phases

### 1. Audience
Who reads these docs? (team devs, external contributors, end users, stakeholders)

### 2. Architectural Design (pre-ADRs)
Before documenting decisions, design the architecture:
- **C4/Mermaid diagrams** - context, containers, components, code
- **Trade-offs** - evaluate stack, pattern and database options
- **Dependency analysis** - project health, versions, compatibility
- **Technical risks** - identify them early

### 3. Structure
Which docs the project needs (README, API docs, guides, ADRs, CHANGELOG, CONTRIBUTING).

### 4. ADRs
Create or sync architectural decisions using the standard format: context, decision, consequences, alternatives considered.

Pattern reference:
- **Hexagonal Architecture** - ports and adapters, inward dependencies
- **Clean Architecture** - layers, dependency rules
- **Domain-Driven Design** - bounded contexts, entities, value objects

### 5. Technical Writing
Write or update docs with concrete examples, not theory. Real code, not pseudocode.

### 6. Review
Coherence, completeness, examples actually work, no broken links, consistent tone.

### 7. Publication
Commit + push, integration with the project.

## Outputs
- Updated README.md
- C4 architecture diagrams
- ADRs in `docs/adr/` (created or synced)
- Updated CHANGELOG.md
- API docs, technical guides
- CONTRIBUTING.md if applicable

## When to use it
- When starting a new project (initial docs + design)
- When an API or feature changes (update docs)
- When closing an epic or milestone (update CHANGELOG + ADRs)
- When an architectural decision needs to be documented
- When a contributor needs clear guides

## Helper Scripts

Scripts in `skills/tech-docs/scripts/`:

| Script | Use |
|---|---|
| `generate-adr.sh "Decision title"` | Creates a sequentially numbered ADR in `docs/adr/`. Use in Phase 4. |
| `update-changelog.sh` | Inserts an `[Unreleased]` entry in CHANGELOG.md. Use when closing an epic or feature. |
| `analyze_codebase.py` | Analyzes the codebase to extract patterns and generate context for docs. Use in Phase 2 (Architectural Design) and Phase 5. |

If these scripts are touched, run `npm test` in the workspace before committing.

## Related Skills

- [Knowledge Management](../knowledge-management): To keep the knowledge base up to date
