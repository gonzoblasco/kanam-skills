# Installing kanam-skills in Codex (OpenAI)

## Option 1: skills.sh (recommended)

```bash
npx skills add gonzoblasco/kanam-skills
```

The CLI detects Codex and installs to `$CODEX_HOME/skills`.

## Option 2: manual

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* $CODEX_HOME/skills/
```

## Note

If you later want to migrate Codex skills into OpenClaw, use:

```bash
openclaw migrate plan codex
openclaw migrate codex
```
