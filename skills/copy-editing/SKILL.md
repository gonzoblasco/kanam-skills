---
name: "copy-editing"
metadata:
  category: "Content"
  tags:
    - copy
    - edicion
    - marketing
    - escritura
description: "Edición profesional de copy de marketing: 7 sweeps de claridad, tono, beneficio, prueba, especificidad, emoción y riesgo."
user-invocable: false
---

# Workflow: Copy Editing

## Propósito

Mejorar copy de marketing existente mediante 7 pasadas secuenciales de edición, cada una enfocada en una dimensión. No reescribe desde cero - realza el mensaje original.

## Filosofía

> Good copy editing isn't about rewriting. It's about enhancing.

Cada pasada se enfoca en una dimensión. Cada edición tiene una razón clara. Se preserva la voz del autor mientras se mejora claridad y conversión.

---

# Cuándo usarlo

- Editar copy de landing pages, emails, ads
- Revisar marketing copy antes de publicar
- Pulir mensajes de producto
- Mejorar conversión de copy existente
- Hacer copy sweep antes de un lanzamiento

---

# Fases: The Seven Sweeps

## Sweep 1: Clarity

¿El lector entiende lo que decís?

- Estructuras de oraciones confusas
- Jerga o insider language
- Afirmaciones ambiguas
- Una idea por oración

## Sweep 2: Voice and Tone

¿El copy suena consistente?

- Shifts entre formal y casual
- Personalidad de marca inconsistente
- Lectura en voz alta para detectar

## Sweep 3: So What

¿Cada afirmación responde "¿y qué?"

- Features sin benefits
- Afirmaciones sin consecuencias
- Test: para cada claim, preguntar "so what?"

## Sweep 4: Prove It

¿Cada claim tiene evidencia?

- Testimonios con nombres
- Estadísticas y datos
- Validación de terceros
- Garantías y risk reversals

## Sweep 5: Specificity

¿El copy es concreto?

| Vago | Específico |
|---|---|
| Save time | Save 4 hours every week |
| Many customers | 2,847 teams |
| Fast results | Results in 14 days |

## Sweep 6: Heightened Emotion

¿El copy hace sentir algo?

- Pain points que se sienten, no solo se mencionan
- Lenguaje sensorial
- Micro-historias

## Sweep 7: Zero Risk

¿Eliminamos todas las barreras a la acción?

- Fricción cerca del CTA
- Objeciones sin responder
- Trust signals faltantes

---

# Outputs

- Copy editado con cambios marcados
- Reporte por sweep con issues encontrados
- Versión final pulida

## Helper Scripts

Scripts en `skills/copy-editing/scripts/`:

| Script | Uso |
|---|---|
| `word-count.sh <file>` | Cuenta palabras, caracteres, oraciones, párrafos, promedio de palabras por oración y tiempo de lectura. Usar para ajustar longitud de copy. |
| `readability-check.sh <file>` | Mide legibilidad del texto. Usar en Sweep 1 (Clarity). |
| `sentiment-check.sh <file>` | Detecta tono/emoción del texto. Usar en Sweep 2 (Voice and Tone). |

---

# Principios

- No cambiar el mensaje core; enfocarse en realzarlo
- Múltiples pasadas enfocadas > una revisión general
- Cada edición debe tener una razón clara
- Preservar la voz del autor

---

# Related Skills

- [Narrative Content](../narrative-content): Para escritura de ficción y narrativa
- [Campaign Plan](../campaign-plan): Para planificar campañas de marketing
