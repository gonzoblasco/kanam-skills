---
name: "sql-insight"
metadata:
  category: "Tool"
  tags:
    - sql
    - database
    - optimization
    - postgresql
    - sqlite
description: "Translate natural language to SQL, optimize queries and interpret EXPLAIN plans for SQLite and PostgreSQL."
user-invocable: false
---

# Workflow: SQL Insight

## Purpose

SQL assistant: translate natural language to SQL, analyze and optimize queries, and interpret execution plans (EXPLAIN) for SQLite and PostgreSQL.

## Philosophy

> A slow query is a bug you haven't measured yet.

Query optimization is not magic. It is understanding what the database is doing and why.

---

# When to use it

- Translate a natural language question to SQL
- Optimize a slow query
- Analyze an EXPLAIN plan
- Detect SQL anti-patterns (SELECT *, N+1, functions in WHERE)
- Extract schema from a database

---

# Phases

## 1. Schema Extraction

Extract table structure to provide context:

```bash
# SQLite
python3 scripts/sql_query_helper.py --db-path data.db schema --compact

# PostgreSQL
python3 scripts/sql_query_helper.py --db-type postgres --dsn "host=localhost dbname=mydb" schema --compact
```

## 2. NL → SQL

Use the schema as context to translate natural language to SQL.

## 3. Query Optimization

Analyze the generated query against 13 anti-pattern rules:

```bash
python3 scripts/sql_query_helper.py optimize "SELECT * FROM orders WHERE user_id = 100"
```

## 4. EXPLAIN Analysis

Verify the execution plan:

```bash
python3 scripts/sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
```

---

# Outputs

- SQL generated from natural language
- Optimization report with detected issues
- EXPLAIN plan interpretation
- Database schema in compact format

## Helper Scripts

Scripts in `skills/sql-insight/scripts/`:

| Script | Usage |
|---|---|
| `sql_query_helper.py` | Extracts schema, translates NL->SQL, optimizes queries, and analyzes EXPLAIN. Use in all phases. |

---

# Detected Anti-Patterns

| Rule | Severity | Description |
|---|---|---|
| SELECT * | warning | List columns explicitly |
| No WHERE/LIMIT | info | Query without limit |
| LIKE '%...' | warning | Index bypass |
| OR conditions | info | Can prevent index usage |
| NOT IN subquery | warning | Poor performance |
| Functions in WHERE | warning | Prevents index usage |
| Implicit joins | info | Less readable |
| ORDER BY without LIMIT | info | Sorting everything without limit |
| Nested subqueries | warning | Hard to optimize |

---

# Principles

- Always extract schema before generating SQL
- Prefer parameterized queries over concatenation
- Verify EXPLAIN before considering a query optimized
- Detect N+1 queries early

---

# Related Skills

- [Observability](../observability-and-instrumentation): For monitoring DB performance
- [Performance Optimization](../performance-optimization): For optimizing slow queries
