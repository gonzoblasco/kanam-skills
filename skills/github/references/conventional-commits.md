# Conventional Commits

## Format

```
<type>(#<issue>): <description>
```

## Types

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Maintenance, CI, deps |
| `docs` | Documentation only |
| `refactor` | Code change, no feature/fix |
| `test` | Adding or fixing tests |
| `style` | Formatting, semicolons, etc. |
| `perf` | Performance improvement |
| `ci` | CI/CD changes |

## Examples

```
feat(#3): timeline page with reverse-chronological entry list
fix(#12): prevent double submit on login form
chore(#11): add GitHub Actions CI workflow
docs(#7): update README with setup instructions
refactor(#15): extract auth logic to useAuth hook
```

## Rules

- **Always in English** for repos that use English
- **One commit per issue/task** - atomic commits
- **Regular hyphen (-), never em dash (—)**
- Issue number references the GitHub issue
- Description in imperative mood ("add" not "added" or "adds")
