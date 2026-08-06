---
name: "support-response-writer"
metadata:
  category: "Customer"
  tags:
    - soporte
    - customer-service
    - atencion-al-cliente
    - de-escalacion
description: "Generar respuestas profesionales de customer support: pre-venta, post-venta, reclamos y devoluciones, con estrategias de de-escalación emocional."
user-invocable: false
---

# Workflow: Support Response Writer

## Propósito

Generar respuestas profesionales de customer support para distintos escenarios: pre-venta, post-venta, reclamos y devoluciones. Incluye estrategias de de-escalación emocional según el nivel de intensidad del cliente.

## Cuándo usarlo

- Redactar respuesta de soporte
- Cliente furioso o frustrado
- Gestionar devolución o cambio
- Responder consulta pre-venta
- Manejar reclamo

## Escenarios

### Pre-Sale Inquiry
1. Warm greeting
2. Precise answer
3. Value reinforcement
4. Concern removal
5. Call to action

### After-Sale Support
1. Identity confirmation
2. Empathy expression
3. Problem diagnosis
4. Solution (step-by-step)
5. Follow-up

### Complaint Handling
1. Sincere apology
2. Emotional validation
3. Fact confirmation
4. Compensation plan
5. Improvement commitment
6. Continued care

### Returns & Exchanges
1. Positive attitude
2. Policy explanation
3. Process guidance
4. Streamlined handling
5. Retention & care

## Emotional De-Escalation

| Level | Strategy | Key Phrases |
|---|---|---|
| Calm | Professional, efficient | Answer directly |
| Anxious | Empathy + clear timeline | "Let me look into this right away" |
| Dissatisfied | Validate + ownership + compensation | "I'd feel the same way" |
| Angry | Listen + deep empathy + escalate | "I'm escalating this immediately" |
| Disappointed | Warm care + exceed expectations | "We feel terrible about letting you down" |

## Outputs

- Script de respuesta inicial
- Follow-up response
- Escalation response
- Estrategia de de-escalación
- Communication tips

## Helper Scripts

Scripts en `skills/support-response-writer/scripts/`:

| Script | Uso |
|---|---|
| `sentiment-check.sh <file>` | Detecta el tono/emoción de un mensaje de soporte y sugiere nivel de de-escalación. Usar antes de redactar la respuesta. |

Tambien ver [copy-editing/scripts/readability-check.sh](../copy-editing/scripts/readability-check.sh) para pulir legibilidad y [word-count.sh](../copy-editing/scripts/word-count.sh) para controlar longitud.

## Related Skills

- [Copy Editing](../copy-editing): Para pulir el tono de las respuestas
- [Campaign Plan](../campaign-plan): Para campañas de customer communication
