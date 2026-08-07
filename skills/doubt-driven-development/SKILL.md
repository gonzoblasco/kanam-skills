---
name: doubt-driven-development
description: Somete toda decision no trivial a una revision adversarial con contexto fresco antes de que prevalezca. Usalo cuando la correccion importe mas que la velocidad, cuando trabajes en codigo desconocido, cuando haya mucho en juego (produccion, logica sensible a seguridad, operaciones irreversibles), o en cualquier momento en que un output confiado seria mas barato de verificar ahora que de depurar despues.
---

# Desarrollo Impulsado por la Duda

## Resumen

Una respuesta confiada no es una respuesta correcta. Las sesiones largas acumulan contexto que silenciosamente convierte suposiciones en "hechos" sin que nadie lo note. El desarrollo impulsado por la duda es la disciplina de materializar un revisor con contexto fresco, sesgado a **refutar**, no a aprobar, antes de que prevalezca cualquier output no trivial.

Esto no es `/review`. `/review` es un veredicto sobre un artefacto terminado. Esto es una postura en vuelo: las decisiones no triviales se someten a un contrainterrogatorio mientras la correccion del rumbo todavia es barata.

## Cuando Usarlo

Una decision es **no trivial** cuando al menos una de estas cosas es verdad:

- Introduce o modifica logica de ramificacion
- Cruza un limite de modulo o servicio
- Afirma una propiedad que el type system o el compilador no pueden verificar (thread safety, idempotencia, ordenamiento, invariantes)
- Su correccion depende de un contexto que el lector futuro no puede ver
- Su radio de impacto es irreversible (despliegue a produccion, migracion de datos, cambio de API publica)

Aplica la skill cuando:

- Estes por tomar una decision arquitectonica bajo incertidumbre
- Estes por commiteear codigo no trivial
- Estes por afirmar un hecho no obvio ("esto es seguro", "esto escala", "esto coincide con el spec")
- Trabajes en codigo que no entendes del todo

**Cuando NO usarla:**

- Operaciones mecanicas (renombrar, formatear, mover archivos)
- Seguir una instruccion clara e inequivoca del usuario
- Leer o resumir codigo existente
- Cambios de una linea con correccion obvia
- Operaciones de puro tooling (ejecutar pruebas, listar archivos)
- El usuario pidio explicitamente velocidad sobre verificacion

Si dudas de cada pulsacion de tecla, no publicas nada. La skill aplica solo a decisiones no triviales como se definen arriba.

## Restricciones de Carga

Esta skill esta disenada para el **orquestador de la sesion principal**, donde el Paso 3 (DOUBT, detallado abajo) puede generar un revisor con contexto fresco.

- **NO agregues esta skill al frontmatter `skills:` de una persona.** Una persona que siguiera el Paso 3 generaria otra persona: el anti-patron de orquestacion explicitamente prohibido por `references/orchestration-patterns.md` ("las personas no invocan otras personas").
- **Si te encontras aplicando esta skill desde dentro de un contexto de subagente** (donde Claude Code impide el spawn de subagentes anidados): el camino preferido es senalar al usuario que doubt-driven no puede ejecutarse anidado y dejar que la sesion principal lo maneje. Solo como ultimo recurso, existe un fallback degradado de auto-cuestionamiento: reescribe ARTIFACT + CONTRACT como un auto-prompt fresco con un separador mental duro de tu razonamiento previo, y recorre los Pasos 1-5. Esto **no es una revision con contexto fresco** (cargas tu propio contexto contigo), asi que marca el resultado como degradado y prefiere la escalacion siempre que el usuario este alcanzable.

## El Proceso

Copia esta checklist cuando apliques la skill:

```
Ciclo de duda:
- [ ] Paso 1: CLAIM - escribi la afirmacion + por que-importa
- [ ] Paso 2: EXTRACT - aisla el artefacto + el contrato, sin el razonamiento
- [ ] Paso 3: DOUBT - invoco un revisor con contexto fresco con prompt adversarial
- [ ] Paso 4: RECONCILE - clasifique cada hallazgo contra el texto del artefacto
- [ ] Paso 5: STOP - se cumplio la condicion de parada (hallazgos triviales, 3 ciclos o override del usuario)
```

### Paso 1: CLAIM - Saca a la superficie lo que prevalece

Nombra la decision en dos o tres lineas:

```
CLAIM: "La nueva capa de cache es thread-safe bajo la
        carga de lectura intensiva descrita en el spec."
POR QUE IMPORTA: una race aqui corrompe los datos del
                 usuario y es dificil de detectar en QA.
```

Si no podes escribir la afirmacion de forma tan compacta, tenes una vibracion, no una decision. Sacala a la superficie antes de escudriñarla.

### Paso 2: EXTRACT - La unidad revisable mas pequena

