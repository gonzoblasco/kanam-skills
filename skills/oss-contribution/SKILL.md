---
name: "oss-contribution"
description: "Contribute strategically to external open source repos: pick targets, triage issues without competing PRs, send PRs, and follow up on the threads we already joined."
metadata:
  category: "Contribution"
  tags:
    - open-source
    - contribution
    - pr
    - issues
    - community
user-invocable: false
---

# Workflow: OSS Contribution

## Relationship with `github`

- **`github`** = the **how**: `gh` commands, MCP server, operation scripts (pr-batch-check, github-mcp).
- **`oss-contribution`** = the **when and why**: strategic workflow, triage, issue and PR tracking, interaction rules, registry.

They don't overlap. `oss-contribution` references `github` scripts instead of duplicating them.

## Purpose

Strategic contribution to external open source repositories: choosing where to contribute, triaging issues, implementing, sending PRs, and **following up** on issues and PRs we already worked on.

## When to use it

- Contributing a fix or feature to an external open source repo
- Triaging issues in target repos to find opportunities
- **Reviewing issues where we already commented and following up on their threads** (the follow-up practice)
- Batch-tracking open PRs in external repos
- Preparing a strategic contribution

## Phases

1. **Pipeline** - target repo selection, tier ranking (see `references/tier-ranking.md`)
2. **Triage** - find issues without competing PRs, evaluate impact. Use `scripts/triage-issues.sh`
3. **Analysis** - understand the bug/feature, root cause analysis. Complex issue =/= complex fix. Check whether the reporter already identified the root cause
4. **Implementation** - fork, branch, fix, tests. Use `scripts/setup-fork.sh`
5. **PR** - clear and human description (not generated). In Tier 0 repos (shadcn/ui, TanStack, Vercel): avoid automation traces in commits and descriptions
6. **Post-PR Watch** - monitor the PR: detect bot comments, requested changes, merges. Use `pr-watch.sh` from `github`
7. **Community** - comment on related issues, cross-referencing. Do it after the PR, not before, to avoid noise if the PR doesn't move forward
8. **Batch** - status check of open PRs. Use `pr-batch-check.sh` from `github`
9. **Registry** - record the full chain in CONTRIBUTING.md (Issue -> third-party PR -> our contribution -> our PR -> context)

## Issue follow-up (key practice)

Besides tracking PRs, **periodically review the issues where we already commented**:

- List issues where the user commented (as author or commenter) that are still open
- Read the new comments: did someone confirm the bug? Did another contributor propose an approach? Did a maintainer ask for something?
- Decide **act vs wait**:
  - **Act** if there is a direct question, an approach we can implement, or an opportunity to position (send the PR, reply with technical analysis)
  - **Wait** if the issue is stalled waiting on maintainer decisions, or if we already replied and there is nothing new actionable
- Record the status in the daily note and in CONTRIBUTING.md

**Lesson (astryx #4777):** when another contributor "wants to take" an issue/PR we already worked on, the winning move isn't to fight over who sends the PR for the weak option - it's **to resolve their objection within the strong option**. Validate their technical point (it gives them credit), but show that the direction we defend has a variant that resolves their objection.

**Lesson (shadcn #11125):** doing the technical analysis in the issue **before** sending the PR (validating the approach with another contributor) makes the PR come out clean and with the root cause already agreed upon. The issue is the place to converge; the PR is the execution.

## PR search rules

- When the user asks to see a PR by number + repo, search directly in that repo with `gh pr view <n> --repo <org/repo>`
- **Do not filter by own author** unless the user specifies "my PRs"
- If the PR is not found, verify the repo is spelled correctly (full org/repo-name)

## Interaction rules in third-party PRs/Issues

### Bots vs Humans

- **Identify the counterpart:** before replying in a thread, check whether the comment author is a bot (github-actions, netlify, codecov, dependabot, etc.) or a person.
- **Do not respond to bots as if they were people.** No greeting by name, no social conversation, no thanking. If you must reply to a bot (e.g., an automated check asking for something), be direct and make clear you are responding to the system, not to a person.
- **Talk to humans like humans.** Natural, straight to the point, no technical document structure.

### Threads and mentions

- **Do not jump into closed/dead threads.** If a PR is closed and there is no direct question toward the user, do not comment. Silence is not an invitation.
- **Mentions as technical reference =/= call to action.** If someone mentions the user as a reference for a bug (e.g., "as @user observed"), no reply is required unless there is an explicit question.
- **PRs closed due to automation detection:** evaluate case by case. Default: do not intervene. If there is a reason to show empathy, comment carefully and ask the user first.
- **Check with the user before publishing (2026-09-02):** before pushing commits to someone else's PR or publishing a reply in a review thread, show the plan/diff to the user and wait for approval. The established flow is draft -> the user approval -> publish. Do not chain multiple push + reply rounds without intermediate verification - each review round is confirmed with the user before acting. Lesson from react-spectrum PR #10554 (3 pushes + 3 replies without verification, explicit correction from the user).
- **OAuth App restrictions in third-party orgs (2026-09-03):** the OpenClaw OAuth token (`gho_`) cannot WRITE (comment, open PRs) in orgs with OAuth App access restrictions (shadcn-ui, radix-ui, facebook, TanStack, adobe, mui, vercel, etc.). Reading works; writing fails with "OAuth App access restrictions". Before publishing in a third-party repo, verify with `gh issue comment` or `gh api` that the write passes; if it fails, the fix is a classic PAT (`ghp_`, scope `repo`) in `~/.openclaw/secrets/github-token` - classic PATs are not subject to those restrictions. Do not retry with the same token.

## Outputs

- PRs to external repos
- Status report of open PRs and issues
- Record in CONTRIBUTING.md (full contribution chain)

## Helper Scripts

Scripts in `skills/oss-contribution/scripts/`:

| Script | Use |
|---|---|
| `triage-issues.sh --repo org/repo` | Triage open issues to find opportunities without competition. Phase 2. |
| `setup-fork.sh --repo org/repo` | Prepares a local fork ready to contribute. Phase 4. |

Scripts from `github` (referenced, not duplicated):

| Script | Use |
|---|---|
| `pr-batch-check.sh [--mine-only]` | Lists open PRs in tracked repos. Phase 8 (Batch). |
| `pr-watch.sh <pr-url>` | Monitors a PR for comments/merges. Phase 6 (Post-PR Watch). |

## Related

- `github` - the how: gh commands, MCP, operation scripts
- `session-lifecycle` - runs the batch check when saving the session
- `code-review-and-quality` - review of own and others' PRs
