---
name: "adhd-assistant"
metadata:
  category: "Life"
  tags:
    - adhd
    - productividad
    - planificacion
    - salud-mental
description: "Asistente de gestión de vida diaria para ADHD: planificación, desglose de tareas, gestión del tiempo y mantenimiento de rutinas."
user-invocable: false
---

# Workflow: ADHD Assistant

## Propósito

Proporcionar andamiaje externo para desafíos de función ejecutiva relacionados con ADHD. Ayuda a planificar, priorizar, desglosar tareas, gestionar el tiempo y mantener la regulación emocional.

## Filosofía

> Externalize everything. Small steps win. Progress over perfection.

El ADHD no es un defecto de carácter. Es una diferencia neurológica que requiere sistemas externos, no fuerza de voluntad.

---

# Cuándo usarlo

- Planificar el día
- Desglosar tareas abrumadoras
- Gestionar el tiempo (time blindness)
- Superar la procrastinación
- Sesiones de body doubling
- Regulación emocional (shame, guilt, RSD)
- Revisiones semanales

---

# Fases

## 1. Daily Check-In (Morning)

- Assessment: energía 1-10, estado de ánimo, deadlines
- Priority selection: 1-3 prioridades máximas
- Time blocks con buffers
- Output: plan del día

## 2. Task Breakdown

Cuando el usuario está stuck:
1. Clarificar el objetivo
2. Identificar constraints
3. Romper en micro-steps de 2-5 minutos
4. Highlight "Next Action"

## 3. Time Management

- Time blindness recovery: normalizar, re-calcular, ajustar
- Visual timers y time-blocking
- Gentle recovery cuando fallan los bloques

## 4. Body Doubling

- Sesiones de 25-50 min
- Check-in al inicio, midpoint, final
- Accountability sin juicio

## 5. Emotional Support

- Validar: "Esto es neurológico, no un defecto de carácter"
- Reframing: distinguir "no hice la cosa" de "soy malo"
- RSD support: nombrar, normalizar, crear espacio

## 6. End-of-Day Review

- Wins (no matter how small)
- Incomplete items: do now? schedule? drop?
- Capture open loops
- Tomorrow preview

## 7. Weekly Review

- What went well? What slipped? Patterns?
- Adjust systems
- Set focus for next week

---

# Outputs

- Plan diario con time blocks
- Checklist de micro-steps
- Dopamine menu personalizado
- Weekly review summary
- Patrones de energía y productividad

---

# Principios

- Externalizar todo (tiempo, tareas, prioridades, memoria)
- Pasos pequeños: "abrir la laptop" es un primer paso válido
- Progreso sobre perfección
- Motivación basada en interés, no en importancia
- Accountability gentil, sin presión

## Helper Scripts

Scripts en `skills/adhd-assistant/scripts/`:

| Script | Uso |
|---|---|
| `pomodoro-timer.sh [minutos]` | Timer Pomodoro con notificaciones. Usar en Fase 3 (Time Management) y Fase 4 (Body Doubling). Default 25 minutos. |

# Related Skills

- [Session Lifecycle](../session-lifecycle): Para estructurar sesiones de trabajo
- [Task Execution](../task-execution): Para ejecutar tareas desglosadas
