---
name: "checkmate"
description: "Goal-to-execution-to-verification loop con worker + judge"
---

# checkmate

## Descripción
Convierte una descripción de tarea en criterios pass/fail explícitos, spawnéa un worker agent para intentar la tarea, corre un judge agent contra los criterios, y loopea con feedback acumulado hasta que todo pase. Modo interactivo (revisás criterios y aprobás cada checkpoint) o batch (autónomo).

## Cuándo usarlo
- Para tareas de código donde el definition of done no debe driftar
- Para research reports que deben cubrir temas específicos
- Para documentos que deben cumplir una quality checklist
- Para transformaciones de datos donde el output debe matchear un spec
- Para automatizar QA loops que requerirían revisiones manuales

## Workflow
1. Describir la tarea en lenguaje natural
2. checkmate genera criterios pass/fail (revisar en modo interactivo)
3. Worker intenta la tarea
4. Judge evalúa contra los criterios
5. Si falla, feedback loop con accumulated context
6. Cuando todo pasa, entregar resultado

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `engineering-governance/scripts/test-skills.sh` | Validar scripts que el worker/judge generen para el workspace. |
| `code-review-and-quality` | Revisión de calidad del output cuando es código (absorbio a review-quality). |
| `qa-patrol` | QA automatizado adicional para verificar criterios de aceptación. |

## Notas
- Usar modo interactivo para tareas críticas (auth, payments, data models)
- Modo batch solo para tareas bien definidas y de bajo riesgo
- El judge es un rol separado del worker, evitando drift del definition of done
