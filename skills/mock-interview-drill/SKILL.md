---
name: "mock-interview-drill"
metadata:
  category: "Career"
  tags:
    - entrevistas
    - preparacion
    - star
    - busqueda-laboral
description: "Simulacros realistas de entrevistas con follow-up questions: Behavioral (STAR), Technical y Case, con diagnóstico estructurado."
user-invocable: false
---

# Workflow: Mock Interview Drill

## Propósito

Simulacros realistas de entrevistas con follow-up questions en 3 modalidades: Behavioral, Technical y Case. Proporciona diagnóstico STAR estructurado, evaluación técnica y respuestas de muestra.

## Filosofía

> Practice doesn't make perfect. Practice makes permanent. Practice the right way.

Cada simulacro debe sentirse real. No es un cuestionario - es una conversación con presión controlada, seguimiento y diagnóstico.

## Cuándo usarlo

- Practicar entrevistas laborales
- Preparar behavioral questions con STAR
- Practicar system design o algoritmos
- Preparar case interviews (consulting, product)
- Obtener feedback estructurado post-simulacro

## Antes de empezar

Configurá el simulacro:

1. **Elegí el tipo** - Behavioral, Technical, Case, o combinado
2. **Definí el target** - FAANG, startup, consultora (cambia el enfoque)
3. **Definí seniority** - junior, mid, senior (cambia la profundidad)
4. **Tiempo** - 30-45 min por simulacro
5. **Modo** - conversación real, no lectura de guión

> **Tip:** Usá `question-generator.py` para generar preguntas automáticamente según rol, seniority y target.

---

## Workflow A: Behavioral Interview

### Cómo funciona

1. **Hacé la pregunta** - abierta, sin interrumpir
2. **Escuchá la respuesta** - tomá notas de los 4 elementos STAR
3. **Follow-ups** - 3-5 preguntas de profundización
4. **Diagnóstico** - rating A-D con criterios específicos

### Cómo evaluar una respuesta STAR

| Elemento | Qué buscar | Señales de alerta |
|---|---|---|
| **S** Situation | Contexto claro (cuándo, dónde, escala) | Vago, sin fechas, sin métricas |
| **T** Task | Rol personal definido | "El equipo hizo..." sin su rol |
| **A** Action | Acciones concretas, no genéricas | "Hice lo que había que hacer" |
| **R** Result | Outcome cuantificado o cualitativo | "Salió bien" sin datos |

### STAR Diagnostic Rating

| Rating | Criterio |
|---|---|
| **A** | Cubre 4/4 STAR, datos cuantificados, aprendizaje explícito |
| **B** | Cubre 3/4 STAR, datos parciales, algo de reflexión |
| **C** | Cubre 2/4 STAR, sin datos, respuesta genérica |
| **D** | Cubre 0-1/4 STAR, sin estructura, no responde la pregunta |

### Follow-ups comunes

- "¿Qué hubieras hecho diferente?"
- "¿Cómo reaccionaron los demás?"
- "¿Qué aprendiste de esa experiencia?"
- "¿Había algo que no sabías en ese momento?"
- "¿Cómo mediste el resultado?"

### Qué hacer si no tiene respuesta preparada

- Dále tiempo para pensar (10-15 segundos de silencio está bien)
- Reformulá la pregunta: "¿Otra situación similar?"
- Si insiste en que no tiene: "Contame de un proyecto que no salió como esperabas"

---

## Workflow B: Technical Interview

### Cómo funciona

1. **Presentá el problema** - system design, algoritmo, o domain knowledge
2. **Dále tiempo para pensar** - 2-3 min de silencio es normal
3. **Escuchá el approach** - no interrumpas, tomá notas
4. **Follow-ups** - edge cases, trade-offs, performance, extensibilidad
5. **Evaluación** - rating A-D con criterios técnicos

### System Design: qué evaluar según seniority

| Seniority | Qué esperar | Qué evaluar |
|---|---|---|
| **Junior** | Solución funcional, monolítica | Claridad, fundamentos, comunicación |
| **Mid** | Solución escalable, con trade-offs | Caching, DB indexing, API design |
| **Senior** | Solución distribuida, fault-tolerant | CAP theorem, sharding, consistency |

