# gh CLI Cheatsheet

## Quick Reference

### Auth
```bash
gh auth status          # Check auth state
gh auth login           # Login / re-auth
gh auth token           # Print token (for scripts)
```

### Repo Info
```bash
gh repo view owner/repo --json name,description,stargazers_count,forks_count
gh repo clone owner/repo
gh repo fork owner/repo --clone
```

### PRs
```bash
gh pr list --repo owner/repo --state open --json number,title,author,updatedAt
gh pr list --repo owner/repo --author gonzoblasco --state open
gh pr view 55 --repo owner/repo --json title,body,reviews,reviewDecision
gh pr checks 55 --repo owner/repo
gh pr diff 55 --repo owner/repo
gh pr create --repo owner/repo --title "feat: title" --body-file /tmp/pr.md
gh pr merge 55 --repo owner/repo --squash
gh pr close 55 --repo owner/repo
```

### Issues
```bash
gh issue list --repo owner/repo --state open --limit 50
gh issue view 42 --repo owner/repo --json title,body,comments,labels
gh issue create --repo owner/repo --title "Bug: ..." --body-file /tmp/issue.md
gh issue comment 42 --repo owner/repo --body-file /tmp/comment.md
gh issue close 42 --repo owner/repo --comment "Fixed in #55"
```

### CI / Actions
```bash
gh run list --repo owner/repo --limit 10
gh run view <run-id> --repo owner/repo --log-failed
gh run rerun <run-id> --repo owner/repo --failed
gh workflow list --repo owner/repo
gh workflow run <workflow> --repo owner/repo
```

### API (for anything gh doesn't cover)
```bash
gh api repos/owner/repo --jq '.stargazers_count'
gh api repos/owner/repo/pulls/55/comments --paginate
gh api repos/owner/repo/issues/42/comments -f body="text"
gh api repos/owner/repo/labels --jq '.[].name'
```

### Tips
- Use `--json` + `--jq` for structured output
- Use `--body-file` for bodies with backticks, shell snippets, or special chars
- Use `--paginate` for results beyond default limit
- Use `--cache 1h` for read-only API calls to avoid rate limits
