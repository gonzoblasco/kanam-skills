---
name: "apple-photos"
description: "Acceso terminal a Photos.app: buscar, listar y exportar fotos"
---

# apple-photos

## Descripción
Acceso terminal a macOS Photos.app mediante consultas directas a la base SQLite de Photos. Permite listar álbumes y personas, buscar fotos por rango de fecha, nombre de persona o contenido visual, y exportar fotos a JPEG. Resultados en menos de 100ms.

## Cuándo usarlo
- Para encontrar todas las fotos de una persona específica
- Para exportar una foto por UUID para usarla en otro script
- Para buscar fotos tomadas durante un rango de fechas específico
- Para listar todos los álbumes y auditar la organización de la biblioteca
- Para verificar estadísticas de la biblioteca (conteo total de fotos)

## Workflow
1. Solicitar búsqueda (por persona, fecha, álbum, o contenido visual)
2. apple-photos consulta la DB SQLite de Photos
3. Devolver resultados con UUIDs y metadata
4. Si se necesita exportar, especificar UUID y formato
5. El archivo se exporta al directorio solicitado

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `sql-insight/scripts/sql_query_helper.py` | Optimizar y auditar consultas SQLite contra la DB de Photos. |
| `db-readonly` | Ejecutar queries read-only seguras a la SQLite de Photos si se necesitan reportes. |

## Notas
- Requiere Full Disk Access para Terminal en System Settings > Privacy & Security
- Las consultas SQLite directas son muy rápidas (<100ms)
- No modifica la biblioteca de Photos, solo lectura
