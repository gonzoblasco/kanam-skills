---
name: "calorie-counter"
description: "Tracking diario de calorías y proteína en SQLite local"
---

# calorie-counter

## Descripción
Trackea ingesta diaria de calorías y proteína usando una base SQLite local. Acepta entradas de alimentos por nombre con valores de calorías y proteína, estima proteína cuando no se especifica, y muestra totales acumulados después de cada entrada. También logea peso corporal y mantiene historial entre días.

## Cuándo usarlo
- Para loguear comidas durante el día sin abrir una app
- Para verificar cuántas calorías quedan antes de la cena
- Para establecer un nuevo objetivo calórico antes de empezar una dieta
- Para trackear cambios de peso durante el último mes
- Para eliminar una entrada de comida logueada por error

## Workflow
1. Configurar objetivos diarios (calorías, proteína)
2. Durante el día, loguear cada comida con nombre y valores
3. Revisar totales acumulados después de cada entrada
4. Al final del día, loguear peso corporal
5. Revisar historial semanal/mensual

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `sql-insight/scripts/sql_query_helper.py` | Consultar y analizar el historial SQLite de calorías/peso. |
| `db-readonly` | Queries read-only seguras contra la SQLite local. |

## Notas
- Todo local, sin cuenta ni suscripción
- Estima proteína automáticamente cuando no se especifica
- SQLite local, datos nunca salen de la máquina
