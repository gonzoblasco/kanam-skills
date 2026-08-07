# Patrones de Orquestacion

Catalogo de referencia de los patrones de orquestacion de agentes que este repo respalda, mas los anti-patrones a evitar. Leelo antes de agregar un nuevo slash command que coordine multiples personas, o antes de introducir una nueva persona que "envuelva" a las existentes.

La regla rectora: **el usuario (o un slash command) es el orquestador. Las personas no invocan otras personas.** Las skills son pasos obligatorios dentro del flujo de trabajo de una persona.

---

## Patrones respaldados

### 1. Invocacion directa (sin orquestacion)

Una sola persona, una sola perspectiva, un solo artefacto. El default y la opcion mas barata.

```
usuario -> code-reviewer -> reporte -> usuario
```

**Usalo cuando:** el trabajo es una perspectiva sobre un artefacto y podes describirlo en una oracion.

**Ejemplos:**
- "Revisa este PR" -> `code-reviewer`
- "Encontra problemas de seguridad en `auth.ts`" -> `security-auditor`
- "Que pruebas faltan para el flujo de checkout?" -> `test-engineer`

**Costo:** un round trip. El baseline contra el que siempre deberias comparar los patrones orquestados.

---

### 2. Slash command de persona unica

Un slash command que envuelve a una persona con las skills del proyecto. Le ahorra al usuario re-explicar el flujo de trabajo cada vez.

```
/review -> code-reviewer (con la skill code-review-and-quality) -> reporte
```

**Usalo cuando:** la misma invocacion de persona unica ocurre repetidamente con la misma configuracion.

**Ejemplos en este repo:** `/review`, `/test`, `/code-simplify`.

**Costo:** igual que la invocacion directa. El slash command es solo un prompt guardado.

**Anti-senal:** si el cuerpo del slash command es en su mayoria "decidir que persona llamar", borralo y deja que el usuario llame a la persona directamente.

---

### 3. Fan-out paralelo con merge

Multiples personas operan sobre la misma entrada concurrentemente, cada una produciendo un reporte independiente. Un paso de merge (en el contexto del agente principal) los sintetiza en una sola decision.

```
                    +--> code-reviewer    -+
/ship -> fan out  --+--> security-auditor --+-> merge -> go/no-go + rollback
                    +--> test-engineer    -+
```

**Usalo cuando:**
- Las sub-tareas son genuinamente independientes (sin estado mutable compartido, sin dependencia de ordenamiento)
- Cada sub-agente se beneficia de su propia ventana de contexto
- El paso de merge es lo suficientemente pequeno para quedarse en el contexto principal
- La latencia de wall-clock importa

**Ejemplos en este repo:** `/ship`.

**Costo:** N contextos de sub-agente paralelos + un turno de merge. Mas alto que la invocacion directa, pero mas rapido en wall-clock y produce mejores reportes porque cada sub-agente se mantiene enfocado en su unica perspectiva.

**Checklist de validacion antes de adoptar este patron:**
- [ ] Puedo ejecutar todos los sub-agentes al mismo tiempo sin problemas de ordenamiento?
- [ ] Cada persona produce un *tipo* diferente de hallazgo, no solo el mismo hallazgo desde un angulo diferente?
- [ ] El paso de merge cabe en el contexto restante del agente principal?
- [ ] El tiempo de espera del usuario es lo suficientemente largo como para que el paralelismo sea realmente notable?

Si alguna respuesta es "no", cae a la invocacion directa o a un command de persona unica.

---

### 4. Pipeline secuencial como slash commands impulsados por el usuario

El usuario ejecuta slash commands en un orden definido, llevando contexto (o historial de commits) entre ellos. No hay agente orquestador: el usuario ES el orquestador.

```
el usuario ejecuta:  /spec  ->  /plan  ->  /build  ->  /test  ->  /review  ->  /ship
```

**Usalo cuando:** el flujo de trabajo tiene dependencias (cada paso necesita el output del paso anterior) y el juicio humano entre pasos agrega valor.

