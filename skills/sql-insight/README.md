# SQL Insight

SQL assistant: translation, optimization and EXPLAIN.

## What is it for?

For **writing SQL, optimizing slow queries and understanding execution plans**. Translates natural language to SQL, detects anti-patterns (SELECT *, N+1, functions in WHERE), and interprets EXPLAIN for SQLite and PostgreSQL.

## When to use it?

- When you need to write SQL and don't remember the syntax
- When you have a slow query and don't know why
- When you want to understand an EXPLAIN plan
- When you want to detect anti-patterns in existing queries

## How is it used?

### Workflow

1. **Schema Extraction** - extract table structure to provide context
2. **NL → SQL** - you describe what you want in natural language
3. **Query Optimization** - analyze against 13 anti-pattern rules
4. **EXPLAIN Analysis** - verify the execution plan

### Script

```bash
# Extract schema (compact, to provide context to the model)
python3 scripts/sql_query_helper.py --db-path data.db schema --compact

# Analyze SQL for anti-patterns (no DB needed)
python3 scripts/sql_query_helper.py optimize "SELECT * FROM orders WHERE user_id = 100"

# Run EXPLAIN and interpret
python3 scripts/sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
```

### Anti-patterns it detects

| Rule | Severity | Example |
|---|---|---|
| SELECT * | warning | `SELECT * FROM users` |
| LIKE '%...' | warning | `WHERE name LIKE '%text'` |
| Function in WHERE | warning | `WHERE UPPER(email) = 'X'` |
| NOT IN subquery | warning | `WHERE id NOT IN (SELECT ...)` |
| Scalar subquery | warning | Subquery in SELECT that runs per row |

## References

| File | What it contains |
|---|---|
| `references/optimization-rules.md` | The 13 rules with before/after examples |
| `references/explain-guide.md` | EXPLAIN interpretation for SQLite and PostgreSQL |

## Related skills

- [Observability](../observability) - For monitoring DB performance
- [Performance Optimization](../performance-optimization) - For optimizing slow queries
