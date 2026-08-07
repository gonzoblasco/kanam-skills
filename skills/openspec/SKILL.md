---
name: openspec
description: "Usar el CLI de OpenSpec para desarrollo guiado por specs: crear propuestas de cambio, escribir deltas de specs, documentos de diseño, tareas y archivar cambios aprobados."
metadata:
  version: 1.0.0
  author: Kanam
  tags: ["openspec", "spec-driven-development", "planning", "documentation", "workflow"]
allowed-tools:
  - exec
  - read
  - write
  - edit
  - skill_workshop
---

# OpenSpec

Usar el CLI de OpenSpec (`@fission-ai/openspec`) para practicar desarrollo guiado por specs dentro de los proyectos. Esta skill complementa a `agent-workflow`: `agent-workflow` define *cómo* trabajar, `openspec` define *dónde* escribir los specs y los cambios.

## Cuándo usar

Usar esta skill para cualquier cambio no trivial en un proyecto que tenga OpenSpec inicializado:

- Nueva feature
- Cambio de comportamiento
- Refactor que cambia el comportamiento
- Cambio de API
- Cambio de UI/UX con impacto a nivel de spec
- Cualquier cambio que se beneficie de un spec acordado antes del código

Omitir para:
- Cambios puramente de config/tooling/docs (poner `skip_specs: true` si se usa OpenSpec)
- Arreglos de una línea sin cambio de comportamiento
- Experimentos descartables

## Requisitos

- Node.js >= 20.19.0
- `@fission-ai/openspec` instalado globalmente:
  ```bash
  npm install -g @fission-ai/openspec@latest
  ```
- OpenSpec inicializado en el proyecto:
  ```bash
  openspec init --tools none
  ```

## Estructura del proyecto

Después de `openspec init`, el proyecto tiene:

```
openspec/
├── config.yaml              # Configuración de OpenSpec
├── specs/                   # Specs fuente de verdad
│   └── auth/spec.md
│   └── user/spec.md
├── changes/                 # Propuestas de cambio activas
│   └── add-2fa/
│       ├── .openspec.yaml
│       ├── proposal.md
│       ├── specs/
│       │   └── auth/spec.md      # Spec delta
│       ├── design.md
│       └── tasks.md
└── changes/archive/         # Cambios archivados
```

## Workflow

### Fase 1: Inicializar (una vez por proyecto)

```bash
cd projects/my-app
openspec init --tools none
```

Esto crea la estructura `openspec/`. No configura comandos slash específicos del IDE porque OpenClaw usa el CLI directamente.

### Fase 2: Crear una propuesta de cambio

```bash
openspec new change add-login-button
```

Luego generar:

- `openspec/changes/add-login-button/proposal.md` - Por qué, Qué Cambia, Capacidades, Impacto

Usar `openspec instructions proposal --change add-login-button` para obtener la plantilla exacta y las guías.

### Fase 3: Escribir los deltas de specs

Para cada capacidad declarada en la propuesta:

- Crear `openspec/changes/add-login-button/specs/<capability>/spec.md`
- Usar el formato de delta:
  - `## ADDED Requirements`
  - `## MODIFIED Requirements`
  - `## REMOVED Requirements`

Usar `openspec instructions proposal --change add-login-button` para la plantilla.

### Fase 4: Diseño técnico (opcional)

Escribir `openspec/changes/add-login-button/design.md` cuando el enfoque de implementación no sea obvio.

### Fase 5: Tareas

Escribir `openspec/changes/add-login-button/tasks.md` como checklist:

```markdown
## 1. Base de datos
- [ ] 1.1 Agregar columna
- [ ] 1.2 Crear migración

## 2. Backend
- [ ] 2.1 Actualizar endpoint

## 3. Frontend
- [ ] 3.1 Actualizar componente
```

### Fase 6: Validar

```bash
openspec validate add-login-button
openspec status --change add-login-button
openspec show add-login-button
```

## Scripts auxiliares relacionados

| Skill / Script | Uso |
|---|---|
| `product-discovery/scripts/generate-openspec.sh` | Genera un OpenSpec a partir de la definición del producto cuando no hay CLI instalado. |
| `architecture-designer` | Diseña la arquitectura que luego se documenta con OpenSpec. |
| `tech-docs/scripts/generate-adr.sh` | Genera ADRs para decisiones arquitectónicas que afectan el spec. |

### Fase 7: Implementar

Ejecutar las tareas una por una. Marcar las tareas como completadas a medida que se avanza. Correr tests/lint/build después de cada tarea.

### Fase 8: Archivar

```bash
openspec archive add-login-button --yes
```

Esto fusiona los specs delta en `openspec/specs/` y mueve el cambio a `openspec/changes/archive/`.

## Integración con agent-workflow

Combinar con `agent-workflow`:

1. La Fase 1 de `agent-workflow` (Design Gate) se convierte en escribir la propuesta y los deltas de OpenSpec.
2. La Fase 2 de `agent-workflow` (Implementation Plan) se convierte en el `tasks.md` de OpenSpec.
3. La Fase 3 de `agent-workflow` (TDD) ejecuta las tareas.
4. La Fase 4 de `agent-workflow` (Code Review) revisa la implementación.
5. `openspec archive` finaliza el cambio.

## Comandos auxiliares

```bash
# Ver el estado actual
openspec list
openspec list --specs
openspec status --change <change-name>

# Obtener instrucciones para el próximo artefacto
openspec instructions proposal --change <change-name>
openspec instructions apply --change <change-name>
openspec instructions archive --change <change-name>

# Validar y ver
openspec validate <change-name>
openspec show <change-name>

# Crear y archivar cambios
openspec new change <change-name>
openspec archive <change-name> --yes
```

## Anti-patrones

- Crear `tasks.md` antes que `proposal.md` y los deltas de specs
- Listar capacidades en la propuesta pero no escribir los specs delta correspondientes
- Escribir detalles de implementación en `proposal.md` en vez de `design.md`
- Omitir `openspec validate`
- Archivar sin tener todas las tareas completas
- Usar OpenSpec como lista de tareas para cambios triviales

## Buenas prácticas

- Mantener las propuestas concisas (1-2 páginas).
- Cada capacidad debe mapear a un archivo de spec real.
- Usar el formato `### Requirement: <name>` y `#### Scenario: <name>` en los specs.
- Usar SHALL/MUST en el texto de los requirements.
- Correr `openspec validate` antes de aplicar o archivar.
- Actualizar `CHANGELOG.md` después de archivar.

## Notas

- OpenSpec no reemplaza a `AGENTS.md`. Agrega una capa de specs estructurados.
- El CLI emite telemetría anónima por defecto. Poner `OPENSPEC_TELEMETRY=0` para desactivarla.
- OpenSpec no es un servidor MCP; esta skill usa el CLI directamente.
- Para proyectos que no usan OpenSpec, recurrir a `.knowledge/specs/`, `.knowledge/plans/` y `agent-workflow`.