**Ejemplos en este repo:** todo el ciclo de vida DEFINE -> PLAN -> BUILD -> VERIFY -> REVIEW -> SHIP.

**Costo:** un contexto de sub-agente por paso. Gratis para la capa de orquestacion porque no hay agente orquestador.

**Por que no automatizarlo:** un "orquestador de ciclo de vida" LLM (a) perderia matices entre pasos porque tiene que resumir para el hand-off, (b) saltearia los checkpoints humanos que detectan temprano el trabajo con direccion equivocada, y (c) duplicaria el costo de tokens via turnos de parafraseo.

---

### 5. Aislamiento de investigacion (preservacion del contexto)

Cuando una tarea requiere leer grandes cantidades de material que no deberia contaminar el contexto principal, genera un sub-agente de investigacion que devuelve solo un resumen.

```
agente principal -> sub-agente de investigacion (lee 50 archivos) -> resumen -> el agente principal continua
```

**Usalo cuando:**
- La sesion principal necesita mantenerse enfocada en una tarea descendente
- El resultado de la investigacion es mucho mas pequeno que la entrada que consume
- La calidad de la decision se beneficia de que el agente principal tenga espacio para pensar despues

**Ejemplos:** "Encontra cada call site de esta API deprecada en el monorepo", "Resumi que dicen estos 30 ADRs sobre caching".

**Costo:** un contexto de sub-agente aislado. Vale la pena cada vez que la alternativa es cargar cientos de archivos en el contexto principal.

**En Claude Code, usa el subagente integrado `Explore`** en lugar de definir una persona de investigacion personalizada. `Explore` corre en Haiku, le niegan las herramientas de write/edit y esta construido a proposito para este patron. Define un subagente de investigacion personalizado solo cuando `Explore` no encaje (ej: necesitas un system prompt especifico del dominio que el modelo no inferiria).

---

## Compatibilidad con Claude Code

Este catalogo es agnóstico del harness, pero la mayoria de los lectores lo ejecutaran en Claude Code. Asi es como cada patron mapea sobre los primitivos de Claude Code, y donde la plataforma aplica nuestras reglas por nosotros.

### Donde viven las personas

Los subagentes de plugin van en `agents/` en la raiz del plugin. Este repo es un plugin (`.claude-plugin/plugin.json`), asi que `agents/code-reviewer.md`, `agents/security-auditor.md` y `agents/test-engineer.md` se auto-descubren cuando el plugin esta habilitado. Sin necesidad de configuracion de rutas.

### Subagentes vs. Agent Teams

Claude Code tiene dos primitivos de paralelismo. El Patron 3 (fan-out paralelo con merge) mapea a **subagentes**. Si necesitas teammates que hablen entre ellos, usa **Agent Teams**.

