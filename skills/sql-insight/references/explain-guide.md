# EXPLAIN Guide - SQL Insight Reference

Execution plan interpretation.

## SQLite

```sql
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'test@example.com';
```

Typical output:
```
SEARCH users USING INDEX idx_users_email (email=?)
```

| Signal | Meaning | Action |
|---|---|---|
| `SCAN TABLE` | Full table scan | Add index |
| `SEARCH ... USING INDEX` | Index lookup | ✅ Good |
| `SEARCH ... USING COVERING INDEX` | Index-only scan | ✅ Excellent |
| `AUTO-TEMPORARY INDEX` | SQLite created a temporary index | Create a permanent index |

## PostgreSQL

```sql
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = 'test@example.com';
```

| Signal | Meaning | Action |
|---|---|---|
| `Seq Scan` | Full table scan | Add index |
| `Index Scan` | Index lookup | ✅ Good |
| `Index Only Scan` | Index-only | ✅ Excellent |
| `Sort (external sort)` | Disk sort | Increase work_mem |
| `Nested Loop` on large tables | Inefficient loop | Use Hash Join |
| `Rows Removed by Filter` | Many rows filtered | Improve index |

## Quick Interpretation

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

- [SKILL.md](../SKILL.md) - Main workflow
- [Optimization Rules](./optimization-rules.md) - Optimization rules
