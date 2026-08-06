---
name: "deslop"
description: "Limpia código AI slop de branches antes de PRs"
---

# deslop

## Descripción
Escanea el diff de una branch y remueve ruido generado por IA: null checks defensivos innecesarios, try/catch que no matchean el estilo del proyecto, type casts redundantes, comentarios placeholder, y lint-disable comments agregados defensivamente. Verifica que el build pase después de cada eliminación.

## Cuándo usarlo
- Antes de abrir un PR con código generado por IA
- Para limpiar verbose null checks de código generado
- Para remover try/catch blocks defensivos que no corresponden
- Para eliminar comentarios TODO/placeholder de scaffolding
- Para quitar lint-disable comments agregados por IA

## Workflow
1. Tener la branch con los cambios generados por IA
2. Ejecutar deslop sobre la branch
3. Revisar los cambios propuestos (modo review)
4. Si todo ok, ejecutar en modo auto con approval
5. Verificar que el build pase
6. Abrir el PR

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `code-review-and-quality` | Scan general de deuda técnica y AI slop (absorbio a vibe-code-cleanup). Usar antes de deslop para priorizar. |
| `ci-cd-and-automation` | Validar build, typecheck, lint y tests despues de limpiar. |
| `code-review-and-quality` | Revision automatica final del PR (absorbio a review-quality). |

## Notas
- Compara cada candidato contra el contexto local antes de borrar
- Preserva guards legítimos en trust boundaries
- Verifica el build después de cada cambio
