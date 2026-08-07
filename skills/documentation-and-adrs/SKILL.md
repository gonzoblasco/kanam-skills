---
name: documentation-and-adrs
description: Registra decisiones y documentación. Úsala al tomar decisiones arquitectónicas, cambiar APIs públicas, entregar features, o cuando necesites registrar contexto que futuros ingenieros y agentes necesitarán para entender la base de código.
---

# Documentación y ADRs

## Resumen

Documenta decisiones, no solo código. La documentación más valiosa captura el *porqué*: el contexto, las restricciones y los tradeoffs que llevaron a una decisión. El código muestra *qué* se construyó; la documentación explica *por qué se construyó de esta forma* y *qué alternativas se consideraron*. Este contexto es esencial para futuros humanos y agentes que trabajen en la base de código.

## Cuándo Usarla

- Tomar una decisión arquitectónica significativa
- Elegir entre enfoques en competencia
- Agregar o cambiar una API pública
- Entregar una feature que cambia el comportamiento visible para el usuario
- Incorporar nuevos miembros de equipo (o agentes) al proyecto
- Cuando te encuentres explicando lo mismo repetidamente

**Cuándo NO usarla:** No documentes código obvio. No agregues comentarios que repiten lo que el código ya dice. No escribas doc para prototipos descartables.

## Architecture Decision Records (ADRs)

Los ADRs capturan el razonamiento detrás de decisiones técnicas significativas. Son la documentación de mayor valor que puedes escribir.

### Cuándo Escribir un ADR

- Elegir un framework, librería o dependencia mayor
- Diseñar un modelo de datos o esquema de base de datos
- Seleccionar una estrategia de autenticación
- Decidir sobre una arquitectura de API (REST vs. GraphQL vs. tRPC)
- Elegir entre herramientas de build, plataformas de hosting o infraestructura
- Cualquier decisión que sería cara de revertir

### Respeta la convención existente primero

Antes de crear un ADR, inspecciona el contexto disponible del repo en busca de una convención establecida: ADRs existentes, instrucciones del proyecto y configuración o tooling relacionado con ADRs (ej: un archivo `.adr-dir`). Una convención establecida anula los defaults de abajo. Respeta:

- **Ubicación y formato**: ej: `docs/adr/*.md`, `Documentation/Decisions/*.rst`, un layout MADR o una configuración de `adr-tools`. Respeta el directorio existente, la extensión de archivo y el markup (Markdown vs reStructuredText).
- **Numeración y nombres**: continúa la secuencia existente y el patrón de nombres de archivo (`ADR-004-Title.rst`, `0004-title.md`, ...); no reinicies en 001 ni introduzcas un segundo esquema.
- **Encabezados de sección**: reutiliza el conjunto de encabezados del proyecto en lugar de imponer el de esta plantilla.

Si la evidencia disponible entra en conflicto, superficial el conflicto en lugar de introducir silenciosamente otro esquema. Solo cuando no se puede establecer ninguna convención aplicas el default de abajo.

### Plantilla de ADR

Guarda los ADRs en `docs/decisions/` con numeración secuencial (salvo que el proyecto ya use otra ubicación: ver arriba):

```markdown
# ADR-001: Usar PostgreSQL como base de datos principal

## Status
Accepted | Superseded by ADR-XXX | Deprecated

## Date
2025-01-15

## Context
Necesitamos una base de datos principal para la aplicación de gestión de tareas. Requisitos clave:
- Modelo de datos relacional (usuarios, tareas, equipos con relaciones)
- Transacciones ACID para los cambios de estado de las tareas
- Soporte de búsqueda de texto completo en el contenido de las tareas
- Hosting gestionado disponible (para equipo pequeño, capacidad operativa limitada)

## Decision
Usar PostgreSQL con Prisma ORM.

## Alternatives Considered

### MongoDB
- Pros: Esquema flexible, fácil de empezar
- Cons: Nuestros datos son inherentemente relacionales; habría que gestionar las relaciones manualmente
- Rejected: Datos relacionales en un document store lleva a joins complejos o duplicación de datos

### SQLite
- Pros: Cero configuración, embebido, rápido para lecturas
- Cons: Soporte limitado de escritura concurrente, sin hosting gestionado para producción
- Rejected: No es adecuado para una aplicación web multiusuario en producción

### MySQL
- Pros: Maduro, ampliamente soportado
- Cons: PostgreSQL tiene mejor soporte de JSON, búsqueda de texto completo y tooling de ecosistema
- Rejected: PostgreSQL encaja mejor con nuestros requisitos de features

## Consequences
- Prisma proporciona acceso a la base de datos type-safe y gestión de migraciones
- Podemos usar la búsqueda de texto completo de PostgreSQL en lugar de agregar Elasticsearch
- El equipo necesita conocimiento de PostgreSQL (habilidad estándar, bajo riesgo)
- Hosting en un servicio gestionado (Supabase, Neon o RDS)
```

### Ciclo de Vida de los ADR

```
PROPOSED → ACCEPTED → (SUPERSEDED o DEPRECATED)
```

- **No borres los ADRs viejos.** Capturan contexto histórico.
- Cuando una decisión cambia, escribe un nuevo ADR que haga referencia al viejo y lo supere.

## Documentación Inline

### Cuándo Comentar

Comenta el *porqué*, no el *qué*:

