---
name: "narrative-content"
metadata:
  category: "Content"
  tags:
    - ficcion
    - escritura
    - narrativa
    - novelas
    - taller
description: "Tu taller de escritura de ficción: mentoría, técnicas, y guía para escribir novelas, cuentos, y cualquier historia."
user-invocable: false
---

# Workflow: Narrative Content - Tu Taller de Escritura

## Propósito

Este skill es tu compañero de escritura. No es un checklist - es un mentor que te guía según dónde estés en tu viaje de escritura. Te enseña técnicas, te ayuda a destrabarte, y te da estructura sin atarte.

## Filosofía

> Escribir es reescribir. Pero primero hay que escribir.

Acá no hay culpa, no hay "debería escribir más", no hay comparación. Hay un proyecto, un plan, y ganas de contar una historia. El resto se construye paso a paso.

---

## Menú de entrada

¿Qué querés hacer hoy?

| Opción | Para qué | Script recomendado |
|---|---|---|
| **📝 Arrancar una historia nueva** | Tenés una idea y querés convertirla en un plan | `outline-generator.sh` |
| **📐 Estructurar lo que ya tenés** | Tenés escenas sueltas o un borrador desordenado | `outline-generator.sh` |
| **✍️ Escribir el próximo capítulo** | Ya sabés qué sigue, necesitás sentarte a escribir | `progress-tracker.sh --add <palabras>` |
| **🔍 Revisar lo que escribiste** | Terminaste algo y querés mejorarlo | `revision-check.sh` |
| **📦 Exportar / publicar** | Querés pasar a DOCX, EPUB, o Markdown | `export-novel.py` |
| **🎯 Elegir un género** | No sabés qué género es el tuyo o querés explorar | - |
| **🧊 Estoy trabado** | Writer's block, pérdida de rumbo, "esto es una mierda" | - |
| **📚 Quiero aprender** | Querés mejorar tu oficio | - |

Elegí una opción y arrancamos.

## Helper Scripts

Scripts en `skills/narrative-content/scripts/`:

| Script | Uso |
|---|---|
| `outline-generator.sh` | Genera un outline estructurado a partir de una premisa. Usar en Fase 1-2. |
| `progress-tracker.sh [--log file] [--add words] [--status]` | Registra palabras escritas por día y muestra racha. Usar en cada sesión de escritura. |
| `revision-check.sh` | Verifica estructura de capítulos, arcos, consistencia. Usar en Fase 4. |
| `export-novel.py` | Exporta la novela a Markdown, DOCX o EPUB. Usar en Fase 6. |
| `character-sheet.sh` | Crea ficha de personaje. Usar en Fase 2-3. |


---

## Fase 1: Premisa - De idea a plan

**Cuándo:** Tenés una idea, una imagen, un personaje, o solo ganas de escribir algo.

### Lo que vamos a hacer

1. **Encontremos tu idea central** - ¿de qué trata realmente? No la trama, el corazón.
2. **Probemos que funcione** - ¿la idea sostiene una novela? ¿Un cuento? ¿Una saga?
3. **Definamos género y tono** - ¿qué tipo de historia es? ¿Qué va a sentir el lector?
4. **Escribamos la premisa en 1-2 oraciones** - si no podés resumirla, no está clara.

### Ejercicios de premisa

**"Qué pasaría si..."**
> ¿Qué pasaría si los muertos pudieran hablar, pero solo dijeran mentiras?
> ¿Qué pasaría si el último bibliotecario de la humanidad tuviera que quemar libros para sobrevivir?

**"Y entonces..."**
> Un detective encuentra una carta de su yo del futuro. Y entonces descubre que el asesino es él mismo.

**"Pero..."**
> Una mujer descubre que puede viajar en el tiempo. Pero cada viaje le cuesta un año de vida.

### Test de premisa

- [ ] **¿Tiene conflicto?** - sin conflicto no hay historia
- [ ] **¿Es específica?** - "un chico descubre que es especial" no es una premisa
- [ ] **¿Tiene un gancho?** - ¿por qué alguien querría leer esto?
- [ ] **¿Te apasiona?** - vas a pasar meses con esto. Tiene que importarte.

### Output de esta fase

- Premisa en 1-2 oraciones
- Género y tono definidos
- Decisión: ¿novela, cuento, o serie?

---

## Fase 2: Estructura - El esqueleto

**Cuándo:** Tenés la premisa. Ahora necesitás saber qué pasa y en qué orden.

### Lo que vamos a hacer

1. **Elegí una estructura** - Three-Act, Hero's Journey, Save the Cat!, Snowflake
2. **Pasá de estructura a scene list** - cada beat → una o más escenas
3. **Identificá weak scenes** - las que no tienen conflicto o no cambian nada
4. **Definí el arco del protagonista** - ¿cómo cambia de principio a fin?

