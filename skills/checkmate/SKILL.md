---
name: "checkmate"
description: "Goal-to-execution-to-verification loop with worker + judge"
---

# checkmate

## Description
Turns a task description into explicit pass/fail criteria, spawns a worker agent to attempt the task, runs a judge agent against the criteria, and loops with accumulated feedback until everything passes. Interactive mode (you review criteria and approve each checkpoint) or batch (autonomous).

## When to use it
- For coding tasks where the definition of done must not drift
- For research reports that must cover specific topics
- For documents that must meet a quality checklist
- For data transformations where the output must match a spec
- To automate QA loops that would require manual reviews

## Workflow
1. Describe the task in natural language
2. checkmate generates pass/fail criteria (review in interactive mode)
3. Worker attempts the task
4. Judge evaluates against the criteria
5. If it fails, feedback loop with accumulated context
6. When everything passes, deliver the result

## Related tooling

| Skill / Script | Use |
|---|---|
| `scripts/test-skills.sh` (workspace root) | Validate scripts that the worker/judge generate for the workspace. |
| `code-review-and-quality` | Quality review of the output when it is code (absorbed into review-quality). |
| `qa-patrol` | Additional automated QA to verify acceptance criteria. |

## Notes
- Use interactive mode for critical tasks (auth, payments, data models)
- Batch mode only for well-defined, low-risk tasks
- The judge is a role separate from the worker, preventing definition of done drift
