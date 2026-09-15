# PR Checklist - OSS Contribution Reference

Checklist for PRs to external repositories.

## Pre-PR

- [ ] Fork created from the original repo (do not clone directly)
- [ ] Branch with a descriptive name: `fix/issue-123`, `feat/add-x`
- [ ] Upstream configured: `git remote add upstream <original-url>`
- [ ] No unrelated formatting/whitespace changes
- [ ] No changes to unrelated files
- [ ] Commits signed with SSH
- [ ] No automation traces in commits (Tier 0 repos)

## PR Description

```markdown
## Description

[Clear, human description of what this PR does and why]

## Related Issue

Closes #123

## Testing

- [ ] Added tests
- [ ] Existing tests pass
- [ ] Manual testing done

## Screenshots (if applicable)

[Only if UI changes]
```

## Post-PR

- [ ] Reply to maintainer comments within 24h
- [ ] If they ask for changes, do them quickly
- [ ] Record the full chain in CONTRIBUTING.md (Issue -> third-party PR -> our contribution -> our PR -> context)
