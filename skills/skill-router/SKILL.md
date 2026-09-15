---
name: skill-router
metadata:
  category: "Orchestration"
  tags:
    - skills
    - routing
    - selection
description: "Suggests which skill to use for a given task. Given a prompt or objective, it matches against the available skills (by keywords and local semantic embeddings) and returns the top suggestions. Use when starting a task to know which skill applies."
user-invocable: false
---

# Skill Router

Suggest which skill to apply to a task, using local matching (keyword + embeddings). Useful when a skill collection grows past the point where you remember what exists.

## When to use it

- When starting a task/objective and you're not sure which skill(s) to apply.
- When there are multiple candidate skills and you want to prioritize.
- To recall which skills exist and which one fits the current task.

## How to use it

### List available skills

```bash
./scripts/skill-router.py --list
```

### Suggest skills for a task

```bash
./scripts/skill-router.py "<task description>"
./scripts/skill-router.py -n 5 "<task>"   # top 5
```

### Interpreting results

- Each suggestion shows: skill name, score, match type (embed = semantic, keyword = by word), and L1 (number of matching keywords).
- The **embedding (semantic) score dominates** - it reflects the real intent of the task.
- The keyword (L1) match is reinforcement: it adds a small bonus if the task contains the skill's keywords.
- If there are no clear matches, reconsider the description or check `--list`.

## Validated examples

| Task | Top suggested skill |
|---|---|
| "review this code before merging" | code-review-and-quality |
| "set up a CI/CD pipeline" | ci-cd-and-automation |
| "validate a component's accessibility before opening an OSS PR" | a11y-at-validation, oss-contribution |
| "design a REST API for the module" | api-and-interface-design |

## Requirements

- **A local embedding model** served by Ollama (or any OpenAI-compatible endpoint).
- Python 3 + urllib (standard) + numpy (optional).

## Limits

- Matching is not perfect: internal infrastructure tasks (e.g. "save session") may not match well. Use your own judgment - the router is a suggestion, not an authority.
- It only scans the local `skills/` directory (not bundled plugin skills or external collections).
- It needs the embedding endpoint running for semantic match (otherwise it falls back to keyword match only).

## Related

- **Agent orchestration pipelines**: a pipeline where an orchestrator decides which skill to use per unit. The router is the lookup; the pipeline is the policy.
- [Knowledge Management](../knowledge-management): managing the skills/knowledge base.
