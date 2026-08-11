---
name: "oss-contribution"
metadata:
  category: "Contribution"
  tags:
    - open-source
    - contribucion
    - pr
    - issues
    - community
description: "Workflow de contribución estratégica a repos OSS externos: triaje, seguimiento de issues y PRs, reglas de interacción, registry. Complementa github (que cubre el cómo: comandos y MCP)."
user-invocable: false
---

# Workflow: OSS Contribution

## Relación con `github`

- **`github`** = el **cómo**: comandos `gh`, MCP server, scripts de operación (pr-batch-check, github-mcp).
- **`oss-contribution`** = el **cuándo y por qué**: workflow estratégico, triaje, seguimiento de issues y PRs, reglas de interacción, registry.

No se pisan. `oss-contribution` referencia los scripts de `github` en vez de duplicarlos.

## Propósito

Contribución estratégica a repositorios open source externos: elegir dónde aportar, hacer triaje de issues, implementar, mandar PRs, y **dar seguimiento** a issues y PRs en los que ya trabajamos.

## Cuándo usarlo

- Contribuir con un fix o feature a un repo open source externo
- Hacer triaje de issues en repos objetivo para encontrar oportunidades
- **Revisar issues en los que ya comentamos y seguir sus comentarios** (la práctica de seguimiento)
- Dar seguimiento batch a PRs abiertos en repos externos
- Preparar una contribución estratégica

## Fases

1. **Pipeline** — selección de repos objetivo, tier ranking (ver `references/tier-ranking.md`)
2. **Triaje** — buscar issues sin PRs competidores, evaluar impacto. Usar `scripts/triage-issues.sh`
3. **Análisis** — entender el bug/feature, root cause analysis. Complex issue ≠ complex fix. Revisar si el reporter ya identificó la causa raíz
4. **Implementación** — fork, branch, fix, tests. Usar `scripts/setup-fork.sh`
5. **PR** — descripción clara y humana (no generada). En repos Tier 0 (shadcn/ui, TanStack, Vercel): evitar trazas de automatización en commits y descripciones
6. **Post-PR Watch** — monitorear el PR: detectar comentarios de bots, cambios solicitados, merges. Usar `pr-watch.sh` de `github`
7. **Community** — comentar en issues relacionados, cross-referencing. Hacerlo después del PR, no antes, para evitar ruido si el PR no prospera
8. **Batch** — status check de PRs abiertos. Usar `pr-batch-check.sh` de `github`
9. **Registry** — registrar la cadena completa en CONTRIBUTING.md (Issue → PR tercero → nuestro aporte → nuestro PR → contexto)

## Seguimiento de issues (práctica clave)

Además de trackear PRs, **revisar periódicamente los issues en los que ya comentamos**:

- Listar issues donde el usuario comentó (autor o commenter) y que siguen abiertos
- Leer los comentarios nuevos: ¿alguien confirmó el bug? ¿otro contributor propuso un approach? ¿un maintainer pidió algo?
- Decidir **actuar vs esperar**:
  - **Actuar** si hay una pregunta directa, un approach que podemos implementar, o una oportunidad de posicionar (mandar el PR, responder con análisis técnico)
  - **Esperar** si el issue está estancado esperando decisión de maintainers, o si ya respondimos y no hay nada nuevo accionable
- Registrar el estado en el daily note y en CONTRIBUTING.md

**Lección (robo de PR):** cuando otro contributor "quiere tomar" un issue/PR en el que ya trabajamos, la jugada ganadora no es pelear por quién manda el PR de la opción débil - es **resolver su objeción dentro de la opción fuerte**. Validar su punto técnico (le da crédito), pero mostrar que la dirección que defendemos tiene una variante que resuelve su objeción.

**Lección (análisis antes del PR):** hacer el análisis técnico en el issue **antes** de mandar el PR (validando el approach con otro contributor) hace que el PR salga limpio y con el root cause ya consensuado. El issue es el lugar para converger; el PR es la ejecución.

## Reglas de búsqueda de PRs

- Cuando el usuario pide ver un PR por número + repo, buscar directamente en ese repo con `gh pr view <n> --repo <org/repo>`
- **No filtrar por autor propio** a menos que el usuario especifique "mis PRs" o "PRs míos"
- Si el PR no se encuentra, verificar que el repo esté bien escrito (org/repo-name completo)

## Reglas de interacción en PRs/Issues de terceros

### Bots vs Humanos

- **Identificar al interlocutor:** antes de responder en un hilo, verificar si el autor del comment es un bot (github-actions, netlify, codecov, dependabot, etc.) o una persona.
- **A bots no se les responde como si fuesen personas.** No saludar por nombre, no hacer conversación social, no agradecer. Si hay que responderle a un bot (ej: un check automatizado que pide algo), ser directo y dejar claro que se está respondiendo al sistema, no a una persona.
- **A humanos se les habla como humanos.** Natural, sin vueltas, sin estructura de documento técnico.

### Hilos y menciones

- **No meterse en hilos cerrados/muertos.** Si un PR está closed y no hay una pregunta directa hacia el usuario, no comentar. El silencio no es una invitación.
- **Menciones como referencia técnica ≠ llamado a la acción.** Si alguien menciona al usuario como referencia de un bug (ej: "como @usuario observó"), no requiere respuesta a menos que haya una pregunta explícita.
- **PRs cerrados por detección de automatización:** evaluar caso por caso. Por defecto no intervenir. Si hay una razón para mostrar empatía, comentar con cuidado y consultar al usuario primero.

## Outputs

- PRs a repos externos
- Reporte de estado de PRs e issues abiertos
- Registro en CONTRIBUTING.md (cadena completa de contribución)

## Helper Scripts

Scripts en `skills/oss-contribution/scripts/`:

| Script | Uso |
|---|---|
| `triage-issues.sh --repo org/repo` | Triaje de issues abiertos para encontrar oportunidades sin competencia. Fase 2. |
| `setup-fork.sh --repo org/repo` | Prepara un fork local listo para contribuir. Fase 4. |

Scripts de `github` (referenciados, no duplicados):

| Script | Uso |
|---|---|
| `pr-batch-check.sh [--mine-only]` | Lista PRs abiertos en repos trackeados. Fase 8 (Batch). |
| `pr-watch.sh <pr-url>` | Monitorea un PR por comentarios/merges. Fase 6 (Post-PR Watch). |

## Related

- `github` — el cómo: comandos gh, MCP, scripts de operación
- `session-lifecycle` — ejecuta el batch check al guardar sesión
- `code-review-and-quality` — review de PRs propios y ajenos
