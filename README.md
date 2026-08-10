# kanam-skills

**Skills de agente para todo el trabajo - y el resto de tu vida.**

Skills de producción para agentes de IA, empaquetadas igual que
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) y
[google/skills](https://github.com/google/skills) - pero cubriendo más que el
ciclo de desarrollo. Workflows de ingeniería, productividad personal,
escritura creativa y gestión de vida, todo en el formato abierto
[Agent Skills](https://agentskills.io/specification.md).

```bash
npx skills add gonzoblasco/kanam-skills
```

Funciona con más de 70 agentes: Claude Code, Codex, Cursor, Copilot, Windsurf,
Cline, OpenCode, Kiro y más - además de un **port probado en OpenClaw**.

---

## Por qué otro repo de skills

Las colecciones grandes cubren el ciclo de software: Define → Plan → Build →
Verify → Review → Ship. Esa es la mitad de ingeniería del trabajo de un agente.

Este repo cubre **la otra mitad también** - las skills que tu agente necesita
para gestionar *tu* vida, no solo tu código: planificación adaptada a ADHD,
bibliotecas de fotos, seguimiento de calorías, optimización de CV, escritura
de ficción, speech-to-text local, y más. Ninguna otra colección pública ofrece
estas como skills de agente de primera clase.

**El único set de skills con un port probado en OpenClaw.** El ecosistema de
OpenClaw no estaba cubierto por las colecciones mainstream, así que lo
adaptamos - y verificamos que funciona.

## Instalación

### Cualquier agente (skills.sh)

```bash
# Todo
npx skills add gonzoblasco/kanam-skills

# Una skill específica
npx skills add gonzoblasco/kanam-skills@narrative-content

# Desde un subdirectorio
npx skills add gonzoblasco/kanam-skills/skills/spec-driven-development
```

El CLI detecta tu agente (Claude Code, Cursor, Codex, Copilot, Windsurf, Kiro,
...) y copia las skills al directorio correcto automáticamente.

### OpenClaw

OpenClaw carga las skills desde `<workspace>/skills`. Cloná este repo (o la
carpeta skills) en tu workspace:

```bash
# Desde tu workspace de OpenClaw
git clone git@github.com:gonzoblasco/kanam-skills.git .kanam-skills
cp -R .kanam-skills/skills/* skills/
rm -rf .kanam-skills
```

Después reiniciá tu sesión de OpenClaw. Las skills se descubren
automáticamente.

### Manual (cualquier agente)

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
# Claude Code
cp -r skills/* ~/.claude/skills/
# Cursor
cp -r skills/* .cursor/skills/
# Codex
cp -r skills/* $CODEX_HOME/skills/
```

Mirá [docs/](docs/) para las guías por agente.

---

## El catálogo

### Ingeniería - el ciclo SDLC (25 skills)

| Fase | Skills |
|---|---|
| **Define** | interview-me, idea-refine, spec-driven-development |
| **Plan** | planning-and-task-breakdown |
| **Build** | incremental-implementation, test-driven-development, context-engineering, source-driven-development, doubt-driven-development, frontend-ui-engineering, api-and-interface-design |
| **Verify** | browser-testing-with-devtools, debugging-and-error-recovery |
| **Review** | code-review-and-quality, code-simplification, security-and-hardening, performance-optimization |
| **Ship** | git-workflow-and-versioning, ci-cd-and-automation, deprecation-and-migration, documentation-and-adrs, observability-and-instrumentation, shipping-and-launch |
| **Meta** | using-agent-skills, openspec |

### Infraestructura OpenClaw (7 skills)

session-lifecycle, knowledge-management, memory-agent, background-execution,
engineering-governance, git-changelog, mcp-orchestrator

### Stack y herramientas (4 skills)

supabase-assistant, sql-insight, db-readonly, deepwiki

### Desarrollo especializado (6 skills)

i18n-expert, shortcuts-generator, support-response-writer, tech-docs, github,
oss-contribution

### Seguridad y red (2 skills)

clawdstrike, network-scanner

### Carrera y crecimiento (2 skills)

mock-interview-drill, cv-tailor

### Contenido y creatividad (7 skills)

copy-editing, narrative-content, brand-name-forge, content-serializer,
deslop, image-generation, curriculum-builder

### Vida diaria y herramientas (6 skills)

adhd-assistant, apple-photos, calorie-counter, mlx-stt,
checkmate, godot-mcp

**Total: 59 skills.**

Explorá el catálogo completo en el [sitio de kanam-skills](#) (GitHub Pages).

---

## Calidad

Cada script bash viene con un suite de tests
[bats](https://github.com/bats-core/bats-core), que corre en CI en cada push.
Pocos repos de skills hacen esto.

```bash
npm ci
npx bats tests/bash/
```

## Licencia

MIT - usalas, forkearlas, publicarlas. Mirá [LICENSE](LICENSE).
