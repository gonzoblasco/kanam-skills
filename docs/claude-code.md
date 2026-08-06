# Installing kanam-skills in Claude Code

## Option 1: skills.sh (recommended)

```bash
npx skills add gonzoblasco/kanam-skills
```

The CLI detects Claude Code and installs to `~/.claude/skills/`.

## Option 2: manual

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* ~/.claude/skills/
```

Install a single skill:

```bash
cp -r skills/spec-driven-development ~/.claude/skills/
```

## Verify

Start a Claude Code session and mention the skill's trigger — Claude should
recognize it. Skills auto-activate on related keywords.