Un revisor con contexto fresco necesita el **artefacto** y el **contrato**, no el viaje.

- Codigo: el diff o la funcion, no el archivo entero
- Decision: la propuesta en 3-5 oraciones mas las restricciones que tiene que satisfacer
- Afirmacion: la afirmacion mas la evidencia que supuestamente la respalda (mantenida distinta del bloque CLAIM del Paso 1, que es la hipotesis del orquestador bajo escrutinio)

Quita tu razonamiento. Si entregas conclusiones, te van a devolver la validacion de tus conclusiones. La unidad debe ser lo suficientemente pequena como para que un revisor la pueda sostener en mente en una lectura: si es un PR de 500 lineas, descompone primero.

### Paso 3: DOUBT - Invoca el revisor con contexto fresco

El prompt del revisor **debe ser adversarial**. El encuadre decide la respuesta.

```
Revision adversarial. Encontra que esta mal en este artefacto.
Asumi que el autor esta demasiado confiado. Busca:
- Suposiciones no declaradas
- Casos borde no manejados
- Acoplamiento oculto o estado compartido
- Formas en que el contrato podria violarse
- Convenciones existentes que esto podria romper
- Modos de falla bajo entrada inesperada

NO valides. NO resumas. Encontra problemas, o declara
explicitamente que no puedes encontrar ninguno despues de un
examen exhaustivo.

ARTIFACT: <pega el artefacto>
CONTRACT: <pega el contrato>
```

**Pasa SOLO ARTIFACT + CONTRACT. NO pases el CLAIM.** Entregarle al revisor tu conclusion lo sesga hacia el acuerdo. El revisor debe determinar independientemente si el artefacto satisface el contrato.

En Claude Code, los revisores basados en roles en `agents/` arrancan con contexto aislado por diseno y son usables aqui: ver `agents/` para el roster y el emparejamiento por dominio.

**El prompt adversarial de arriba tiene precedencia sobre la forma de respuesta default de la persona.** Personas como `code-reviewer` estan escritas para producir veredictos balanceados con tanto fortalezas como debilidades; doubt-driven necesita output de solo problemas. Pega el prompt adversarial verbatim en la invocacion para que sobreescriba el default de la persona. Si la forma de respuesta de una persona no se puede sobreescribir limpiamente, cae a un subagente generico con el prompt adversarial.

#### Escalacion cross-model

Un revisor de un solo modelo comparte puntos ciegos con el autor original: un modelo mas frio y de arquitectura diferente los detecta. Doubt-driven ya es opt-in para decisiones no triviales, asi que dentro de ese alcance, ofrecer cross-model es parte del valor de la skill, no friccion opcional.

**Sesiones interactivas: ofrece siempre. Nunca te saltes silenciosamente.**

**Paso 1: Pregunta al usuario**

Despues de la revision de un solo modelo en el Paso 3 de arriba, pero antes de RECONCILE, pausa y pregunta:

> *"Revision de un solo modelo completa. Queres una segunda opinion cross-model? Opciones: Gemini CLI, Codex CLI, revision externa manual (la pegas en otro lado), o saltear."*

Esta pregunta es obligatoria en cada ciclo de duda interactivo, incluso en artefactos que se sientan de bajo riesgo. El usuario, no el agente, decide si el costo vale la pena. El trabajo del agente es sacar a la superficie la eleccion.

**Paso 2: Si el usuario elige un CLI: verifica, luego invoca**

1. Revisa que la herramienta este en PATH (`which gemini`, `which codex`).
2. Prueba que funciona (`gemini --version` o equivalente) antes de pasar el prompt completo: un binario viejo o roto puede pasar el `which` pero fallar en la entrada real.
3. Confirma la invocacion exacta con el usuario, incluidos los flags requeridos, el auth y las env vars (ej: API keys). Las implementaciones varian; nunca asumas.
4. Pasa ARTIFACT + CONTRACT + el prompt adversarial **solamente**. Sin contexto de sesion, sin CLAIM.
5. Ojo con el shell escaping. Si el artefacto contiene comillas, `$(...)` o backticks, prefiere stdin (`echo … | gemini`) o un heredoc sobre el `-p "…"` inline. Cuando tengas dudas, pide al usuario que confirme la invocacion antes de ejecutarla.
6. Lleva el output al Paso 4 (RECONCILE).

**Nunca interpoles el artefacto en un argumento entre comillas de shell.** El codigo, el markdown y los prompts de revision contienen rutinariamente backticks, `$(...)` y caracteres de comillas que o truncaran el prompt o ejecutaran shell embebido. Escribe el prompt completo en un archivo y pasalo por stdin.

Formas de ejemplo (verifica los flags contra tu herramienta instalada: la sintaxis difiere entre implementaciones y versiones):

