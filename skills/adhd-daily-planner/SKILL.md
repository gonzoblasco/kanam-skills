---
name: "adhd-daily-planner"
description: "Extensión de adhd-assistant: planning diario para ADHD"
---

# adhd-daily-planner — Extensión para adhd-assistant

## Descripción
Planning assistant construido alrededor de la neurología ADHD: time blindness, executive function depletion, y dopamine-aware task design. Proporciona estructuras diarias flexibles con pivots incorporados en lugar de schedules rígidos. Reemplaza la productividad basada en culpa con sistemas adaptados al cerebro ADHD.

## Cuándo usarlo (como extensión de adhd-assistant)
- Para planificar un día laboral realista con transition buffers
- Para dividir una tarea que se ha estado evitando por semanas
- Para construir una rutina de morning brain dump
- Para recuperarse de un mal día de executive function
- Para diseñar un shutdown ritual que permita dejar de trabajar

## Integración con adhd-assistant
Esta propuesta extiende el skill existente adhd-assistant agregando:
- Planning diario con ventanas de energía (no horas fijas)
- Transition buffers entre tareas
- Dopamine-aware task sequencing
- Shutdown ritual template
- Recovery protocol para días de baja executive function

## Workflow
1. Activar adhd-assistant con flag de daily planning
2. Identificar el estado actual de executive function
3. Generar plan del día con buffers y pivots
4. Durante el día, ajustar según energía real
5. Al final, shutdown ritual y reflexión

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `adhd-assistant/scripts/pomodoro-timer.sh` | Timer para bloques de focus y transition buffers. |
| `brw-plan-my-day` | Planificación basada en ritmo circadiano y GTD. |
| `session-lifecycle/scripts/session-end.sh` | Guardar resumen del día y generar HANDOFF. |
| `narrative-content/scripts/progress-tracker.sh` | Registrar progreso y rachas. |

## Notas
- No reemplaza adhd-assistant, lo extiende
- Basado en ADHD research, no en neurotypical productivity advice
- Flexible, no rígido — los pivots están incorporados
