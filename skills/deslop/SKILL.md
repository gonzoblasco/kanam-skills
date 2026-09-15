---
name: "deslop"
description: "Clean AI slop code from branches before PRs"
---

# deslop

## Description
Scans the diff of a branch and removes AI-generated noise: unnecessary defensive null checks, try/catch that doesn't match the project style, redundant type casts, placeholder comments, and lint-disable comments added defensively. Verifies that the build passes after each removal.

## When to use it
- Before opening a PR with AI-generated code
- To clean verbose null checks from generated code
- To remove defensive try/catch blocks that don't belong
- To remove TODO/placeholder comments from scaffolding
- To remove lint-disable comments added by AI

## Workflow
1. Have the branch with the AI-generated changes
2. Run deslop on the branch
3. Review the proposed changes (review mode)
4. If all good, run in auto mode with approval
5. Verify that the build passes
6. Open the PR

## Related tooling

| Skill / Script | Use |
|---|---|
| `code-review-and-quality` | General technical debt and AI slop scan (absorbed into vibe-code-cleanup). Use before deslop to prioritize. |
| `ci-cd-and-automation` | Validate build, typecheck, lint and tests after cleaning. |
| `code-review-and-quality` | Automatic final PR review (absorbed into review-quality). |

## Notes
- Compares each candidate against local context before deleting
- Preserves legitimate guards at trust boundaries
- Verifies the build after each change
