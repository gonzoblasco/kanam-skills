---
name: openspec
description: "Use OpenSpec CLI for spec-driven development: create change proposals, write spec deltas, design docs, tasks, and archive approved changes."
metadata:
  version: 1.0.0
  author: Kanam
  tags: ["openspec", "spec-driven-development", "planning", "documentation", "workflow"]
allowed-tools:
  - exec
  - read
  - write
  - edit
  - skill_workshop
---

# OpenSpec

Use the OpenSpec CLI (`@fission-ai/openspec`) to practice spec-driven development inside projects. This skill complements `agent-workflow`: `agent-workflow` defines *how* to work, `openspec` defines *where* to write specs and changes.

## When to use

Use this skill for any non-trivial change in a project that has OpenSpec initialized:

- New feature
- Behavior change
- Refactor that changes behavior
- API change
- UI/UX change with spec-level impact
- Any change that benefits from an agreed spec before code

Skip for:
- Pure config/tooling/docs changes (set `skip_specs: true` if using OpenSpec)
- One-line fixes with no behavior change
- Throwaway experiments

## Requirements

- Node.js >= 20.19.0
- `@fission-ai/openspec` installed globally:
  ```bash
  npm install -g @fission-ai/openspec@latest
  ```
- OpenSpec initialized in the project:
  ```bash
  openspec init --tools none
  ```

## Project structure

After `openspec init`, the project has:

```
openspec/
├── config.yaml              # OpenSpec configuration
├── specs/                   # Source-of-truth specs
│   └── auth/spec.md
│   └── user/spec.md
├── changes/                 # Active change proposals
│   └── add-2fa/
│       ├── .openspec.yaml
│       ├── proposal.md
│       ├── specs/
│       │   └── auth/spec.md      # Delta spec
│       ├── design.md
│       └── tasks.md
└── changes/archive/         # Archived changes
```

## Workflow

### Phase 1: Initialize (one-time per project)

```bash
cd projects/my-app
openspec init --tools none
```

This creates the `openspec/` structure. It does not configure IDE-specific slash commands because OpenClaw uses the CLI directly.

### Phase 2: Create a change proposal

```bash
openspec new change add-login-button
```

Then generate:

- `openspec/changes/add-login-button/proposal.md` — Why, What Changes, Capabilities, Impact

Use `openspec instructions proposal --change add-login-button` to get the exact template and guidance.

### Phase 3: Write spec deltas

For each capability declared in the proposal:

- Create `openspec/changes/add-login-button/specs/<capability>/spec.md`
- Use the delta format:
  - `## ADDED Requirements`
  - `## MODIFIED Requirements`
  - `## REMOVED Requirements`

Use `openspec instructions proposal --change add-login-button` for the template.

### Phase 4: Technical design (optional)

Write `openspec/changes/add-login-button/design.md` when the implementation approach is non-obvious.

### Phase 5: Tasks

Write `openspec/changes/add-login-button/tasks.md` as a checklist:

```markdown
## 1. Database
- [ ] 1.1 Add column
- [ ] 1.2 Create migration

## 2. Backend
- [ ] 2.1 Update endpoint

## 3. Frontend
- [ ] 3.1 Update component
```

### Phase 6: Validate

```bash
openspec validate add-login-button
openspec status --change add-login-button
openspec show add-login-button
```

## Helper scripts relacionados

| Skill / Script | Uso |
|---|---|
| `product-discovery/scripts/generate-openspec.sh` | Genera un OpenSpec a partir de la definición del producto cuando no hay CLI instalado. |
| `architecture-designer` | Diseña la arquitectura que luego se documenta con OpenSpec. |
| `tech-docs/scripts/generate-adr.sh` | Genera ADRs para decisiones arquitectónicas que afectan el spec. |

### Phase 7: Implement

Execute tasks one by one. Mark tasks complete as you go. Run tests/lint/build after each task.

### Phase 8: Archive

```bash
openspec archive add-login-button --yes
```

This merges the delta specs into `openspec/specs/` and moves the change to `openspec/changes/archive/`.

## Integration with agent-workflow

Combine with `agent-workflow`:

1. `agent-workflow` Phase 1 (Design Gate) becomes writing the OpenSpec proposal and deltas.
2. `agent-workflow` Phase 2 (Implementation Plan) becomes the OpenSpec `tasks.md`.
3. `agent-workflow` Phase 3 (TDD) executes the tasks.
4. `agent-workflow` Phase 4 (Code Review) reviews the implementation.
5. `openspec archive` finalizes the change.

## Helper commands

```bash
# Check current state
openspec list
openspec list --specs
openspec status --change <change-name>

# Get instructions for the next artifact
openspec instructions proposal --change <change-name>
openspec instructions apply --change <change-name>
openspec instructions archive --change <change-name>

# Validate and view
openspec validate <change-name>
openspec show <change-name>

# Create and archive changes
openspec new change <change-name>
openspec archive <change-name> --yes
```

## Anti-patterns

- Creating `tasks.md` before `proposal.md` and spec deltas
- Listing capabilities in the proposal but not writing the corresponding delta specs
- Writing implementation details in `proposal.md` instead of `design.md`
- Skipping `openspec validate`
- Archiving without all tasks complete
- Using OpenSpec as a todo list for trivial changes

## Best practices

- Keep proposals concise (1-2 pages).
- Every capability must map to a real spec file.
- Use `### Requirement: <name>` and `#### Scenario: <name>` format in specs.
- Use SHALL/MUST in requirement text.
- Run `openspec validate` before applying or archiving.
- Update `CHANGELOG.md` after archiving.

## Notes

- OpenSpec does not replace `AGENTS.md`. It adds a structured spec layer.
- The CLI emits anonymous telemetry by default. Set `OPENSPEC_TELEMETRY=0` to disable.
- OpenSpec is not an MCP server; this skill uses the CLI directly.
- For projects that do not use OpenSpec, fall back to `.knowledge/specs/`, `.knowledge/plans/`, and `agent-workflow`.