```bash
# Escribe primero el prompt adversarial + ARTIFACT + CONTRACT en un archivo temporal.
# Luego pasalo por stdin para que los metacaracteres de shell en el artefacto queden inertes.

# Codex (el sandbox de solo lectura evita que el CLI escriba en tu workspace):
codex exec --sandbox read-only -C <ruta-del-repo> - < /tmp/doubt-prompt.md

# Gemini ('--approval-mode plan' es de solo lectura; '-p ""' dispara el modo
# no interactivo y el prompt se lee de stdin):
gemini --approval-mode plan -p "" < /tmp/doubt-prompt.md
```

El sandbox de solo lectura es el detalle que sostiene la carga: un artefacto de duda puede contener el mismo instrucciones (inyeccion de prompt intencional o accidental) que el CLI cross-model ejecutaria de otro modo contra tu workspace.

**Paso 3: Si el CLI no esta disponible o falla**

Saca a la superficie el fallo explicitamente. Ofrece: ejecutarlo manualmente, probar con otra herramienta o saltear. No caigas silenciosamente a un solo modelo: el usuario deberia saber que el cross-model no sucedio.

**Paso 4: Si el usuario saltea**

Reconoce el salteo en el output (*"Continuando solo con los hallazgos de un solo modelo"*) y continua a RECONCILE. Saltear esta bien; saltear silenciosamente no lo esta.

**Contextos no interactivos** (CI, `/loop`, loop autonomo, corridas programadas):

- El cross-model se **saltea**, y el salteo debe **anunciarse** en el output: *"Cross-model omitido: contexto no interactivo."*
- **Nunca invoques un CLI externo sin autorizacion explicita del usuario** - esta es una propiedad de seguridad que sostiene la carga.

El cross-model agrega costo, latencia y fragilidad de herramientas. El agente saca a la superficie la eleccion cada ciclo; el usuario decide si este artefacto lo amerita.

### Paso 4: RECONCILE - Dobla los hallazgos de vuelta

El output del revisor son datos, no un veredicto. **Vos seguis siendo el orquestador.** Re-lee el texto del artefacto contra cada hallazgo antes de clasificar: sellar con goma el visto bueno del revisor es el mismo modo de falla que ignorarlo.

Para cada hallazgo, clasifica en este **orden de precedencia** (gana la primera clase que coincida):

1. **Lectura erronea del contrato** - el revisor marco algo especificamente porque el CONTRACT que diste era poco claro o incompleto. Arregla primero el contrato, re-clasifica en el proximo ciclo.
2. **Valido + accionable** - problema real que requiere un cambio al artefacto. Cambialo, re-hace el loop.
3. **Trade-off valido** - el problema es real pero el costo de arreglarlo supera el costo de aceptarlo. Documenta el trade-off explicitamente para que el usuario lo vea.
4. **Ruido** - el revisor marco algo que en realidad es correcto bajo un contexto que el revisor no tenia. Anotalo, segui adelante y preguntate: agregar ese contexto al contrato habria prevenido el falso flag?

Un revisor fresco puede estar equivocado porque le falta contexto. No difieras solo porque es "fresco".

### Paso 5: STOP - Loop acotado, no recursion

Detente cuando:

- La proxima iteracion devuelve solo hallazgos triviales o ya considerados, **o**
- Se completaron 3 ciclos (escala al usuario, no muelas un cuarto solo), **o**
- El usuario dice explicitamente "largalo"

Si despues de 3 ciclos el revisor sigue sacando a la superficie problemas sustanciales, el artefacto puede no estar listo. Sacaselo a la superficie al usuario: tres ciclos sin resolver es informacion sobre el artefacto, no una razon para seguir en loop.

Si 3 ciclos es "obviamente insuficiente" porque el artefacto es grande: el artefacto es demasiado grande: volve al Paso 2 y descompone. No levantes el limite.

## Racionalizaciones Comunes

| Racionalizacion | Realidad |
|---|---|
| "Estoy confiado, salteame el paso de la duda" | La confianza correlaciona pobremente con la correccion en problemas novedosos. Los momentos de certeza son exactamente donde se esconden los puntos ciegos. |
| "Generar un revisor es caro" | Depurar un commit equivocado en produccion es mas caro. El chequeo esta acotado; el bug no lo esta. |
| "El revisor solo va a hacer nitpick" | Solo si no esta acotado. Limita el prompt a "problemas que harian fallar esto bajo el contrato". |
| "Hare la duda al final con `/review`" | `/review` es una puerta final. Doubt-driven detecta direcciones equivocadas temprano, cuando la correccion del rumbo es barata. Para el momento del PR ya es tarde. |
| "Si dudo de cada paso nunca publico" | La skill aplica a decisiones no triviales, no a cada pulsacion de tecla. Re-lee "Cuando NO usarla". |
| "Dos opiniones siempre son mejores que una" | No cuando la segunda tiene menos contexto y produce ruido. Reconcilia, no difieras. |
| "El revisor no estuvo de acuerdo, asi que yo estaba equivocado" | Al revisor le falta tu contexto: el desacuerdo es informacion, no veredicto. Re-lee el artefacto, clasifica y luego decide. |
| "Cross-model siempre es mejor" | Cross-model detecta puntos ciegos que un solo modelo comparte consigo mismo, pero agrega costo y fragilidad de herramientas. Ofrecelo en cada ciclo de duda interactivo: el usuario decide si el artefacto lo amerita. El trabajo del agente es sacar a la superficie la eleccion, no gatearla. |
| "El usuario dijo si una vez, asi que puedo seguir invocando el CLI" | Cada invocacion es su propia autorizacion. El artefacto, el prompt y los flags cambian entre llamadas: re-confirma el comando exacto con el usuario antes de cada ejecucion. |