| | Subagentes | Agent Teams |
|--|-----------|-------------|
| Coordinacion | El agente principal hace fan-out, los sub-agentes solo reportan de vuelta | Los teammates se envian mensajes entre ellos, comparten una lista de tareas |
| Contexto | Ventana de contexto propia por subagente | Ventana de contexto propia por teammate |
| Cuando usarlo | Tareas independientes que producen reportes | Trabajo colaborativo que necesita discusion |
| Estado | Estable | Experimental: requiere `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
| Costo | Mas bajo | Mas alto: cada teammate es una instancia de Claude separada |

**Las personas de este repo funcionan en ambos modos.** Cuando se generan como subagentes (ej: por `/ship`), reportan hallazgos a la sesion principal. Cuando se generan como teammates ("Genera un teammate usando el tipo de agente security-auditor..."), pueden cuestionar directamente los hallazgos de los otros. La definicion de la persona es la misma; solo cambia el contexto de generacion.

Una sutileza: los campos de frontmatter `skills` y `mcpServers` de una persona se respetan cuando corre como subagente pero se **ignoran cuando corre como teammate**: los teammates cargan las skills y los MCP servers desde tu proyecto y configuracion de usuario, igual que una sesion regular. Si una persona depende de que se cargue una skill o un MCP server especifico, configuralo a nivel de sesion para que este disponible en ambos modos.

### Reglas aplicadas por la plataforma

Dos reglas de este catalogo no son solo convencion: Claude Code las aplica:

- **"Los subagentes no pueden generar otros subagentes"** (verbatim de los docs). El anti-patron B (persona-llama-a-persona) y el anti-patron D (arboles de personas profundos) no pueden existir en Claude Code por construccion.
- **"Sin equipos anidados"** - los teammates no pueden generar sus propios equipos. Los mismos anti-patrones quedan bloqueados a nivel de equipo.

Esto significa que podes adoptar los patrones de este catalogo sin preocuparte de que los contribuidores construyan accidentalmente los anti-patrones. Simplemente fallaran al cargar.

### Subagentes integrados a conocer

Antes de definir un subagente personalizado, revisa si uno de estos cubre el rol:

| Integrado | Proposito |
|-----------|----------|
| `Explore` | Busqueda y analisis de codebase de solo lectura. Usalo para el Patron 5 (aislamiento de investigacion). |
| `Plan` | Investigacion de solo lectura durante el modo plan. |
| `general-purpose` | Tareas de multiples pasos que necesitan tanto exploracion como modificacion. |

No los redefinas. Coloca tus personas especialistas (code-reviewer, security-auditor, test-engineer) encima de ellos.

### Restricciones de frontmatter para agentes de plugin

Los subagentes de plugin **no** soportan los campos de frontmatter `hooks`, `mcpServers` ni `permissionMode`: se ignoran silenciosamente. Si una persona futura necesita alguno de esos, el usuario debe copiar el archivo a `.claude/agents/` o `~/.claude/agents/` en su lugar.

Los campos que SI funcionan en los agentes de plugin son: `name`, `description`, `tools`, `disallowedTools`, `model`, `maxTurns`, `skills`, `memory`, `background`, `effort`, `isolation`, `color`, `initialPrompt`. Usa `model` por persona si quieres optimizar costo (ej: Haiku para los escaneos de cobertura de `test-engineer`, Sonnet para `code-reviewer`, Opus para `security-auditor`).

### Generar multiples subagentes en paralelo

En Claude Code, el fan-out paralelo (Patron 3) requiere emitir **multiples llamadas a la herramienta Agent en un solo turno del asistente**. Los turnos secuenciales serializan la ejecucion. `/ship` lo señala explicitamente. Cualquier command de orquestador nuevo deberia hacer lo mismo.

---

## Ejemplo trabajado: Agent Teams para depuracion de hipotesis en competencia

Este ejemplo muestra cuando recurrir a **Agent Teams** en lugar del fan-out de subagentes de `/ship`. Los dos patrones se ven similares desde lejos: ambos generan las mismas tres personas. Pero el valor viene de un lugar diferente.

### El escenario

> *El checkout ocasionalmente se cuelga durante ~30 segundos antes de completarse. Sucede aproximadamente una vez cada 50 sesiones. Sin errores en los logs. Empezo despues del release de la semana pasada.*

Causas raiz plausibles (mutuamente excluyentes, todas encajan con los sintomas):

1. Una race condition en el nuevo flujo de confirmacion de pago
2. Un chequeo de auth que ocasionalmente cae a una llamada de red sincronica lenta
3. Un indice faltante en una consulta que escala con el tamano del carrito
4. Una API de terceros inestable donde el SDK reintenta silenciosamente antes de dar timeout

Un agente unico elegira la primera teoria plausible y dejara de investigar. Un fan-out de subagentes estilo `/ship` haria que cada persona reportara independientemente, pero sus reportes nunca se encuentran, asi que nada descarta las teorias equivocadas.

Este es exactamente el caso que describen los docs de Agent Teams: *"Con multiples investigadores independientes tratando activamente de refutar a los otros, la teoria que sobrevive tiene muchas mas probabilidades de ser la causa raiz real."*

### Por que esto *no* es un trabajo para `/ship`

| | `/ship` (subagentes) | Agent Teams |
|--|---------------------|-------------|
| Lo que ven los sub-agentes | El mismo diff, lentes diferentes | Una lista de tareas compartida, los mensajes de los otros |
| Output | Tres reportes independientes -> un merge | Debate adversarial -> causa raiz por consenso |
| Correcto cuando | Queres un veredicto sobre un artefacto conocido | Queres *encontrar* el artefacto entre hipotesis |

`/ship` es un veredicto; Agent Teams es una investigacion.

### Configuracion (una vez, por entorno)

Agent Teams es experimental. En `~/.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Requiere Claude Code v2.1.32 o posterior. Las personas de este repo se detectan automaticamente: no hay archivos de configuracion de equipos que redactar a mano.