### ¿Qué estructura elegir?

| Si tu historia es... | Usá |
|---|---|
| **Épica, fantasy, aventura** | Hero's Journey |
| **Thriller, misterio, ritmo rápido** | Three-Act |
| **Romance, comercial, mainstream** | Save the Cat! |
| **Compleja, múltiples POVs** | Snowflake Method |
| **No sabés** | Three-Act (es la más flexible) |

> **Ver:** [Narrative Structures](./references/narrative-structures.md) para detalle de cada una.

### De estructura a scene list

Tomá cada beat de la estructura y convertilo en 1-3 escenas:

```
Three-Act:
  Act I - Setup
    Inciting Incident → Escena 1: [descripción]
                       → Escena 2: [descripción]
    First Plot Point  → Escena 3: [descripción]
```

Cada escena debe tener:
- **POV** - ¿quién ve esta escena?
- **Objetivo** - ¿qué quiere el personaje?
- **Conflicto** - ¿qué se lo impide?
- **Cambio** - ¿cómo sale diferente?

### Output de esta fase

- Estructura elegida
- Scene list (escena por escena)
- Arco del protagonista definido

---

## Fase 3: Redacción - Escribir, no editar

**Cuándo:** Tenés el plan. Ahora hay que escribir.

### Lo que vamos a hacer

1. **Escribí sin editar** - el borrador es para descubrir la historia
2. **Usá técnicas de drafting** - vomit draft, pomodoro, word count goals
3. **Mantené el ritmo** - no pares a corregir, no mires atrás
4. **Trackeá progreso** - sin presión, solo datos

### Vomit Draft

Escribí sin parar, sin corregir, sin mirar atrás.

**Reglas:**
- Sin editar - ni siquiera typos
- Sin leer lo que escribiste ayer
- Sin juzgar - "esto es una mierda" es parte del proceso
- Sin parar - si no sabés qué sigue, escribí "no sé qué sigue" hasta que se te ocurra

**Meta:** 250-500 palabras por sesión. No importa si son malas. Las malas se arreglan después.

### Co-writing asistido

La IA puede ayudarte, pero **no escribas por vos**. Usala para:

- **Desbloquearte:** "Dame 3 formas en que este personaje podría salir de esta situación"
- **Explorar opciones:** "¿Qué pasaría si en vez de X, pasara Y?"
- **Feedback rápido:** "¿Este diálogo suena natural?"
- **Investigación:** "¿Cómo era la vestimenta en la Inglaterra victoriana?"

**No uses IA para:**
- Escribir párrafos completos por vos (se nota y no es tuyo)
- Reemplazar tu voz narrativa
- Decidir la trama (las mejores decisiones son tuyas)

### Output de esta fase

- Capítulos escritos (borrador)
- Writing log con progreso

### Registro automático

Cada 1-2 capítulos (o al final de cada sesión), ejecutar el protocolo de registro:

1. **Persistir en el archivo principal** del proyecto (`projects/<slug>/<slug>.md`):
   - Agregar el nuevo contenido al final de la sección correspondiente
   - Mantener la estructura de numeración de capítulos

2. **Actualizar STATUS.md** en `.knowledge/STATUS.md`:
   - Registrar qué se escribió (capítulos, personajes nuevos, giros)
   - Mantener un resumen actualizado del estado del proyecto

3. **Commit al repo del proyecto:**
   ```bash
   cd projects/<slug> && git add -A && git commit -m "feat: <resumen de lo escrito>"
   ```

4. **Commit al workspace** (incluyendo mirror de skills):
   ```bash
   cd <workspace> && rsync -a --delete --exclude='.DS_Store' skills/ .github/skills/ && git add -A && git commit -m "feat(<slug>): <resumen>" && git pull --rebase && git push
   ```

**Excepciones:**
- Si el capítulo es muy corto (< 10 líneas), se puede esperar al siguiente
- Si se está en medio de una escena que no se puede interrumpir, terminar la escena primero
- No esperar más de 2 capítulos sin registrar
- Si la sesión se va a cerrar, registrar todo antes del cierre

---

## Fase 4: Revisión - De borrador a historia

**Cuándo:** Terminaste el borrador. Ahora empezá de nuevo, pero mejor.

### Los 3 niveles de revisión

Siempre en este orden:

```
1. Revisión Estructural   → ¿La historia funciona?
2. Revisión de Línea      → ¿Cada escena funciona?
3. Revisión de Copy       → ¿Cada palabra funciona?
```

### Nivel 1: Estructural

