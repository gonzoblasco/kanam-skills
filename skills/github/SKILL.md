---
name: "github"
description: "Add official GitHub MCP server wrapper for advanced tools: security alerts, notifications, discussions, project boards, code analysis."
metadata:
  category: "Development"
  tags:
    - github
    - prs
    - issues
    - ci
    - reviews
    - security
    - mcp
    - notifications
    - discussions
---

# GitHub

Use `gh` for common GitHub operations and the official GitHub MCP Server for advanced tools not available in `gh`.

## Two interfaces

### 1. `gh` CLI (default)

Use for:
- Listing/viewing PRs and issues
- Creating PRs/issues/comments
- Checking CI runs
- Basic API queries
- Merging PRs

### 2. GitHub MCP Server (advanced)

Use the wrapper `~/.openclaw/workspace/skills/github/scripts/github-mcp.py` for:
- Security alerts / Dependabot
- Code scanning
- Notifications
- Discussions
- Project boards
- Advanced PR/issue operations
- Code analysis tools

## Requirements

- `gh` CLI authenticated (`gh auth status`)
- GitHub Personal Access Token stored in `~/.openclaw/secrets/github-token`
- Official GitHub MCP binary at `~/.openclaw/bin/github-mcp`

## Writing Rules

- **Always use regular hyphen (-), never em dash (—).** The em dash isn't on a standard keyboard and makes it obvious the text wasn't written by a developer. This applies to PR descriptions, comments, issues, and any GitHub-facing text.

## Auth

```bash
gh auth status
gh auth login
```

The MCP wrapper reads `~/.openclaw/secrets/github-token` automatically.

## gh CLI: PRs

```bash
gh pr list --repo owner/repo --json number,title,state,author,url
gh pr view 55 --repo owner/repo --json title,body,author,files,commits,reviews,reviewDecision
gh pr checks 55 --repo owner/repo
gh pr diff 55 --repo owner/repo
gh pr create --repo owner/repo --title "feat: title" --body-file /tmp/pr.md
gh pr merge 55 --repo owner/repo --squash
```

URLs work directly: `gh pr view https://github.com/owner/repo/pull/55`.

## gh CLI: Issues

```bash
gh issue list --repo owner/repo --state open --json number,title,labels,url
gh issue view 42 --repo owner/repo --json title,body,comments,labels,state
gh issue create --repo owner/repo --title "Bug: ..." --body-file /tmp/issue.md
gh issue comment 42 --repo owner/repo --body-file /tmp/comment.md
gh issue close 42 --repo owner/repo --comment "Fixed in ..."
```

## gh CLI: CI / Runs

```bash
gh run list --repo owner/repo --limit 10
gh run view <run-id> --repo owner/repo --json status,conclusion,headSha,url
gh run view <run-id> --repo owner/repo --log-failed
gh run rerun <run-id> --repo owner/repo --failed
```

## GitHub MCP Server wrapper

```bash
# List available tools
~/.openclaw/workspace/skills/github/scripts/github-mcp.py list

# Call a tool
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_pull_requests '{"owner": "facebook", "repo": "astryx", "state": "open", "limit": 5}'

# Use additional toolsets (security, notifications, discussions, etc.)
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_security_alerts '{"owner": "facebook", "repo": "astryx"}' --toolsets=default,code_security,notifications
```

Available toolsets: `actions`, `code_quality`, `code_security`, `copilot`, `copilot_issue_intents`, `dependabot`, `discussions`, `gists`, `git`, `issues`, `labels`, `notifications`, `orgs`, `projects`, `pull_requests`, `repos`, `secret_protection`, `security_advisories`, `stargazers`, `users`.

Default: `context`, `copilot`, `issues`, `pull_requests`, `repos`, `users`.

## Security alerts workflow

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_code_scanning_alerts '{"owner": "facebook", "repo": "astryx"}' --toolsets=code_security
```

## Notifications workflow

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_notifications '{"limit": 10}' --toolsets=notifications
```

## Project boards

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_projects '{"owner": "facebook"}' --toolsets=projects
```

## gh CLI: API

```bash
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'
gh api repos/owner/repo/labels --jq '.[].name'
gh api --cache 1h repos/owner/repo --jq '{stars: .stargazers_count, forks: .forks_count}'
```

Use `--json` + `--jq` for structured output. Use `--body-file` for comments/bodies containing backticks, shell snippets, env names, or user text.

## gh CLI: Comments & Reviews

```bash
# Post a comment
gh api repos/owner/repo/issues/42/comments -f body="Your comment here"

# Get all comments on an issue/PR
gh api repos/owner/repo/issues/42/comments --paginate

# Get a specific comment by ID
gh api repos/owner/repo/issues/comments/<comment-id>

# Reply to a review
gh api repos/owner/repo/pulls/55/comments -f body="Thanks, fixed!" -f in_reply_to=<review-comment-id>
```

## When to use gh vs MCP

| Task | Use |
|---|---|
| Common PR/issue ops | `gh` |
| CI runs | `gh` |
| Comments/reviews | `gh` |
| Security alerts | MCP |
| Notifications | MCP |
| Discussions | MCP |
| Project boards | MCP |
| Code scanning | MCP |
| Dependabot | MCP |
| Complex API queries | MCP or `gh api` |

## Security

- Keep `~/.openclaw/secrets/github-token` with `chmod 600`.
- Never commit the token.
- The MCP server can perform write operations (create/update/delete). For read-only safety, run with `--toolsets=default` or use `--read-only` flag on the binary if needed.
- Prefer `gh` for destructive operations where you want explicit confirmation.

## Helper Scripts

Scripts en `skills/github/scripts/`:

| Script | Uso |
|---|---|
| `pr-batch-check.sh [--json] [--mine-only]` | Lista PRs abiertos en repos trackeados. Con `--mine-only` filtra por `gonzoblasco`. Usar para monitorear estado de contribuciones OSS. |
| `github-mcp.py` | Wrapper del GitHub MCP server para operaciones avanzadas (security alerts, notifications, project boards). |

Para triage de issues de un repo especifico, ver [oss-contribution/scripts/triage-issues.sh](../oss-contribution/scripts/triage-issues.sh).

## Related

- `gh-issue-planner`: For planning projects into GitHub Issues (epics -> stories -> subtasks). ONLY for personal repos.
- `code-review-agent`: For detailed code review using subagents.
