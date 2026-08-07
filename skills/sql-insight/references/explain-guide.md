# EXPLAIN Guide - SQL Insight Reference

Interpretación de planes de ejecución.

## SQLite

```sql
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'test@example.com';
```

Output típico:
```
SEARCH users USING INDEX idx_users_email (email=?)
```

| Señal | Significado | Acción |
|---|---|---|
| `SCAN TABLE` | Full table scan | Agregar índice |
| `SEARCH ... USING INDEX` | Index lookup | ✅ Bueno |
| `SEARCH ... USING COVERING INDEX` | Index-only scan | ✅ Excelente |
| `AUTO-TEMPORARY INDEX` | SQLite creó índice temporal | Crear índice permanente |

## PostgreSQL

```sql
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = 'test@example.com';
```

| Señal | Significado | Acción |
|---|---|---|
| `Seq Scan` | Full table scan | Agregar índice |
| `Index Scan` | Index lookup | ✅ Bueno |
| `Index Only Scan` | Index-only | ✅ Excelente |
| `Sort (external sort)` | Disk sort | Aumentar work_mem |
| `Nested Loop` en tablas grandes | Loop ineficiente | Usar Hash Join |
| `Rows Removed by Filter` | Muchas filas filtradas | Mejorar índice |

## Interpretación Rápida

```bash
python3 scripts/sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
```

Output:
```json
{
  "interpretation": [
    {
      "severity": "ok",
      "type": "index-search",
      "detail": "Index lookup: idx_orders_user_id",
      "suggestion": "Index lookup is efficient"
    }
  ]
}
```

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [Optimization Rules](./optimization-rules.md) - Reglas de optimización