### El prompt de disparo

Escribe en la sesion principal, en lenguaje natural:

```
Los usuarios reportan que el checkout se cuelga ~30 segundos
intermitentemente despues del release de la semana pasada. Sin errores
en los logs.

Crea un agent team para depurar esto con hipotesis en competencia.
Genera tres teammates usando los tipos de agente existentes:

  - code-reviewer: investiga race conditions y llamadas bloqueantes
                     en el camino del codigo del checkout
  - security-auditor: investiga los chequeos de auth, el manejo de
                       sesion y cualquier llamada de red sincronica
                       agregada recientemente
  - test-engineer: propone pruebas que distingan entre las hipotesis
                    y revisa los huecos de cobertura en el checkout

Que se envien mensajes directamente entre ellos para cuestionar sus
teorias. Actualiza los hallazgos a medida que emerja consenso. Solo
converge cuando dos teammates coincidan en que pueden refutar a los
otros'.
```

El lead genera tres teammates referenciando los nombres de las personas existentes. El cuerpo de la persona se **agrega** al system prompt de cada teammate como instrucciones adicionales (encima de las instrucciones de coordinacion del equipo que instala el lead); el prompt de disparo de arriba se convierte en su tarea.

### Que pasa

1. Cada teammate corre en su propia ventana de contexto, explorando el codebase desde su propio lente.
2. Los teammates usan `message` para enviarse hallazgos directamente. El lead no tiene que retransmitir.
3. La lista de tareas compartida muestra quien investiga que, visible en cualquier momento con `Ctrl+T` (modo in-process) o en un panel de tmux (modo split).
4. Cuando `code-reviewer` encuentra un `Promise.all` que deberia ser secuencial, le manda un mensaje a `security-auditor` para confirmar que la llamada de auth no es parte de la race. `security-auditor` lo verifica y responde, confirmando que la race es el problema real o produciendo contra-evidencia.
5. `test-engineer` propone un test de integracion enfocado para la teoria que vaya ganando, que el equipo usa para verificar antes de declarar consenso.
6. El lead sintetiza el hallazgo convergido y te lo presenta.

Podes interrumpir a cualquier teammate ciclando con `Shift+Down` y escribiendo: util para redirigir a un investigador que se fue por un camino equivocado.

### Cuando limpiar

Cuando la investigacion aterrice en una causa raiz, dile al lead:

```
Limpia el equipo
```

Limpia siempre a traves del lead, no de un teammate (segun los docs: los teammates carecen del contexto completo del equipo para la limpieza).

### Expectativa de costo

Tres teammates Sonnet corriendo ~10-15 minutos de investigacion cuesta notablemente mas que las mismas tres personas generadas como subagentes por `/ship`. La justificacion es la *calidad de la conclusion*: para la depuracion en produccion donde el fix equivocado es caro, los tokens extra son una ganga. Para una revision de PR rutinaria, quedate con `/ship`.

### Anti-patron en este escenario

No reconstruyas esto como un slash command `/debug` que haga fan-out de subagentes. Los subagentes no pueden enviarse mensajes entre ellos: perderias el debate adversarial que hace funcionar al patron. Si un flujo de trabajo sigue apareciendo, documenta el prompt de disparo de arriba como un snippet en lugar de envolverlo en un slash command que use mal los subagentes.

### Cuando *no* usar Agent Teams

