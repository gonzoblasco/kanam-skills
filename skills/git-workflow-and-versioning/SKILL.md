---
name: git-workflow-and-versioning
description: "Estructura las prácticas de workflow de git. Usar al hacer cualquier cambio de código. Usar al commitear, crear ramas, resolver conflictos, o cuando necesites organizar el trabajo en múltiples streams paralelos. Usar al cortar un release, elegir un bump de versionado semántico, taguear, o escribir un changelog."
---

# Workflow de Git y Versionado

## Resumen

Git es tu red de seguridad. Tratá los commits como puntos de guardado, las ramas como sandboxes y el historial como documentación. Con agentes de IA generando código a alta velocidad, el control de versiones disciplinado es el mecanismo que mantiene los cambios manejables, revisables y reversibles.

## Cuándo usar

Siempre. Todo cambio de código fluye por git.

## Principios centrales

### Trunk-Based Development (Recomendado)

Mantener `main` siempre desplegable. Trabajar en feature branches de vida corta que se mergean dentro de 1-3 días. Las ramas de desarrollo de larga vida son costos ocultos: divergen, crean conflictos de merge y retrasan la integración. La investigación DORA muestra consistentemente que el trunk-based development se correlaciona con equipos de ingeniería de alto rendimiento.

```
main ──●──●──●──●──●──●──●──●──●──  (siempre desplegable)
        ╲      ╱  ╲    ╱
         ●──●─╱    ●──╱    ← feature branches de vida corta (1-3 días)
```

Este es el default recomendado. Los equipos que usan gitflow o ramas de larga vida pueden adaptar los principios (commits atómicos, cambios pequeños, mensajes descriptivos) a su modelo de ramas: la disciplina de commit importa más que la estrategia específica de ramas.

- **Las dev branches son costos.** Cada día que vive una rama, acumula riesgo de merge.
- **Las release branches son aceptables.** Cuando necesitás estabilizar un release mientras main avanza.
- **Feature flags > ramas largas.** Preferir desplegar trabajo incompleto detrás de flags antes que mantenerlo en una rama por semanas.

### 1. Commitear temprano, commitear seguido

Cada incremento exitoso tiene su propio commit. No acumular cambios grandes sin commitear.

```
Patrón de trabajo:
  Implementar slice → Test → Verificar → Commit → Siguiente slice

No así:
  Implementar todo → Esperar que funcione → Commit gigante
```

Los commits son puntos de guardado. Si el siguiente cambio rompe algo, podés revertir al último estado conocido-bueno al instante.

### 2. Commits atómicos

Cada commit hace una sola cosa lógica:

```
# Bueno: Cada commit es autocontenido
git log --oneline
a1b2c3d Add task creation endpoint with validation
d4e5f6g Add task creation form component
h7i8j9k Connect form to API and add loading state
m1n2o3p Add task creation tests (unit + integration)

# Malo: Todo mezclado
git log --oneline
x1y2z3a Add task feature, fix sidebar, update deps, refactor utils
```

### 3. Mensajes descriptivos

Los mensajes de commit explican el *por qué*, no solo el *qué*:

```
# Bueno: Explica la intención
feat: add email validation to registration endpoint

Prevents invalid email formats from reaching the database.
Uses Zod schema validation at the route handler level,
consistent with existing validation patterns in auth.ts.

# Malo: Describe lo obvio del diff
update auth.ts
```

**Formato:**
```
<type>: <descripción corta>

<cuerpo opcional explicando el por qué, no el qué>
```

**Tipos:**
- `feat` - Nueva feature
- `fix` - Arreglo de bug
- `refactor` - Cambio de código que ni arregla un bug ni agrega una feature
- `test` - Agregar o actualizar tests
- `docs` - Solo documentación
- `chore` - Tooling, dependencias, config

### 4. Mantener las preocupaciones separadas

No combinar cambios de formato con cambios de comportamiento. No combinar refactors con features. Cada tipo de cambio debería ser un commit separado, e idealmente un PR separado:

```
# Bueno: Preocupaciones separadas
git commit -m "refactor: extract validation logic to shared utility"
git commit -m "feat: add phone number validation to registration"

# Malo: Preocupaciones mezcladas
git commit -m "refactor validation and add phone number field"
```

**Separar el refactoring del trabajo de feature.** Un cambio de refactoring y un cambio de feature son dos cambios diferentes: enviarlos por separado. Esto hace que cada cambio sea más fácil de revisar, revertir y entender en el historial. Los cleanups pequeños (renombrar una variable) se pueden incluir en un commit de feature a criterio del reviewer.

### 5. Dimensionar tus cambios

Apuntar a ~100 líneas por commit/PR. Los cambios de más de ~1000 líneas deberían dividirse. Ver las estrategias de división en `code-review-and-quality` para cómo descomponer cambios grandes.

```
~100 líneas  → Fácil de revisar, fácil de revertir
~300 líneas  → Aceptable para un único cambio lógico
~1000 líneas → Dividir en cambios más chicos
```

## Estrategia de ramas

### Feature branches

