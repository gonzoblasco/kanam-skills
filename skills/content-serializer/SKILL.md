---
name: "content-serializer"
description: "Convert content (courses, blog posts, docs) into weekly multi-platform social posts for LinkedIn and X."
metadata:
  category: Content
  tags:
    - contenido
    - linkedin
    - twitter
    - x
    - serie
    - posts
    - tutorial
user-invocable: false
---

# Workflow: Content Serializer — Contenido técnico a serie semanal

## Propósito

Convertir contenido técnico que ya existe (un curso, un blog, documentación) en una **serie de posts semanales** para **LinkedIn** y **X**, con formato adaptado por plataforma, calendario de publicación y métricas de ajuste.

No es para generar contenido de cero — es para **serializar material que ya tenés** (el bootcamp, un tutorial, tus docs) en presencia pública consistente.

## Cuándo usarlo

- Tenés un curso/tutorial/bootcamp terminado y querés publicarlo como serie
- Querés convertir documentación o notas en posts semanales
- Querés posicionarte publicando contenido técnico de forma sostenida

## Filosofía

> Publicar no es "subir contenido" — es una conversación semanal con tu audiencia.

El objetivo no es "postear por postear": es construir una serie con **arco**, donde cada post se apoya en el anterior y engancha al siguiente. La consistencia semanal gana sobre el post viral aislado.

---

## Fase 0: Tono de marca personal

**Cuándo:** Siempre. Antes de escribir cualquier post, tenés que saber **quién habla**. Es tu voz, no la de un ghostwriter genérico.

### Tu voz (Gonzo)

- **Directa y honesta, sin vueltas.** Decís lo que pensás. No adornás para sonar más "profesional" — la honestidad ES tu profesionalismo.
- **Suena a persona, no a manual de programación.** Nada de jerga corporativa ni tono de documentación técnica. Escribís como hablás.
- **Primera persona real.** "Construí", "encontré un bug", "me costó". No "se construye", no "uno encuentra".
- **Suelto y natural.** Frases cortas. Sin relleno. Que se lea como un dev contando algo, no como un comunicado.
- **Con opinión.** Tenés criterio y lo mostrás. Preferís cosas, encontrás cosas aburridas, disentís. Eso te hace humano y te diferencia.
- **Documentás decisiones, no solo código.** Contás el "porqué", no solo el "qué hice". Eso es lo que te posiciona como senior.

### Regla de oro del tono

> **La voz es la base, pero NO es rígida — se adapta a la ocasión.**

El tono de marca personal no es una camisa de fuerza. Se modula según el tipo de post:

| Ocasión | Cómo suena tu voz |
|---------|-------------------|
| **Deep-dive técnico** (cómo resolviste X) | Directo, concreto, con evidencia. La honestidad sobre el bug que encontraste vale oro. |
| **Anuncio / lanzamiento** (el bootcamp, un release) | Entusiasmo medido, sin hype falso. "Armé esto" en vez de "¡Mira este INCREÍBLE proyecto!". |
| **Thought-leadership / opinión** (una lección, una postura) | Provocador pero sin clickbait barato. Afirmación + evidencia + por qué importa. |
| **Pedido / CTA** (¿te sirve?, seguí la serie) | Directo y genuino. Una sola pregunta clara, sin suplicar. |

**Reglas duras del tono (no negociables):**
- **Nunca guión largo (—).** Usá siempre guión común (-). El guión largo no está en el teclado y delata que no es un dev escribiendo. (USER.md)
- **Nada de "Great question!" ni "I'd be happy to help!".** Esa calidez falsa de chatbot te hace sonar a bot.
- **Nada de "en este post voy a enseñarte...".** Contalo, no lo anuncies.
- **No te des la razón solo por ser vos.** Si algo falló, decilo. La vulnerabilidad técnica (encontré un bug, me equivoqué) es tu mayor activo de credibilidad.

### Check de tono antes de publicar

Releé el post y preguntate:
- [ ] ¿Suena a Gonzo, o a un manual de programación?
- [ ] ¿Hay algún guión largo (—) que deba ser guión común (-)?
- [ ] ¿Está la lección/opinión, o solo el "qué hice"?
- [ ] ¿Está adaptado a la ocasión (deep-dive vs anuncio vs opinión), o es todo igual?

---

## Fase 1: Inventario del contenido fuente

**Cuándo:** Tenés el material. Antes de escribir un solo post, sabé qué tenés.

1. **Listá las unidades** de tu contenido. Para un curso: los niveles/módulos/capítulos. Para un blog: los artículos. Para docs: las secciones grandes.

2. **Para cada unidad, extraé** (anotá en una tabla):
   - **Tema** — de qué trata
   - **Un insight / lección** — el "porqué" que vale la pena compartir
   - **Una pieza de evidencia** — un ejemplo, un resultado, un bug encontrado
   - **Un gancho posible** — por qué alguien lo leería

3. **Marcá el arco narrativo** — las unidades no son independientes: forman una progresión (en el bootcamp: de generar código a probar sistemas completos). Ese arco es tu serie.