- Veredicto destinado a produccion sobre un diff conocido -> usa `/ship` (subagentes).
- Una perspectiva especialista sobre un artefacto -> invocacion directa de persona.
- Ciclo de vida secuencial (spec -> plan -> build) -> slash commands impulsados por el usuario (Patron 4).
- Investigacion pesada de lectura con un resumen pequeno -> subagente `Explore` integrado.

Recurre a Agent Teams solo cuando los teammates **necesiten** cuestionarse entre ellos para producir la respuesta correcta.

---

## Anti-patrones

### A. Persona router ("meta-orquestador")

Una persona cuyo trabajo es decidir que otra persona llamar.

```
/work -> router-persona -> "esto necesita una revision" -> code-reviewer -> router (parafrasea) -> usuario
```

**Por que falla:**
- Capa de puro routing sin valor de dominio
- Agrega dos pasos de parafraseo -> perdida de informacion + costo de tokens de ~2x
- El usuario ya sabia que queria una revision; podria haber llamado a `/review` directamente
- Replica el trabajo que los slash commands y el mapeo de intenciones en `AGENTS.md` ya hacen

**Que hacer en su lugar:** agrega o refina slash commands. Documenta el mapeo intencion -> command en `AGENTS.md`.

---

### B. Persona que llama a otra persona

Un `code-reviewer` que internamente invoca a `security-auditor` cuando ve codigo de auth.

**Por que falla:**
- Las personas fueron disenadas para producir una unica perspectiva; encadenarlas la derrota
- El resumen que pasa la persona llamadora pierde contexto que la persona llamada necesita
- Los modos de falla se multiplican (cuyo formato de output gana? de quien son las reglas?)
- Le oculta el costo al usuario

**Que hacer en su lugar:** haz que la persona llamadora *recomiende* una auditoria de seguimiento en su reporte. El usuario o un slash command ejecuta la segunda pasada.

---

### C. Orquestador secuencial que parafrasea

Un agente que llama `/spec`, luego `/plan`, luego `/build`, etc. en nombre del usuario.

**Por que falla:**
- Pierde los checkpoints humanos que detectan el trabajo con direccion equivocada
- Cada hand-off resume contexto: deriva acumulada a lo largo de un pipeline largo
- Duplica el costo de tokens: turno del orquestador + turno del sub-agente por cada paso
- Le quita agencia al usuario exactamente en los puntos donde el juicio importa mas

**Que hacer en su lugar:** mantene al usuario como el orquestador. Documenta la secuencia recomendada en `README.md` y deja que los usuarios la invoquen.

---

### D. Arboles de personas profundos

`/ship` llama a un `pre-ship-coordinator` que llama a un `quality-coordinator` que llama a `code-reviewer`.

**Por que falla:**
- Cada capa agrega latencia y tokens sin valor de decision
- La depuracion se convierte en una investigacion de multiples niveles
- Las personas hoja pierden contexto por multiples pasos de resumen

**Que hacer en su lugar:** mantene la profundidad de orquestacion en 1 como maximo (slash command -> personas). El merge sucede en el agente principal.

---

## Flujo de decision

Cuando consideres un flujo de trabajo orquestado nuevo, recorre este flujo:

```
Es el trabajo una perspectiva sobre un artefacto?
+-- Si -> Invocacion directa. Detente.
+-- No -> Se repetira la misma composicion?
         +-- No -> Invocacion directa, ad hoc. Detente.
         +-- Si -> Son las sub-tareas independientes?
                  +-- No -> Slash commands secuenciales ejecutados por el usuario (Patron 4).
                  +-- Si -> Fan-out paralelo con merge (Patron 3).
                           Valida contra la checklist de arriba.
                           Si algun chequeo falla -> cae a un command de persona unica (Patron 2).
```

---

## Cuando agregar un patron nuevo a este catalogo

Agrega una entrada nueva solo despues de:

1. Haber usado el patron al menos dos veces en trabajo real
2. Poder nombrar un artefacto concreto en este repo que lo demuestre
3. Poder explicar por que un patron existente no habria funcionado
4. Poder describir su sombra de anti-patron (que construiria la gente por error en su lugar)

Las entradas prematuras en el catalogo se vuelven documentacion aspiracional que nadie sigue.