```
main (siempre desplegable)
  │
  ├── feature/task-creation    ← Una feature por rama
  ├── feature/user-settings    ← Trabajo en paralelo
  └── fix/duplicate-tasks      ← Arreglos de bugs
```

- Crear la rama desde `main` (o la rama default del equipo)
- Mantener las ramas de vida corta (mergear dentro de 1-3 días) - las ramas de larga vida son costos ocultos
- Borrar las ramas después del merge
- Preferir feature flags sobre ramas de larga vida para features incompletas

### Nombres de ramas

```
feature/<descripción-corta>   → feature/task-creation
fix/<descripción-corta>       → fix/duplicate-tasks
chore/<descripción-corta>     → chore/update-deps
refactor/<descripción-corta>  → refactor/auth-module
```

## Trabajar con worktrees

Para trabajo de agentes de IA en paralelo, usar git worktrees para correr múltiples ramas simultáneamente:

```bash
# Crear un worktree para una feature branch
git worktree add ../project-feature-a feature/task-creation
git worktree add ../project-feature-b feature/user-settings

# Cada worktree es un directorio separado con su propia rama
# Los agentes pueden trabajar en paralelo sin interferirse
ls ../
  project/              ← rama main
  project-feature-a/    ← rama task-creation
  project-feature-b/    ← rama user-settings

# Cuando terminás, mergear y limpiar
git worktree remove ../project-feature-a
```

Beneficios:
- Múltiples agentes pueden trabajar en diferentes features simultáneamente
- No hace falta cambiar de rama (cada directorio tiene su propia rama)
- Si un experimento falla, borrar el worktree - nada se pierde
- Los cambios quedan aislados hasta que se mergean explícitamente

## El patrón de punto de guardado

```
El agente empieza el trabajo
    │
    ├── Hace un cambio
    │   ├── ¿Test pasa? → Commit → Continuar
    │   └── ¿Test falla? → Revertir al último commit → Investigar
    │
    ├── Hace otro cambio
    │   ├── ¿Test pasa? → Commit → Continuar
    │   └── ¿Test falla? → Revertir al último commit → Investigar
    │
    └── Feature completa → Todos los commits forman un historial limpio
```

Este patrón significa que nunca perdés más de un incremento de trabajo. Si un agente se va de las manos, `git reset --hard HEAD` te devuelve al último estado exitoso.

## Resúmenes de cambio

Después de cualquier modificación, proveer un resumen estructurado. Esto facilita la revisión, documenta la disciplina de alcance y expone cambios no intencionados:

```
CHANGES MADE:
- src/routes/tasks.ts: Added validation middleware to POST endpoint
- src/lib/validation.ts: Added TaskCreateSchema using Zod

THINGS I DIDN'T TOUCH (intentionally):
- src/routes/auth.ts: Has similar validation gap but out of scope
- src/middleware/error.ts: Error format could be improved (separate task)

POTENTIAL CONCERNS:
- The Zod schema is strict - rejects extra fields. Confirm this is desired.
- Added zod as a dependency (72KB gzipped) - already in package.json
```

Este patrón detecta supuestos incorrectos temprano y les da a los reviewers un mapa claro del cambio. La sección "DIDN'T TOUCH" es especialmente importante: muestra que ejercitaste disciplina de alcance y no fuiste en una renovación no solicitada.

## Higiene previa al commit

Antes de cada commit:

```bash
# 1. Revisar qué estás por commitear
git diff --staged

# 2. Asegurar que no haya secrets
git diff --staged | grep -i "password\|secret\|api_key\|token"

# 3. Correr tests
npm test

# 4. Correr linting
npm run lint

# 5. Correr type checking
npx tsc --noEmit
```

Automatizar esto con git hooks:

```json
// package.json (usando lint-staged + husky)
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

## Manejo de archivos generados

- **Commitear archivos generados** solo si el proyecto los espera (ej.: `package-lock.json`, migraciones de Prisma)
- **No commitear** salida de build (`dist/`, `.next/`), archivos de entorno (`.env`) o config de IDE (`.vscode/settings.json` salvo que sea compartida)
- **Tener un `.gitignore`** que cubra: `node_modules/`, `dist/`, `.env`, `.env.local`, `*.pem`

## Usar git para debugging

```bash
# Encontrar qué commit introdujo un bug
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
# Git checkout puntos medios; correr tu test en cada uno para acotar

# Ver qué cambió recientemente
git log --oneline -20
git diff HEAD~5..HEAD -- src/

# Encontrar quién cambió por última vez una línea específica
git blame src/services/task.ts

# Buscar mensajes de commit por keyword
git log --grep="validation" --oneline
```

## Release & versionado

Los commits son cómo *vos* trackeás el cambio; una **versión** es cómo *tus consumidores* lo trackean. En el momento en que algo más depende de tu código (otro equipo, un paquete publicado, un cliente desplegado), "latest on main" deja de ser una respuesta suficiente a "¿qué estoy corriendo, y es seguro actualizar?" Un número de versión y un changelog son el contrato que la responde.

### Versionado semántico

Para cualquier cosa con consumidores, versionar `MAJOR.MINOR.PATCH` y dejar que el número tenga significado:

```
  MAJOR  cambio que rompe - los consumidores deben cambiar su código para actualizar
  MINOR  nueva funcionalidad, retrocompatible - seguro de actualizar
  PATCH  arreglo de bug, retrocompatible - seguro de actualizar
