# Instalar kanam-skills en OpenClaw

**Este es el diferenciador.** Las colecciones mainstream de skills (Addy,
Google, Anthropic) no cubren OpenClaw. Estas skills fueron adaptadas para
OpenClaw y verificadas ahí - este es el único port que vas a encontrar.

## Cómo carga OpenClaw las skills

OpenClaw descubre skills desde `<workspace>/skills` (mayor precedencia) y otras
raíces. Cada skill es una carpeta que contiene un archivo `SKILL.md` con
frontmatter YAML. Ver la
[documentación de skills de OpenClaw](https://docs.openclaw.ai/tools/skills)
para detalles.

## Instalación

Desde tu workspace de OpenClaw:

```bash
# Clonar una vez (donde sea)
git clone git@github.com:gonzoblasco/kanam-skills.git /tmp/kanam-skills

# Copiar cada skill a tu workspace
cp -R /tmp/kanam-skills/skills/* skills/

# Limpiar
rm -rf /tmp/kanam-skills
```

Reiniciá tu sesión de OpenClaw (o empezá una nueva). Las skills se descubren
automáticamente.

## Instalar un subconjunto

Copiá solo las skills que quieras:

```bash
cp -R /tmp/kanam-skills/skills/spec-driven-development skills/
cp -R /tmp/kanam-skills/skills/adhd-assistant skills/
```

## Verificar

Después de reiniciar, ejecutá:

```
openclaw skills list
```

o simplemente preguntale a tu agente "¿qué skills tenés?" - las skills
instaladas deberían aparecer en el contexto `<available_skills>`.

## Mantenerlo sincronizado

Para traer actualizaciones después:

```bash
git -C /tmp/kanam-skills pull
cp -R /tmp/kanam-skills/skills/* skills/
```
