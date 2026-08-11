---
name: "background-execution"
description: "Patrones para ejecutar tareas en background: exec + process, parallel worktrees, auto-notify, isolated workspaces"
metadata:
  category: "Workflow"
  tags:
    - background
    - procesos
    - paralelismo
    - exec
    - process
user-invocable: false
---

# Workflow: Background Execution

## Propósito
Ejecutar tareas largas, batch, o paralelas en background usando `exec` + `process`, con monitoreo, notificación al completar, y aislamiento de workspace. Complementa a `task-execution` para tareas que no requieren interacción constante.

## Cuándo usarlo
- Tareas largas (>30s) que no necesitan supervisión constante
- Batch processing (múltiples archivos, reviews, fixes)
- Tareas paralelas independientes (un proceso por issue, por PR, por módulo)
- Cualquier proceso interactivo que requiera PTY (coding agents, TUIs, REPLs)
- Cuando necesitás lanzar algo y que avise cuando termine sin esperar heartbeat

## Principios

1. **Nunca esperar pasivamente.** Si una tarea va a tardar, lanzarla en background y seguir con otra cosa.
2. **Siempre aislar.** Cada tarea en su propio directorio temporal o git worktree. Nunca tocar el repo principal sin approval explícito.
3. **Siempre notificar.** Toda tarea background debe terminar con un wake event. No dejar que el usuario pregunte "¿ya terminó?".
4. **PTY para interactivos, no para batch.** Procesos interactivos (coding agents, prompts) → `pty:true`. Scripts batch → `pty:false` (default).
5. **Siempre loggear.** Cada proceso background deja un archivo de log con resultado, tiempo, y métricas. No confiar en la memoria de la sesión.
6. **Intervenir antes de que sea tarde.** Si un proceso no da señales de vida, intervenir. No esperar a que se cuelgue definitivamente.

## Patrones

### Patrón 1: Lanzar y Monitorear

El patrón base para cualquier tarea background:

```yaml
# 1. Lanzar
exec(command: "...", pty: true, background: true, workdir: "/tmp/task-xyz")

# 2. Monitorear (cuando quieras ver estado)
process(action: poll, sessionId: "<id>")

# 3. Ver logs
process(action: log, sessionId: "<id>", offset: 0, limit: 50)

# 4. Enviar input (si el proceso pregunta algo)
process(action: submit, sessionId: "<id>", text: "y")

# 5. Matar (si se cuelga)
process(action: kill, sessionId: "<id>")
```

**Regla:** después de lanzar, no hacer poll loop. Seguir con otra cosa y dejar que el completion wake avise.

### Patrón 2: Aislar en Temp Dir

Para tareas que necesitan un workspace limpio:

```yaml
# 1. Crear temp dir
exec(command: "mktemp -d")
# → devuelve /tmp/tmp.XXXXX

# 2. Clonar / preparar en ese dir
exec(command: "git clone <url> /tmp/tmp.XXXXX/repo", workdir: "/tmp/tmp.XXXXX")

# 3. Trabajar ahí
exec(command: "npm run build", workdir: "/tmp/tmp.XXXXX/repo", background: true)

# 4. Al terminar, limpiar
exec(command: "trash /tmp/tmp.XXXXX")
```

**Regla:** siempre limpiar al terminar. Usar `trash` (no `rm -rf`) por si algo sale mal.

### Patrón 3: Git Worktree para Tareas Paralelas

Para trabajar en múltiples issues/PRs en paralelo sin contaminar el repo:

```yaml
# 1. Crear worktree por tarea
exec(command: "git worktree add -b fix/issue-78 /tmp/issue-78 main")
exec(command: "git worktree add -b fix/issue-79 /tmp/issue-79 main")

# 2. Lanzar proceso en cada worktree
exec(command: "<comando>", workdir: "/tmp/issue-78", background: true, pty: true)
exec(command: "<comando>", workdir: "/tmp/issue-79", background: true, pty: true)

# 3. Monitorear todos
process(action: list)

# 4. Al terminar, mergear y limpiar
exec(command: "cd /repo/main && git merge fix/issue-78")
exec(command: "git worktree remove /tmp/issue-78")
```

**Regla:** un worktree por tarea. Nombrar branches descriptivamente. Mergear solo después de verificar que cada tarea está completa.

### Patrón 4: Auto-Notify al Completar

Para que una tarea background avise inmediatamente cuando termina:

```yaml
# Incluir al final del comando o script:
cron(action: wake, text: "✅ Tarea X completada: [resumen]", mode: "now")
```

**Regla:** toda tarea background DEBE terminar con un wake event. No confiar en heartbeats ni en que el usuario va a preguntar.

**Formato del texto:** incluir qué tarea, resultado (éxito/fallo), y qué sigue. Ej: "✅ Batch review completado: 3 PRs revisados, 1 con cambios solicitados. Revisar PR #78."

### Patrón 5: Parallel Batch con Sessions Spawn

Para tareas que requieren contexto conversacional (reviews, análisis):

```yaml
# Lanzar sub-agentes en paralelo
sessions_spawn(task: "Revisar PR #78 en <repo>", context: "isolated")
sessions_spawn(task: "Revisar PR #79 en <repo>", context: "isolated")

# Esperar resultados
sessions_yield()
```

