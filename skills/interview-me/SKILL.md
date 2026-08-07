---
name: interview-me
description: Extrae lo que el usuario realmente quiere en lugar de lo que cree que debería querer. Lo logra mediante una entrevista de una pregunta a la vez hasta alcanzar ~95% de confianza sobre la intención subyacente. Úsalo cuando una petición está poco especificada ("hazme X" sin "para quién" ni "por qué ahora"), cuando el usuario lo invoca explícitamente ("entrevístame", "interrógame", "¿estamos seguros?", "pon a prueba mi pensamiento"), o cuando te sorprendas rellenando en silencio requisitos ambiguos antes de que exista cualquier plan, especificación o código.
---

# Entrevístame

## Visión General

Lo que la gente pide y lo que realmente quiere son cosas distintas. Piden "un dashboard" porque es lo que se pide, no porque un dashboard resuelva su problema. Dicen "hazlo más rápido" sin una cifra que alcanzar.

El momento más barato para detectar esta brecha es antes de que exista cualquier plan, especificación o código. Una vez que empiezas a construir, los costes de cambio son reales, y el usuario racionalizará lo equivocado hasta convertirlo en algo "suficientemente bueno". El desajuste queda fijado.

Esta skill cierra la brecha antes de que cueste algo. Las otras skills de la fase Define asumen que ya sabes más o menos lo que quieres: `idea-refine` genera variaciones a partir de una idea, `spec-driven-development` escribe los requisitos, `doubt-driven-development` pone a prueba un plan después de haberlo redactado. Interview-me es la parte anterior a todas esas, donde preguntas una cosa a la vez, con tu mejor suposición adjunta, hasta poder predecir lo que el usuario va a decir antes de que lo diga.

## Cuándo Usarla

Aplica esta skill cuando:

- A la petición le falta al menos uno de: **quién** es el usuario, **por qué** lo quiere, qué aspecto tiene el **éxito**, cuál es la **restricción** vinculante
- La solicitud es convencional en lugar de específica ("hazme X", "hazlo más rápido") y no puedes desentrañar la convención sin adivinar
- Estás tentado a empezar con suposiciones que no has sacado a la luz
- El usuario no ha dicho qué valor optimiza cuando dos razonables están en tensión (simplicidad vs. flexibilidad, coste vs. velocidad)
- El usuario lo invoca explícitamente: "entrevístame", "interrógame", "antes de empezar, ¿estamos seguros?", "pon a prueba mi pensamiento"

**Cuándo NO usarla:**

- La petición es inequívoca y autocontenida ("renombra esta variable", "corrige esta errata")
- El usuario ha pedido explícitamente velocidad por encima de verificación
- Solicitudes puramente informativas ("¿cómo funciona X?", "¿qué hace este código?")
- Operaciones mecánicas (renombrados, formatos, movimientos de archivos)
- Ya tienes ≥95% de confianza; vuelve a leer la condición de parada abajo antes de asumir que no la tienes

## Restricciones de Carga

Esta skill necesita un usuario vivo y receptivo. **No la invoques en contextos no interactivos** como pipelines de CI, ejecuciones programadas, `/loop` o bucles autónomos. Si estás en uno de esos y la petición está poco especificada, márcalo como un bloqueo para el usuario en lugar de adivinar.

## El Proceso

### Paso 1: Formula una hipótesis, con un número de confianza

Antes de preguntar nada, escribe tu mejor lectura actual de lo que quiere el usuario en **una frase**, más un número de confianza honesto (0-100%):

```
HIPÓTESIS: Quieres una forma de responder "¿cómo vamos?" en el standup, y "dashboard" fue la convención que te vino a la mente.
CONFIANZA: ~30% - falta: para quién es, qué significa "métricas" en contexto, y qué aspecto tiene el éxito
```

El número fuerza la honestidad. Si escribiste un número alto pero en realidad no puedes predecir las reacciones del usuario a las siguientes tres preguntas que harías, el número está mal. Empieza en el nivel de confianza que puedas defender.

Cuando la confianza esté por debajo de ~70%, añade una breve razón en la misma línea: qué sigue sin resolver o falta. Esto le dice al usuario exactamente lo que la entrevista necesita sacar a la luz, y evita que el número sea una señal vaga.