> 💡 El insight no es "qué hace el nivel" — es *la lección que aprendiste*. En el bootcamp: "un validador que nunca viste fallar no te protege de nada". Eso es lo que se comparte, no el detalle técnico.

---

## Fase 2: Adaptación por plataforma

**Cuándo:** Tenés el inventario. Cada unidad se convierte en 1+ posts, con formato distinto por plataforma.

### LinkedIn — storytelling + valor

- **Largo:** 150-300 palabras. Post + línea de cierre.
- **Estructura:**
  1. **Hook** (1 línea) — la lección/insight, en primera persona o como afirmación provocadora
  2. **Setup** (2-3 líneas) — contexto: qué estaba construyendo
  3. **Desarrollo** (3-6 líneas) — el "cómo", con la evidencia concreta
  4. **Lección** (2-3 líneas) — el aprendizaje universal, aplicable fuera del contexto
  5. **CTA / cierre** (1 línea) — pregunta, invitación, o "próximo nivel"
- **Tono:** tu voz de marca personal (Fase 0), modulada por la ocasión.
- **Hashtags:** 3-5 al final, relevantes al tema (#AIEngineering, #NodeJS, etc.)

### X — conciso + hilo

- **Post individual:** máx 280 caracteres. Un solo insight, cortante.
- **Hilo:** 4-8 posts. Gancho en el primero, detalle técnico en los del medio, lección + CTA en el último.
- **Estructura de hilo:**
  1. **Post 1 (gancho):** la afirmación que genera curiosidad ("Construí un sistema de microservicios con IA. El bug más caro no estaba en el código - estaba en el validador.")
  2. **Posts 2-5 (desarrollo):** pasos, evidencia, datos. Cada post auto-contenido pero con continuidad.
  3. **Post final (lección + CTA):** el insight + pregunta o invitación a seguir la serie.
- **Regla:** cada post del hilo debe tener sentido por sí solo (la gente lo lee suelto al hacer scroll).
- **Sin hashtags spam:** máx 1-2, o ninguno.

### Tabla de adaptación (resumen)

| Dimensión | LinkedIn | X |
|-----------|----------|---|
| Formato | Post 150-300 palabras | Hilo 4-8 posts |
| Tono | Storytelling + valor | Cortante, directo |
| Hook | Primera persona, provocador | Curiosidad, afirmación |
| Hashtags | 3-5 al final | 0-2 |
| CTA | Pregunta o invitación | Pregunta o "seguí la serie" |

---

## Fase 3: Calendario semanal

**Cuándo:** Tenés los posts adaptados. Organizá la publicación.

1. **Definí el ritmo.** Default: **1 unidad de contenido por semana** (1 post LinkedIn + 1 hilo X por unidad). Ajustable.

2. **Asigná fechas** en orden del arco narrativo. El bootcamp: semana 1 = nivel 1, semana 2 = nivel 2, etc.

3. **Creá el calendario** como tabla:
   ```
   | Semana | Unidad | Tema | LinkedIn | X (hilo) | Posteado |
   |--------|--------|------|----------|----------|----------|
   | 1 | Nivel 1 | Hello World | ✅ | ✅ | — |
   | 2 | Nivel 2 | Prompts | ✅ | ✅ | — |
   ```

4. **Bach de preparación:** escribí 2-3 semanas de posts por adelantado (buffer). Así la semana de publicación solo es "revisar y subir", no escribir bajo presión.

> 💡 El buffer semanal es lo que hace sostenible la serie. Publicar es el hábito; escribir con anticipación es lo que lo permite.

---

## Fase 4: Publicación + métricas

**Cuándo:** Empezás a publicar. La serie se ajusta con datos, no con opiniones.

### Antes de publicar cada post
- **Releé en voz alta** — si no fluye, no va.
- **Check de tono (Fase 0)** — ¿suena a Gonzo y está adaptado a la ocasión?
- **Check de insight** — ¿está la lección, o solo el "qué hice"?

### Métricas a trackear (por semana)
- **LinkedIn:** impresiones, reacciones, comentarios. El comentario vale más que el like.
- **X:** impresiones, likes, replies, retweets. El reply es la señal de conversación.

### Reglas de ajuste (semana a semana)
- **Si un formato funciona** (muchos comentarios en LinkedIn, muchos replies en X) → repetilo la próxima semana.
- **Si un post muere** → no es necesariamente mal contenido; puede ser el gancho. Cambiá el hook y reusá el cuerpo.
- **Si la audiencia pide más de X tema** → adelantalo en el arco, atrasá el resto.

---

## Outputs

- Inventario de unidades (tema, insight, evidencia, gancho)
- Posts LinkedIn (150-300 palabras c/u) + hilos X (4-8 posts c/u)
- Calendario semanal con buffer de 2-3 semanas
- Log de métricas + decisiones de ajuste

## Related Skills

- [Copy Editing](../copy-editing): Revisión final de cada post antes de publicar
- [Campaign Plan](../campaign-plan): Si además querés un brief de campaña completo (audiencia, canales, KPI)
- [Narrative Content](../narrative-content): Si el contenido es ficción/narrativa (no técnico)