**Regla:** `sessions_spawn` para tareas que necesitan razonamiento. `exec` + `process` para tareas que son puro comando (build, test, batch script).

### Patrón 6: submit vs write - Input a Procesos

Cuando un proceso background espera input:

| Acción | Qué hace | Cuándo usarlo |
|---|---|---|
| `process(action: submit, text: "y")` | Escribe texto + Enter | Respuestas a prompts ("¿Continuar? [y/N]") |
| `process(action: write, data: "texto")` | Escribe texto crudo (sin Enter) | Streaming, input parcial |
| `process(action: send-keys, keys: ["ctrl+c"])` | Envía combinación de teclas | Interrumpir, salir de modo insert |

### Patrón 7: Intervención - Detectar y Rescatar Procesos Colgados

Cuando un proceso background no da señales de vida:

```yaml
# 1. Verificar si sigue vivo
process(action: poll, sessionId: "<id>")

# 2. Si está vivo pero no produce output, ver logs recientes
process(action: log, sessionId: "<id>", offset: -20)

# 3. Si está esperando input sin mostrar prompt, enviar señal
process(action: send-keys, sessionId: "<id>", keys: ["ctrl+c"])
# o forzar salida
process(action: submit, sessionId: "<id>", text: "exit")

# 4. Si no responde, matar
process(action: kill, sessionId: "<id>")

# 5. Decidir: reintentar con menos carga, o escalar
```

**Señales de proceso colgado:**
- `process(action: poll)` devuelve "running" pero no hay output nuevo en minutos
- El proceso debería haber terminado pero sigue activo
- Logs muestran el mismo mensaje repetido (loop infinito)

**Regla:** si un proceso lleva más del doble del tiempo esperado sin output nuevo, intervenir. No esperar a que se cuelgue definitivamente.

### Patrón 8: Consolidación de Resultados Paralelos

Después de lanzar N procesos en paralelo, consolidar resultados:

```yaml
# 1. Cada proceso escribe su resultado a un archivo compartido
exec(command: "echo '{\"status\":\"ok\",\"task\":\"issue-78\"}' >> /tmp/batch-results.jsonl")

# 2. Al final, leer todos los resultados
exec(command: "cat /tmp/batch-results.jsonl")

# 3. Consolidar: contar éxitos, fallos, pendientes
# 4. Decidir próximos pasos según resultados
```

**Formato de resultado (cada proceso escribe una línea JSON):**
```json
{"task": "issue-78", "status": "ok", "duration": 45, "output": "resumen"}
{"task": "issue-79", "status": "fail", "duration": 120, "error": "timeout en paso 3"}
```

**Regla:** no consolidar en memoria. Cada proceso escribe su resultado a disco. Después se lee todo junto.

### Patrón 9: Logging de Procesos

Cada proceso background debe dejar un rastro:

```yaml
# Al lanzar, redirigir output a un archivo de log
exec(command: "<comando> 2>&1 | tee /tmp/logs/task-xyz-$(date +%s).log", background: true)

# O al final, escribir un resumen
exec(command: "echo 'Tarea completada: $(date)' >> /tmp/logs/task-xyz-result.txt")
```

**Qué loggear por proceso:**
- Timestamp de inicio y fin
- Comando ejecutado
- Código de salida (0 = éxito, != 0 = fallo)
- Resumen de output (primeras y últimas líneas)
- Si falló: mensaje de error

**Regla:** los logs de procesos background se guardan en `/tmp/logs/` con nombre descriptivo. Se limpian al guardar sesión o cuando ocupen más de 50MB.

## Reglas de PTY

| Tipo de proceso | pty | Razón |
|---|---|---|
| Coding agent (Codex, Claude Code) | `true` | Son TUIs interactivos, sin PTY se cuelgan |
| Script batch (build, test, lint) | `false` | No necesita terminal, ahorra recursos |
| REPL (node, python, psql) | `true` | Espera input interactivo |
| git command | `false` | Batch, no interactivo |
| npm/pnpm command | `false` | Batch, salida estructurada |

## Integración con task-execution

Cuando una tarea de `task-execution` tiene pasos que son largos o paralelizables:

1. **Planificar** normalmente en `task-execution`
2. **Los pasos batch/paralelos** se ejecutan con estos patrones
3. **Monitorear** con `process` o esperar wake events
4. **Consolidar resultados** con el patrón 8
5. **Continuar** cuando todos los pasos background completaron

## Outputs
- Procesos lanzados y monitoreados
- Resultados consolidados al completar
- Wake events de notificación
- Temp dirs / worktrees limpiados
- Logs de cada proceso en `/tmp/logs/`

## Tooling de calidad

Cuando una tarea background modifica scripts de skill del workspace, correr `npm test` antes de considerarla completa. Esto ejecuta `test-skills.sh`, bats y pytest.

## Related Skills

- [Task Execution](../task-execution): Para el workflow completo de tareas
- [Session Lifecycle](../session-lifecycle): Para handoffs y guardado de sesión
- [Debug Investigation](../debug-investigation): Para debugging de procesos que fallan
