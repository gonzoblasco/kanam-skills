---
name: "sql-insight"
metadata:
  category: "Tool"
  tags:
    - sql
    - base-de-datos
    - optimizacion
    - postgresql
    - sqlite
description: "Traducir lenguaje natural a SQL, optimizar queries e interpretar planes EXPLAIN para SQLite y PostgreSQL."
user-invocable: false
---

# Workflow: SQL Insight

## Propósito

Asistente de SQL: traducir lenguaje natural a SQL, analizar y optimizar queries, e interpretar planes de ejecución (EXPLAIN) para SQLite y PostgreSQL.

## Filosofía

> A slow query is a bug you haven't measured yet.

La optimización de queries no es magia. Es entender qué está haciendo la base de datos y por qué.

---

# Cuándo usarlo

- Traducir una pregunta en lenguaje natural a SQL
- Optimizar una query lenta
- Analizar un plan EXPLAIN
- Detectar anti-patrones SQL (SELECT *, N+1, funciones en WHERE)
- Extraer schema de una base de datos

---

# Fases

## 1. Schema Extraction

Extraer estructura de tablas para dar contexto:

```bash
# SQLite
python3 scripts/sql_query_helper.py --db-path data.db schema --compact

# PostgreSQL
python3 scripts/sql_query_helper.py --db-type postgres --dsn "host=localhost dbname=mydb" schema --compact
```

## 2. NL → SQL

Usar el schema como contexto para traducir lenguaje natural a SQL.

## 3. Query Optimization

Analizar la query generada contra 13 reglas de anti-patrones:

```bash
python3 scripts/sql_query_helper.py optimize "SELECT * FROM orders WHERE user_id = 100"
```

## 4. EXPLAIN Analysis

Verificar el plan de ejecución:

```bash
python3 scripts/sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
```

---

# Outputs

- SQL generado desde lenguaje natural
- Reporte de optimización con issues detectados
- Interpretación del plan EXPLAIN
- Schema de base de datos en formato compacto

## Helper Scripts

Scripts en `skills/sql-insight/scripts/`:

| Script | Uso |
|---|---|
| `sql_query_helper.py` | Extrae schema, traduce NL->SQL, optimiza queries, y analiza EXPLAIN. Usar en todas las fases. |

---

# Anti-Patrones Detectados

| Regla | Severidad | Descripción |
|---|---|---|
| SELECT * | warning | Listar columnas explícitamente |
| Sin WHERE/LIMIT | info | Query sin límite |
| LIKE '%...' | warning | Bypass de índice |
| OR conditions | info | Puede evitar uso de índice |
| NOT IN subquery | warning | Performance pobre |
| Funciones en WHERE | warning | Previene uso de índice |
| Joins implícitos | info | Menos legibles |
| ORDER BY sin LIMIT | info | Ordenar todo sin límite |
| Subqueries anidadas | warning | Difícil de optimizar |

---

# Principios

- Siempre extraer schema antes de generar SQL
- Preferir queries parametrizadas sobre concatenación
- Verificar EXPLAIN antes de considerar una query optimizada
- Detectar N+1 queries temprano

---

# Related Skills

- [Observability](../observability): Para monitorear performance de DB
- [Performance Optimization](../performance-optimization): Para optimizar queries lentas