- Leé la historia completa de una sentada
- ¿El arco del protagonista funciona?
- ¿Cada escena es necesaria?
- ¿Hay plot holes?
- **No corrijas comas todavía**

### Nivel 2: Línea

- ¿Cada escena tiene conflicto?
- ¿El diálogo suena natural?
- ¿El ritmo es correcto?
- ¿Cada personaje tiene una voz distinta?

### Nivel 3: Copy

- Palabras repetidas
- Adverbios innecesarios
- Voz pasiva
- Puntuación y ortografía

> **Ver:** [Revision Guide](./references/revision-guide.md) para el detalle completo.

### Output de esta fase

- Historia revisada (estructural, línea, copy)
- Revision log con issues encontrados y resueltos

---

## Fase 5: Exportación - A publicar

**Cuándo:** La historia está lista. Querés pasarla a formato publicable.

### Formatos disponibles

| Formato | Para qué | Cómo |
|---|---|---|
| **Markdown** | Web, GitHub, edición colaborativa | `export-novel.py --format md` |
| **DOCX** | Word, Google Docs, impresión | `export-novel.py --format docx` |
| **EPUB** | eBook, Kindle, lectores | `export-novel.py --format epub` |

### Output de esta fase

- Archivo exportado en el formato elegido
- Listo para compartir, publicar, o imprimir

---

## 🧊 Estoy trabado - Writer's Block Rescue

El writer's block no es falta de inspiración - es miedo a escribir mal.

### Diagnosticá el bloqueo

| Síntoma | Probable causa |
|---|---|
| "No sé qué escribir" | No tenés claro qué sigue en la historia |
| "Todo lo que escribo es malo" | Estás juzgando antes de tiempo |
| "No tengo ganas" | Fatiga, saturación, necesitás un descanso |
| "Perdí el rumbo" | La historia se fue a algún lado que no planeaste |
| "Esto ya no me interesa" | Tal vez el proyecto no es para vos (y está bien) |

### Técnicas de rescue

1. **Escribí 100 palabras de mierda** - a propósito. "Esto es una mierda y lo sé." Después de 100 palabras, el bloque suele romperse.
2. **Cambiá de escena** - escribí la escena que más ganas tenés de escribir, aunque sea del final.
3. **Escribí out of order** - no necesitás escribir en orden cronológico.
4. **Cambiá de medio** - escribí a mano, en una app distinta, en una servilleta.
5. **Hablá la escena** - grabate contándola como si se la contaras a un amigo.
6. **Saltá el bloque** - escribí "ACÁ HAY UN BLOQUEO" y seguí con la siguiente escena.

---

## 📚 Quiero aprender - Recursos

### References del skill

| Reference | Para qué |
|---|---|
| [Genre Guide](./references/genre-guide.md) | 8 géneros con estructura, trampas, referentes |
| [Narrative Structures](./references/narrative-structures.md) | 4 estructuras narrativas detalladas |
| [Scene Craft](./references/scene-craft.md) | Anatomía de una escena, template, checklist |
| [Dialogue](./references/dialogue.md) | Cómo escribir diálogo que suene real |
| [Character Development](./references/character-development.md) | Fichas de personajes, arquetipos, motivación |
| [Worldbuilding](./references/worldbuilding.md) | Construcción de mundos, consistencia, show don't tell |
| [Revision Guide](./references/revision-guide.md) | 3 niveles de revisión con checklist |
| [Writing Routines](./references/writing-routines.md) | Rutinas ADHD-friendly, word count goals, tracking |

### Lectura recomendada

**Sobre el oficio:**
- *On Writing* - Stephen King (parte memoir, parte manual)
- *Bird by Bird* - Anne Lamott (escritura y vida)
- *The Anatomy of Story* - John Truby (estructura narrativa)
- *Steering the Craft* - Ursula K. Le Guin (el oficio de escribir)

**Sobre géneros específicos:**
- *The Fantasy Fiction Formula* - Deborah Chester
- *Writing the Thriller* - T. Macdonald Skillman
- *Romance Writing* - various (workshop-based)

---

## Scripts

| Script | Para qué |
|---|---|
| [outline-generator.sh](./scripts/outline-generator.sh) | Genera outline desde una premisa |
| [character-sheet.sh](./scripts/character-sheet.sh) | Crea fichas de personaje |
| [export-novel.py](./scripts/export-novel.py) | Exporta a DOCX, EPUB, MD |
| [revision-check.sh](./scripts/revision-check.sh) | Verifica consistencia narrativa |
| [progress-tracker.sh](./scripts/progress-tracker.sh) | Tracking de word count y rachas |

## Related Skills

- [Copy Editing](../copy-editing): Para la revisión final de texto
- [Timeline Builder](../timeline-builder): Para timelines visuales de historias complejas
