# Guías de instalación

Instrucciones de instalación por agente para kanam-skills.

## Referencia rápida

| Agente | Comando |
|---|---|
| Cualquiera (skills.sh) | `npx skills add gonzoblasco/kanam-skills` |
| OpenClaw | copiar `skills/` en `<workspace>/skills` (ver [openclaw.md](openclaw.md)) |
| Claude Code | `cp -r skills/* ~/.claude/skills/` |
| Cursor | `cp -r skills/* .cursor/skills/` |
| Codex | `cp -r skills/* $CODEX_HOME/skills/` |
| Windsurf | `cp -r skills/* ~/.codeium/windsurf/skills/` |
| Kiro | `cp -r skills/* ~/.kiro/skills/` |

## La forma recomendada: skills.sh

El CLI de [skills.sh](https://skills.sh) (de [vercel-labs/skills](https://github.com/vercel-labs/skills))
detecta tu agente automáticamente e instala en el directorio correcto:

```bash
npx skills add gonzoblasco/kanam-skills
```

Instalar una sola skill:

```bash
npx skills add gonzoblasco/kanam-skills@narrative-content
```

## Instalación manual

Cloná y copiá las skills que quieras:

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cd kanam-skills
```

Después copiá `skills/*` al directorio de skills de tu agente (ver la tabla de arriba).

## Guías detalladas

- [OpenClaw](openclaw.md) - el port probado (no cubierto por skills.sh)
- [Claude Code](claude-code.md)
- [Cursor](cursor.md)
- [Codex](codex.md)