### Algoritmos: qué nivel según target

| Target | Nivel | Ejemplos |
|---|---|---|
| **FAANG** | LeetCode Medium/Hard | Graphs, DP, trees, arrays |
| **Startup** | LeetCode Easy/Medium | Arrays, strings, hash maps |
| **Consulting** | No aplica | No suelen preguntar algoritmos |

### Technical Answer Evaluation

| Rating | Criterio |
|---|---|
| **A** | Clarificó reqs, diseño completo, trade-offs explícitos, edge cases cubiertos |
| **B** | Diseño funcional, algunos trade-offs, edge cases parciales |
| **C** | Diseño básico, sin trade-offs, no consideró fallos |
| **D** | Sin estructura, no clarificó, solución incorrecta |

### Follow-ups comunes

- "¿Qué pasa si el tráfico se duplica?"
- "¿Cómo manejarías un fallo en [componente]?"
- "¿Hay otra forma de resolverlo?"
- "¿Cuál es el cuello de botella de tu diseño?"
- "¿Cómo monitorearías este sistema?"

---

## Workflow C: Case Interview

### Cómo funciona

1. **Presentá el case** - problema de negocio abierto
2. **Dále tiempo para estructurar** - 2-3 min
3. **Escuchá el approach** - framework, assumptions, análisis
4. **Follow-ups** - datos, riesgos, recomendación
5. **Evaluación** - rating A-D con criterios de case

### Frameworks por tipo de case

| Tipo de case | Framework recomendado |
|---|---|
| **Profitability** | Revenue - Cost = Profit |
| **Market Entry** | Market attractiveness + Company capability + GTM strategy |
| **M&A / Investment** | Strategic fit + Financial analysis + Risks |
| **Operations** | Process mapping + Cost analysis + Improvement levers |
| **Growth** | Customer funnel + Revenue levers + Competitive position |

> **Ver:** [Case Frameworks](./references/case-frameworks.md) para detalle de cada framework.

### Case Answer Evaluation

| Rating | Criterio |
|---|---|
| **A** | Framework apropiado, assumptions explícitas, análisis estructurado, recomendación clara |
| **B** | Framework ok, assumptions parciales, análisis básico, recomendación presente |
| **C** | Sin framework claro, salta a conclusiones, análisis superficial |
| **D** | Desorganizado, no estructura el problema, no llega a recomendación |

### Follow-ups comunes

- "¿Qué datos necesitarías para validar tu hipótesis?"
- "¿Cuál es el mayor riesgo de tu recomendación?"
- "¿Cómo priorizarías entre [opción A] y [opción B]?"
- "¿Qué assumptions estás haciendo?"
- "Si tuvieras que decidir hoy con la información disponible, ¿qué harías?"

---

## Outputs

- **STAR Diagnostic Report** - rating A-D con breakdown por elemento
- **Technical Answer Evaluation** - rating A-D con observaciones
- **Case Answer Evaluation** - rating A-D con feedback de estructura
- **Polished sample answers** - versión mejorada de la respuesta
- **Improvement suggestions** - qué practicar para la próxima

---

## References

- [Behavioral Questions](./references/behavioral-questions.md) - Banco de 24+ preguntas por categoría con criterios de evaluación
- [System Design Guide](./references/system-design-guide.md) - Cómo estructurar respuestas de system design, trade-offs, seniority levels
- [Case Frameworks](./references/case-frameworks.md) - Frameworks de case con cuándo usar cada uno
- [Preparation Guide](./references/preparation-guide.md) - Qué estudiar según target y seniority

## Scripts

- [question-generator.py](./scripts/question-generator.py) - Genera preguntas de práctica según rol, seniority y target

## Helper Scripts

Scripts en `skills/mock-interview-drill/scripts/`:

| Script | Uso |
|---|---|
| `question-generator.py` | Genera preguntas de entrevista según rol, seniority y target. Usar en "Antes de empezar" y entre simulacros para variar el banco de preguntas. |

## Related Skills

- [CV Tailor](../cv-tailor): Para optimizar CV antes de las entrevistas
- [Code Mentor](../code-mentor): Para practicar algoritmos y system design
