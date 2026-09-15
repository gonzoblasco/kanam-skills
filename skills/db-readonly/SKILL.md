---
name: "db-readonly"
description: "Safe read-only queries for PostgreSQL and MySQL"
---

# db-readonly

## Description
Executes SELECT, WITH and EXPLAIN queries against PostgreSQL or MySQL databases. Blocks INSERT, UPDATE, DELETE, DROP and ALTER to prevent accidental modifications. Exports results to CSV, TSV or JSON.

## When to Use It
- To inspect table schemas before writing a migration
- To count rows and verify that a data import completed
- To sample records and debug a reported issue
- To export query results to CSV for reports
- To run EXPLAIN on slow queries and diagnose performance

## Workflow
1. Set environment variables with DB credentials (PGHOST, PGDATABASE, etc.)
2. Write the SELECT/WITH/EXPLAIN query
3. Run db-readonly with the query
4. Receive results in the requested format

## Related Tooling

| Skill / Script | Usage |
|---|---|
| `sql-insight/scripts/sql_query_helper.py` | Optimize slow queries, interpret EXPLAIN, and extract schema in compact format. |
| `performance-optimization/scripts/benchmark.sh` | Measure the performance impact of queries. |

## Notes
- Blocks writes at the skill level, not only at the promise level
- Requires configuring the connection via environment variables
- Supports multiple connections (PostgreSQL and MySQL)