```typescript
// MAL: Repite el código
// Increment counter by 1
counter += 1;

// BIEN: Explica la intención no obvia
// Rate limit usa una ventana deslizante: resetea el contador en el límite de la ventana,
// no en un horario fijo, para prevenir ataques de ráfaga en los bordes de la ventana
if (now - windowStart > WINDOW_SIZE_MS) {
  counter = 0;
  windowStart = now;
}
```

### Cuándo NO Comentar

```typescript
// No comentes código autoexplicativo
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// No dejes comentarios TODO para cosas que deberías hacer ahora
// TODO: add error handling  ← Solo agrégalo

// No dejes código comentado
// const oldImplementation = () => { ... }  ← Bórralo, git tiene el historial
```

### Documenta los Gotchas Conocidos

```typescript
/**
 * IMPORTANTE: Esta función debe llamarse antes del primer render.
 * Si se llama después de la hidratación, causa un flash de contenido sin estilo
 * porque el context del tema no está disponible durante el SSR.
 *
 * Ver ADR-003 para el fundamento de diseño completo.
 */
export function initializeTheme(theme: Theme): void {
  // ...
}
```

## Documentación de APIs

Para APIs públicas (REST, GraphQL, interfaces de librería):

### Inline con Tipos (Preferido para TypeScript)

```typescript
/**
 * Crea una nueva tarea.
 *
 * @param input - Datos de creación de la tarea (title requerido, description opcional)
 * @returns La tarea creada con ID y timestamps generados por el servidor
 * @throws {ValidationError} Si title está vacío o supera los 200 caracteres
 * @throws {AuthenticationError} Si el usuario no está autenticado
 *
 * @example
 * const task = await createTask({ title: 'Buy groceries' });
 * console.log(task.id); // "task_abc123"
 */
export async function createTask(input: CreateTaskInput): Promise<Task> {
  // ...
}
```

### OpenAPI / Swagger para APIs REST

```yaml
paths:
  /api/tasks:
    post:
      summary: Create a task
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateTaskInput'
      responses:
        '201':
          description: Task created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Task'
        '422':
          description: Validation error
```

## Estructura del README

Todo proyecto debería tener un README que cubra:

```markdown
# Project Name

Párrafo de una línea que describe qué hace este proyecto.

## Quick Start
1. Clonar el repo
2. Instalar dependencias: `npm install`
3. Configurar el entorno: `cp .env.example .env`
4. Correr el dev server: `npm run dev`

## Commands
| Command | Description |
|---------|-------------|
| `npm run dev` | Inicia el servidor de desarrollo |
| `npm test` | Ejecuta los tests |
| `npm run build` | Build de producción |
| `npm run lint` | Ejecuta el linter |

## Architecture
Resumen breve de la estructura del proyecto y las decisiones clave de diseño.
Enlaza a los ADRs para más detalles.

## Contributing
Cómo contribuir, estándares de código, proceso de PR.
```

## Mantenimiento del Changelog

Para features entregadas:

```markdown
# Changelog

## [1.2.0] - 2025-01-20
### Added
- Compartir tareas: los usuarios pueden compartir tareas con miembros del equipo (#123)
- Notificaciones por email para asignaciones de tareas (#124)

### Fixed
- Tareas duplicadas que aparecían al hacer clic rápidamente en el botón de crear (#125)

### Changed
- La lista de tareas ahora carga 50 ítems por página (antes 20) para mejor UX (#126)
```

## Documentación para Agentes

Consideración especial para el contexto de los agentes de IA:

- **Archivos CLAUDE.md / de reglas**: documenta las convenciones del proyecto para que los agentes las sigan
- **Archivos de spec**: mantén las specs actualizadas para que los agentes construyan lo correcto
- **ADRs**: ayudan a los agentes a entender por qué se tomaron decisiones pasadas (previene re-decidir)
- **Gotchas inline**: previenen que los agentes caigan en trampas conocidas

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "El código se auto-documenta" | El código muestra qué. No muestra por qué, qué alternativas se rechazaron ni qué restricciones aplican. |
| "Escribiremos la doc cuando la API se estabilice" | Las APIs se estabilizan más rápido cuando las documentas. La doc es la primera prueba del diseño. |
| "Nadie lee la doc" | Los agentes sí. Los futuros ingenieros sí. Tu yo de dentro de 3 meses sí. |
| "Los ADRs son overhead" | Un ADR de 10 minutos previene un debate de 2 horas sobre la misma decisión seis meses después. |
| "Los comentarios se desactualizan" | Los comentarios sobre *por qué* son estables. Los comentarios sobre *qué* se desactualizan, por eso solo escribes los primeros. |

## Red Flags

- Decisiones arquitectónicas sin fundamento escrito
- APIs públicas sin documentación ni tipos
- README que no explica cómo ejecutar el proyecto
- Código comentado en lugar de eliminado
- Comentarios TODO que llevan semanas ahí
- Sin ADRs en un proyecto con decisiones arquitectónicas significativas
- Documentación que repite el código en lugar de explicar la intención

## Verificación

Después de documentar:

- [ ] Existen ADRs para todas las decisiones arquitectónicas significativas
- [ ] El README cubre quick start, comandos y resumen de arquitectura
- [ ] Las funciones de la API tienen documentación de parámetros y tipo de retorno
- [ ] Los gotchas conocidos están documentados inline donde importan
- [ ] No queda código comentado
- [ ] Los archivos de reglas (CLAUDE.md, etc.) están actualizados y son precisos