### Paso 2: Pregunta una cosa a la vez, cada una con una suposición adjunta

Formato:

```
P: <una pregunta enfocada>
SUPOSICIÓN: <tu hipótesis para la respuesta, con el razonamiento que la produjo>
```

Espera a que el usuario reaccione antes de hacer la siguiente pregunta.

**Por qué una a la vez, no un lote:**

- El usuario no puede reaccionar a tus hipótesis si las entierras en una lista
- Los lotes fomentan la lectura por encima y las respuestas superficiales
- La tercera pregunta a menudo depende de la respuesta a la primera; hacerlas todas a la vez fija el marco equivocado
- La energía del usuario para pensar con cuidado es finita; gástala una pregunta a la vez

**Por qué adjuntar una suposición:**

- El usuario reacciona más rápido a una suposición equivocada que generando una respuesta desde cero
- Te compromete con una hipótesis sobre la que puedes estar visiblemente equivocado, lo que te mantiene honesto
- Saca a la luz *tus* suposiciones, que es lo que la entrevista pretende exponer

El riesgo aquí es un usuario amable que esté de acuerdo con tu suposición por agradar. Mitígalo estando visiblemente dispuesto a equivocarte, y adivinando ocasionalmente en una dirección que esperas que el usuario rechace.

### Paso 3: Escucha "lo que quiere" vs. "lo que debería querer"

Las respuestas más peligrosas son aquellas donde el usuario dice cómo *suena* una respuesta reflexiva en lugar de lo que realmente quiere. Presta atención a:

- Respuestas que replican el discurso de las mejores prácticas ("quiero que sea escalable", "arquitectura limpia") sin detalles
- Respuestas que se pliegan a la convención ("como lo hacen la mayoría de las apps", "el enfoque estándar")
- Frases como "probablemente debería…", "creo que se supone que…", "las buenas prácticas de ingeniería dicen…"
- Palabras de moda como objetivos: cuando "moderno", "escalable", "robusto" son la respuesta en lugar de un resultado específico

Cuando oigas estas cosas, la pregunta a hacer es:

> *"Si no tuvieras que justificarlo ante nadie, ¿qué querrías realmente?"*

Esa única pregunta a menudo hace más trabajo que las cinco anteriores.

### Paso 4: Reformula la intención con las propias palabras del usuario

Cuando tu confianza sea alta, escribe lo que ahora crees que el usuario quiere. Mantenlo conciso (5-8 líneas), usa su lenguaje cuando sea posible, y estructúralo para que el usuario pueda confirmar o corregir línea por línea:

```
Esto es lo que ahora creo que quieres:

- Resultado:       <una línea>
- Usuario:         <una línea - quién se beneficia>
- Por qué ahora:   <una línea - qué cambió>
- Éxito:           <una línea - cómo sabemos que funcionó>
- Restricción:     <una línea - el límite vinculante>
- Fuera de alcance:<una línea - lo que explícitamente no hacemos>

¿Sí / no / refina?
```

Incluir "Fuera de alcance" no es negociable. La mitad de la desalineación es un desacuerdo silencioso sobre lo que *no* se está construyendo.

### Paso 5: Confirma: un "sí" explícito, no un "lo que tú creas"

La puerta es un "sí" explícito. Lo siguiente **no** es un "sí":

- "Lo que tú creas que es mejor." → El usuario está delegando, lo que significa que tampoco tiene un 95% de confianza. Vuelve a preguntar con dos opciones concretas planteadas como elección.
- "Suena bien." → Ambiguo. Pregunta: "¿Refinarías algo?" El silencio no es confirmación.
- "Claro, vamos." → A menudo una salida cortés, no un respaldo. Mismo seguimiento.
- Silencio seguido de "vale, empecemos". → El usuario ha renunciado a la entrevista, no ha convergido. Detente y pregunta si te has perdido algo.

Si te corrigen, incorpora la corrección y reformula. Repite hasta obtener un "sí" explícito.

### La Parada del 95% de Confianza

Has terminado cuando puedes responder "sí" a esto:

> *¿Puedo predecir la reacción del usuario a las siguientes tres preguntas que haría?*

Si es sí, tienes un entendimiento compartido. Deja de entrevistar y produce la reformulación. Si es no, no has terminado; haz la siguiente pregunta.

Esta es una prueba comprobable, no una sensación. También tiene un suelo: si has hecho varias rondas y todavía no puedes predecir, eso es información sobre la petición, no una razón para seguir machacando. Detente y dile al usuario: "He hecho X preguntas y todavía no puedo predecir tus reacciones. Algo fundamental falta. ¿Quieres dar un paso atrás?"

## Salida

El resultado de esta skill es una **declaración de intención confirmada**: la reformulación del Paso 4, con un "sí" explícito del Paso 5. Ese es el entregable. Las especificaciones, planes y listas de tareas van después; consumen la intención que esta skill produce.

Si el usuario quiere que la intención persista (un proyecto de varias sesiones, una transferencia a otro colaborador), ofrécete a guardarla en `docs/intent/[tema].md`. Solo guárdala si confirma.

## Ejemplo

Un antes y un después corto.

**Sin `interview-me`:**

```
Usuario:  hazme un dashboard para nuestras métricas
Agente: <empieza a proponer librerías de gráficos y layouts>
```

El agente ha asumido: para quién es, qué métricas, qué significa "para nuestro equipo", qué aspecto tiene el éxito. Nada de esto está declarado. Cada suposición es un lugar donde el usuario puede decir más tarde "no es eso lo que quería decir".

**Con `interview-me`:**

```
Usuario: hazme un dashboard para nuestras métricas

Agente:
HIPÓTESIS: Quieres una forma de responder "¿cómo vamos?" en el standup, y "dashboard" te vino a la mente porque es la respuesta convencional.
CONFIANZA: ~30% - falta: para quién es, qué son las "métricas", y qué aspecto tiene el éxito

P:     Cuando dices "¿cómo vamos?", ¿quién pregunta: tú solo, el equipo de ingeniería en el standup, o hacia arriba en la cadena (p. ej., tu manager, un ejecutivo, un consejo)?
SUPOSICIÓN: el equipo de ingeniería en el standup, porque "nosotros" normalmente se enmarca así y los standups son donde se hace esta pregunta. Si es para ejecutivos, las métricas y el marco cambian mucho.

Usuario: En realidad es para mí. Pierdo el rastro de qué experimentos están corriendo y qué aspecto tiene su señal temprana.

Agente:
Lectura actualizada: no es un dashboard de equipo en absoluto. Es un rastreador personal de experimentos. Confianza: ~60% - todavía falta: qué significa "señal temprana" y qué aspecto tiene "terminado".

P:     ¿La brecha es que no sabes qué experimentos existen, o que no puedes ver sus resultados en un solo lugar?
SUPOSICIÓN: la segunda. Tienes una lista de experimentos en algún sitio, pero sus resultados viven en cinco herramientas distintas, y reconciliarlos a mano es lo que te tiene harto.

Usuario: La primera en realidad. Literalmente no tengo una lista. Están repartidos entre distintos documentos.

Agente: <continúa>
```

A dos preguntas, el agente ha descubierto que la petición real no es "un dashboard". Es "una lista". Artefacto distinto, alcance distinto, trabajo distinto. El dashboard habría estado mal.

## Interacción con Otras Skills

