---
name: "git-changelog"
description: "Auto-generate CHANGELOG.md from git history with conventional commits"
---

# git-changelog

## Description
Reads the git history of conventional commits and produces a categorized, markdown-formatted changelog, grouped by type (feat, fix, breaking change, etc.). The output is ready to paste into CHANGELOG.md or a GitHub release.

## When to use it
- Before tagging a new version
- When creating a CHANGELOG.md entry after a sprint
- To review what changed between two git tags
- To detect breaking changes before publishing a package
- To summarize recent commits in a team update

## Workflow
1. Identify the commit range (between tags, dates, or since the last changelog)
2. Run git-changelog with the specified range
3. Review the output and paste it into CHANGELOG.md
4. Commit the updated changelog

## Related tooling

| Skill / Script | Use |
|---|---|
| `tech-docs/scripts/update-changelog.sh` | Inserts an `[Unreleased]` entry into CHANGELOG.md. |

## Notes
- Assumes commits follow the Conventional Commits format
- Requires no external API keys
- The output is markdown, ready to use
