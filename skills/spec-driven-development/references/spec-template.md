# Spec Template - Plantillas de PRD/spec

Plantillas de spec para `spec-driven-development`. Estructura de un PRD accionable antes de escribir código.

## Template de spec completo

```markdown
# Spec: [Feature/Title]

## Objetivos
- **Problema:** [qué resuelve]
- **Éxito:** [cómo se mide que funcionó]
- **No objetivos:** [qué explícitamente NO hace]

## Arquitectura
- **Enfoque:** [alto nivel de la solución]
- **Trade-offs:** [qué se gana y qué se pierde con esta decisión]

## Data Model
| Entidad | Campos | Relaciones |
|---|---|---|
| [name] | [field: type] | [relación] |

## UI
- **Flujo:** [pasos de interacción]
- **Estados:** [loading, empty, error, success]
- **Accesibilidad:** [qué requiere AT, focus, anuncios]

## Acceptance Criteria
- [ ] [criterio verificable 1]
- [ ] [criterio verificable 2]

## Traceability
- **Issues:** [enlaces a issues que cubren esta spec]
- **Tests:** [enlaces a tests que verifican cada criterio]
```

## Principios de un buen spec

1. **Acceptance criteria verificables** - no "funciona bien", sino "el POST devuelve 201 con el body X".
2. **No objetivos explícitos** - define el límite de alcance para evitar scope creep.
3. **Trade-offs documentados** - el *why* de las decisiones, no solo el qué.
4. **Traceability** - cada criterio se mapea a un issue y a un test.
5. **Data model concreto** - entidades, campos y relaciones, no "una tabla de usuarios".

## Checklist de review de spec

- [ ] ¿El problema está definido con éxito medible?
- [ ] ¿Los acceptance criteria son verificables (no vagos)?
- [ ] ¿Están los no-objetivos?
- [ ] ¿Los trade-offs de arquitectura están documentados?
- [ ] ¿Cada criterio tiene traceability a issue + test?
- [ ] ¿El data model es concreto y completo?

## Related

- Usado por: `spec-driven-development`
- Complementa: `docs/checklists/definition-of-done.md`
