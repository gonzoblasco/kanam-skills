# Instalar kanam-skills en Claude Code

## Opción 1: skills.sh (recomendada)

```bash
npx skills add gonzoblasco/kanam-skills
```

El CLI detecta Claude Code e instala en `~/.claude/skills/`.

## Opción 2: manual

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* ~/.claude/skills/
```

Instalar una sola skill:

```bash
cp -r skills/spec-driven-development ~/.claude/skills/
```

## Verificar

Iniciá una sesión de Claude Code y mencioná el trigger de la skill - Claude
debería reconocerla. Las skills se activan automáticamente con keywords
relacionadas.
