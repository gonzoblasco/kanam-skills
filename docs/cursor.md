# Installing kanam-skills in Cursor

## Option 1: skills.sh (recommended)

```bash
npx skills add gonzoblasco/kanam-skills
```

The CLI detects Cursor and installs to `.cursor/skills/`.

## Option 2: manual

From your project root (or `~/.cursor` for global):

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* .cursor/skills/
```

## Verify

Restart Cursor and ask the agent to use a skill (e.g. "apply test-driven
development"). Cursor should recognize it.