## Senales de Alerta

- Generar un revisor con contexto fresco para un rename de una linea o un cambio de formateo
- Tratar el output del revisor como autoritativo sin re-leer el texto del artefacto
- Loopear >3 ciclos sin escalar al usuario
- Preguntarle al revisor "esto esta bien?" en lugar de "encontra problemas"
- Saltearse la duda bajo presion de tiempo en una decision de alto riesgo
- Re-generar contexto fresco sobre un artefacto sin cambios (vas a obtener los mismos hallazgos; estas dilatando)
- **Teatro de la duda (senal comprobable)**: a traves de 2 o mas ciclos donde el revisor saco a la superficie hallazgos sustanciales, cero hallazgos fueron clasificados como accionables. Estas validando, no dudando. Detente y escala.
- Dudar solo despues de commiteear: eso es `/review`, no desarrollo impulsado por la duda
- Hardcodear una invocacion de CLI externo sin confirmar con el usuario que la herramienta existe, esta configurada y acepta esa sintaxis exacta
- **Saltear silenciosamente el cross-model en un ciclo de duda interactivo.** Aun cuando no lo recomiendes, la oferta debe ser visible. Saltear esta bien; saltear silenciosamente no lo esta.
- Caer silenciosamente cuando un CLI externo falla o falta: saca a la superficie el fallo y deja que el usuario redirija
- Quitar el contrato de la entrada del revisor
- Pasarle el CLAIM al revisor (sesga hacia el acuerdo)

## Interaccion con Otras Skills

- **`code-review-and-quality` / `/review`**: complementarias. `/review` es un veredicto de PR post-hoc; doubt-driven es por-decision en vuelo. Usa ambas.
- **`source-driven-development`**: SDD verifica *hechos sobre frameworks* contra la documentacion oficial. Doubt-driven verifica *tu razonamiento sobre el artefacto*. SDD chequea que la API exista; doubt-driven chequea que la usaste correctamente bajo el contrato.
- **`test-driven-development`**: el paso RED de TDD es la duda hecha concreta: un test que falla es un intento de refutacion. Cuando TDD aplica, ese test que falla *es* el paso de la duda para las afirmaciones de comportamiento.
- **`debugging-and-error-recovery`**: cuando el revisor saca a la superficie un modo de falla real, entra a la skill de debugging para localizar y arreglar.
- **Reglas de orquestacion del repo** (`references/orchestration-patterns.md`): esta skill orquesta desde la sesion principal. Una persona que llama a otra persona es el anti-patron B: ver Restricciones de Carga arriba.

## Verificacion

Despues de aplicar el desarrollo impulsado por la duda:

- [ ] Cada decision no trivial (segun la definicion de arriba) fue nombrada explicitamente como un CLAIM antes de prevalecer
- [ ] Al menos una revision con contexto fresco por artefacto no trivial (un test que falla producido por el paso RED de TDD satisface esto para las afirmaciones de comportamiento, segun Interaccion con Otras Skills)
- [ ] El revisor recibio ARTIFACT + CONTRACT, NO el CLAIM, NO tu razonamiento
- [ ] El prompt del revisor fue adversarial ("encontra problemas"), no validatorio ("esta bien")
- [ ] Los hallazgos fueron clasificados contra el texto del artefacto (no sellados con goma) usando la precedencia: lectura erronea del contrato / accionable / trade-off / ruido
- [ ] Se cumplio una condicion de parada (hallazgos triviales, 3 ciclos o override del usuario)
- [ ] En modo interactivo, el cross-model fue **ofrecido explicitamente** al usuario (independientemente de lo que este en juego en el artefacto) y la respuesta fue reconocida en el output
- [ ] En modo no interactivo, el cross-model fue omitido y el salteo fue anunciado
- [ ] Cualquier invocacion de CLI externo fue precedida por un chequeo de PATH, una prueba del binario funcionando, confirmacion de sintaxis con el usuario y autorizacion explicita para ejecutar
