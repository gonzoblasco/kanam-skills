# Instalar kanam-skills en Codex (OpenAI)

## Opción 1: skills.sh (recomendada)

```bash
npx skills add gonzoblasco/kanam-skills
```

El CLI detecta Codex e instala en `$CODEX_HOME/skills`.

## Opción 2: manual

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* $CODEX_HOME/skills/
```

## Nota

Si después querés migrar las skills de Codex a OpenClaw, usá:

```bash
openclaw migrate plan codex
openclaw migrate codex
```
