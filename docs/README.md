# Install guides

Per-agent installation instructions for kanam-skills.

## Quick reference

| Agent | Command |
|---|---|
| Any (skills.sh) | `npx skills add gonzoblasco/kanam-skills` |
| OpenClaw | copy `skills/` into `<workspace>/skills` (see [openclaw.md](openclaw.md)) |
| Claude Code | `cp -r skills/* ~/.claude/skills/` |
| Cursor | `cp -r skills/* .cursor/skills/` |
| Codex | `cp -r skills/* $CODEX_HOME/skills/` |
| Windsurf | `cp -r skills/* ~/.codeium/windsurf/skills/` |
| Kiro | `cp -r skills/* ~/.kiro/skills/` |

## The recommended way: skills.sh

The [skills.sh](https://skills.sh) CLI (from [vercel-labs/skills](https://github.com/vercel-labs/skills))
detects your agent automatically and installs to the right directory:

```bash
npx skills add gonzoblasco/kanam-skills
```

Install a single skill:

```bash
npx skills add gonzoblasco/kanam-skills@narrative-content
```

## Manual install

Clone and copy the skills you want:

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cd kanam-skills
```

Then copy `skills/*` into your agent's skills directory (see the table above).

## Detailed guides

- [OpenClaw](openclaw.md) — the proven port (not covered by skills.sh)
- [Claude Code](claude-code.md)
- [Cursor](cursor.md)
- [Codex](codex.md)