- **`idea-refine`**: downstream. Si la intención confirmada es "quiero X pero no sé cómo acotarla", pasa a `idea-refine` para generar variaciones contra la intención ahora explícita.
- **`spec-driven-development`**: downstream. Si la intención confirmada es concreta ("quiero X para usuarios Y con criterios de éxito Z"), pasa a `spec-driven-development` para que la escriba.
- **`planning-and-task-breakdown`**: dos saltos downstream de esta skill (después de la especificación).
- **`doubt-driven-development`**: el extremo opuesto de la línea de tiempo. Interview-me es la extracción de intención previa a la decisión; doubt-driven es la revisión de artefactos posterior a la decisión. Ambas detectan divergencias, pero en momentos distintos.
- **`source-driven-development`**: ortogonal. Interview-me aclara lo que el usuario quiere; SDD verifica hechos del framework. No compiten.

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "La petición es lo bastante clara" | Si no puedes escribir el resultado deseado del usuario en una frase ahora mismo, la petición no es clara. Ejecuta el Paso 1 antes de decidir. |
| "Hacer demasiadas preguntas desperdicia su tiempo" | El tiempo desperdiciado por 4-6 preguntas dirigidas es pequeño. El tiempo desperdiciado construyendo la cosa equivocada es enorme, y el usuario es quien soporta ese coste. |
| "Lo resolveré sobre la marcha mientras construyo" | Los costes de cambio después de que el código exista son 10 veces mayores que ahora. El descubrimiento durante la implementación es retrabajo. |
| "Dijo 'lo que tú creas', así que debería decidir yo" | "Lo que tú creas" es delegación, no una decisión. Vuelve a preguntar con dos opciones concretas como elección. |
| "Debería darle varias opciones para elegir" | Las opciones funcionan cuando el usuario sabe lo que quiere y elige entre compensaciones. Todavía no sabe lo que quiere. Enumerar opciones amplía la búsqueda; preguntar la estrecha. |
| "Si adjunto mi suposición, lo estoy condicionando" | Condicionar es el punto. Reaccionar es más rápido que generar desde cero. El riesgo es el servilismo, no el condicionamiento; mitígalo estando visiblemente dispuesto a equivocarte. |
| "Ya hemos hablado bastante, lo entiendo" | Ponlo a prueba: ¿puedes predecir su reacción a las siguientes tres preguntas? Si no, todavía no lo entiendes. |
| "El usuario dijo que sí, hemos terminado" | Si el "sí" siguió a una reformulación vaga o a un "suena bien" abierto, el "sí" es vacío. Reformula de forma concreta y vuelve a confirmar. |

## Señales de Alerta

- Tres o más preguntas en un solo mensaje: eso es un lote, no una entrevista
- Una pregunta sin tu hipótesis adjunta: eso es una encuesta, no un compromiso
- Aceptar "lo que tú creas que es mejor" como respuesta terminal
- Producir una especificación, plan o lista de tareas antes de que el usuario haya confirmado explícitamente tu reformulación
- Preguntas planteadas como "¿cuál sería la mejor práctica?" en lugar de "¿qué quieres realmente?"
- El usuario da una respuesta que señala sofisticación ("escalable", "limpio", "moderno") y la aceptas sin indagar si es lo que realmente quiere
- Tres o más rondas sin que tu confianza suba visiblemente: estás haciendo las preguntas equivocadas, da un paso atrás y reformula
- Un número de confianza por debajo de ~70% sin razón adjunta: el usuario no puede ayudar a cerrar la brecha si no sabe qué falta
- Guardar el documento de intención antes de que el usuario haya confirmado (el documento en sí implica un "sí" que el usuario no dio)
- Saltarte la línea de "Fuera de alcance" en la reformulación (el desacuerdo silencioso sobre los no-objetivos es la mitad de la desalineación)

## Verificación

Después de aplicar interview-me:

- [ ] Se declaró una hipótesis explícita con un número de confianza en el primer turno
- [ ] Todo número de confianza por debajo de ~70% fue acompañado de una razón de una línea (qué sigue sin resolver o falta)
- [ ] Las preguntas se hicieron una a la vez, cada una con la suposición del agente adjunta
- [ ] Al menos una sonda de "¿qué querrías realmente si no tuvieras que justificarlo?" se ejecutó cuando el usuario dio una respuesta que señalaba sofisticación o convención
- [ ] Se escribió de vuelta al usuario una reformulación concreta (Resultado / Usuario / Por qué ahora / Éxito / Restricción / Fuera de alcance)
- [ ] El usuario confirmó la reformulación con un "sí" explícito (no "lo que tú creas", no "suena bien", no silencio)
- [ ] En el punto de parada, el agente podía predecir las reacciones a las siguientes tres preguntas que haría
- [ ] Cualquier transferencia a una skill downstream (`idea-refine`, `spec-driven-development`) se enmarcó en términos de la intención confirmada, no de la petición original poco especificada
