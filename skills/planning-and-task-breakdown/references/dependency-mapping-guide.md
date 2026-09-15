# Dependency Mapping Guide - Visualización de dependencias de tareas

Guía para mapear y visualizar dependencias entre tareas. Para `planning-and-task-breakdown`.

## Por qué mapear dependencias

Un plan sin orden de dependencias es una lista de deseos. Mapear dependencias revela:
- Qué se puede paralelizar (no tienen dependencias entre sí)
- Cuál es el camino crítico (la cadena más larga de dependencias)
- Qué bloques están esperando a otros (risk de scheduling)
- Dónde conviene dividir o reagrupar tareas

## Notación de dependencias

| Símbolo | Significado |
|---|---|
| `A → B` | A debe completarse antes que B |
| `A ‖ B` | A y B son independientes, se pueden paralelizar |
| `A ⊃ B` | A incluye a B (B es subtarea de A) |

## Técnicas de visualización

### 1. Grafo dirigido (DAG)
```
┌──> T2 ──┐
T1 ──> T3 ──> T5
     └──> T4 ──┘
```
- Nodos = tareas, flechas = "debe ir antes"
- Sin ciclos (si hay ciclo, es un bloqueo lógico)
- El camino crítico es la ruta más larga

### 2. Tabla de precedencia
| Tarea | Depende de | Bloquea a | Paralelizable con |
|---|---|---|---|
| T1 | - | T2, T3, T4 | - |
| T2 | T1 | T5 | T3, T4 |
| T3 | T1 | T5 | T2, T4 |
| T4 | T1 | - | T2, T3 |
| T5 | T2, T3 | - | - |

### 3. Lista de fases (topological order)
1. Fase 1: T1 (sin dependencias)
2. Fase 2: T2, T3, T4 (dependen solo de T1)
3. Fase 3: T5 (depende de T2 y T3)

## Reglas

1. **Detectá ciclos** - un ciclo significa un diseño incorrecto; rompelo.
2. **Identificá el camino crítico** - es el cuello de botella; priorizalo.
3. **Paralelizá lo independiente** - no serialices lo que no necesita serlo.
4. **Validá con un topological sort** - el orden de ejecución debe respetar todas las flechas.
5. **Mantené el mapa vivo** - actualizalo cuando cambie el plan, no al final.

## Related

- Usado por: `planning-and-task-breakdown`
- Complementa: `docs/checklists/task-template.md`, `docs/checklists/definition-of-done.md`