```

El número es una promesa, así que hacé que el código coincida con él. Un "patch" que cambia un comportamiento del que dependían los consumidores es un cambio major disfrazado (Ley de Hyrum - ver la skill `api-and-interface-design`). Cuando no estés seguro de si un cambio rompe algo, asumí que sí; un major sorpresa es mucho más barato que un consumidor roto.

### Taguear el release, y dejar que el tag sea la fuente de verdad

Un release es un punto inmutable en la historia, no una rama en movimiento. Taguearlo para que siempre pueda reproducirse:

```bash
git tag -a v1.4.0 -m "Release 1.4.0"
git push origin v1.4.0
```

Derivar la versión del tag en vez de editarla a mano en archivos dispersos, para que el artefacto, el tag y el changelog nunca puedan discrepar.

### Mantener un changelog escrito para humanos

Un changelog no es `git log`. Es la respuesta curada, orientada al consumidor, a "¿qué cambió y me importa?" - agrupada por `Added / Changed / Fixed / Deprecated / Removed / Security`, con lo más nuevo arriba, y cada entrada redactada alrededor del impacto para el usuario, no de la mecánica interna.

```markdown
## [1.4.0] - 2025-06-12
### Added
- Bulk task import via CSV
### Fixed
- Timezone drift in recurring task due dates
### Deprecated
- `GET /v1/tasks/all` - use the paginated `GET /v1/tasks` (removal in 2.0)
```

Escribir la entrada en el mismo cambio que hace el cambio, mientras el impacto está fresco - no reconstruida desde la arqueología de commits en el momento del release. Los cambios que rompen algo llevan una nota de migración y una ventana de deprecación (seguir la skill `deprecation-and-migration`); publicar el release real es trabajo de la skill `shipping-and-launch` - esta sección es el contrato de versionado que la alimenta.

## Racionalizaciones comunes

| Racionalización | Realidad |
|---|---|
| "Commitearé cuando la feature esté lista" | Un commit gigante es imposible de revisar, debuggear o revertir. Commitear cada slice. |
| "El mensaje no importa" | Los mensajes son documentación. El futuro vos (y los futuros agentes) necesitarán entender qué cambió y por qué. |
| "Lo squasheo todo después" | El squash destruye la narrativa de desarrollo. Preferir commits incrementales limpios desde el inicio. |
| "Las ramas agregan overhead" | Las ramas de vida corta son gratis y previenen que el trabajo conflictivo colisione. Las de larga vida son el problema: mergear dentro de 1-3 días. |
| "Dividiré este cambio después" | Los cambios grandes son más difíciles de revisar, más riesgosos de desplegar y más difíciles de revertir. Dividir antes de enviar, no después. |
| "No necesito un .gitignore" | Hasta que un `.env` con secrets de producción se commitee. Configurarlo de inmediato. |
| "Es solo un arreglo chico, bump al patch" | Revisá qué pueden observar los consumidores. Un cambio de comportamiento del que dependían es un major, sea cual sea el tamaño del diff. |
| "El changelog es solo el log de commits" | Los commits son para vos; el changelog es para los consumidores, curado por impacto. Generar uno desde commits crudos entierra lo que importa. |
| "Escribiremos el changelog en el release" | Para entonces el impacto se reconstruye desde la memoria y falta la mitad. Escribir la entrada con el cambio. |

## Red flags

- Cambios grandes sin commitear acumulándose
- Mensajes de commit como "fix", "update", "misc"
- Cambios de formato mezclados con cambios de comportamiento
- Sin `.gitignore` en el proyecto
- Commitear `node_modules/`, `.env` o artefactos de build
- Ramas de larga vida que divergen significativamente de main
- Force-push a ramas compartidas
- Un cambio que rompe algo publicado bajo un bump de minor o patch
- Un release sin tag, o un número de versión editado a mano fuera de sync con el tag
- Un release orientado al usuario sin entrada de changelog, o un changelog que solo es mensajes de commit volcados

## Verificación

Para cada commit:

- [ ] El commit hace una sola cosa lógica
- [ ] El mensaje explica el por qué, sigue las convenciones de tipo
- [ ] Los tests pasan antes de commitear
- [ ] Sin secrets en el diff
- [ ] Sin cambios solo de formato mezclados con cambios de comportamiento
- [ ] `.gitignore` cubre exclusiones estándar

Para cada release (cualquier cosa con consumidores):

- [ ] El bump de versión coincide con el cambio: rompe → major, aditivo → minor, arreglo → patch
- [ ] El release está tagueado, y la versión se deriva del tag, no editada a mano fuera de sync
- [ ] El changelog tiene una entrada curada y legible por humanos agrupada por impacto para esta versión
