#!/usr/bin/env python3
"""sql_query_helper.py - SQL query assistant: schema extraction, optimization, EXPLAIN.

Usage:
  # Schema extraction
  python3 sql_query_helper.py --db-path data.db schema [--compact]
  python3 sql_query_helper.py --db-type postgres --dsn "host=localhost dbname=mydb" schema --compact

  # Query optimization (no DB needed)
  python3 sql_query_helper.py optimize "SELECT * FROM orders WHERE user_id = 100"

  # EXPLAIN analysis
  python3 sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
  python3 sql_query_helper.py --db-type postgres --dsn "host=localhost dbname=mydb" explain --analyze "SELECT * FROM orders"
"""

import sys
import json
import re
import sqlite3
import os
from pathlib import Path


# ─── Schema Extraction ───────────────────────────────────────────────

def extract_schema_sqlite(db_path: str, compact: bool = False, sample_rows: int = 3):
    """Extract schema from SQLite database."""
    conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    cursor = conn.cursor()

    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
    tables = cursor.fetchall()

    result = []
    for (table_name,) in tables:
        cursor.execute(f"PRAGMA table_info(\"{table_name}\")")
        columns = cursor.fetchall()

        cursor.execute(f"PRAGMA index_list(\"{table_name}\")")
        indexes = cursor.fetchall()

        cursor.execute(f"PRAGMA foreign_key_list(\"{table_name}\")")
        fks = cursor.fetchall()

        # Count rows
        cursor.execute(f"SELECT COUNT(*) FROM \"{table_name}\"")
        row_count = cursor.fetchone()[0]

        # Build column descriptions
        col_desc = []
        for col in columns:
            cid, name, col_type, not_null, default, pk = col
            parts = [name, col_type]
            if pk:
                parts.append("PK")
            if not_null:
                parts.append("NOT NULL")
            col_desc.append(" ".join(parts))

        # Build index descriptions
        idx_desc = []
        for idx in indexes:
            idx_id, idx_name, unique = idx
            cursor.execute(f"PRAGMA index_info(\"{idx_name}\")")
            idx_cols = [row[2] for row in cursor.fetchall()]
            unique_str = "UNIQUE" if unique else ""
            idx_desc.append(f"  {unique_str} {idx_name} on ({', '.join(idx_cols)})")

        # Build FK descriptions
        fk_desc = []
        for fk in fks:
            fk_id, fk_seq, fk_table, fk_from, fk_to, on_update, on_delete, match = fk
            fk_desc.append(f"  FK: {fk_from} -> {fk_table}.{fk_to}")

        # Sample data
        sample = []
        if sample_rows > 0:
            try:
                cursor.execute(f"SELECT * FROM \"{table_name}\" LIMIT {sample_rows}")
                sample = cursor.fetchall()
            except Exception:
                pass

        if compact:
            idx_str = ", ".join([f"{'UNIQUE ' if u else ''}{n} on ({', '.join(c)})" 
                                for (i, n, u), c in 
                                [(idx, [r[2] for r in cursor.execute(f"PRAGMA index_info(\"{n}\")").fetchall()])
                                 for idx in indexes]])
            fk_str = ", ".join([f"FK: {f[3]} -> {f[2]}.{f[4]}" for f in fks])
            line = f"-- {table_name} ({row_count} rows): {', '.join(col_desc)}"
            if idx_str:
                line += f"\n--   {idx_str}"
            if fk_str:
                line += f"\n--   {fk_str}"
            result.append(line)
        else:
            entry = {
                "table": table_name,
                "rows": row_count,
                "columns": col_desc,
                "indexes": idx_desc,
                "foreign_keys": fk_desc,
                "sample": sample,
            }
            result.append(entry)

    conn.close()

    if compact:
        print(f"-- Database: sqlite ({db_path})")
        for line in result:
            print(line)
    else:
        print(json.dumps(result, indent=2, default=str))


# ─── Query Optimization ─────────────────────────────────────────────

OPTIMIZATION_RULES = [
    {
        "rule": "avoid-select-star",
        "severity": "warning",
        "pattern": r"SELECT\s+\*",
        "message": "Avoid SELECT *: only select the columns you need",
        "suggestion": "Replace SELECT * with an explicit list of required column names",
    },
    {
        "rule": "unbounded-query",
        "severity": "info",
        "pattern": r"^(?!.*\bWHERE\b)(?!.*\bLIMIT\b).*",
        "message": "Query has no WHERE or LIMIT clause",
        "suggestion": "Add WHERE and/or LIMIT to restrict the result set",
    },
    {
        "rule": "leading-wildcard-like",
        "severity": "warning",
        "pattern": r"LIKE\s+['\"]%",
        "message": "Leading wildcard in LIKE prevents index usage",
        "suggestion": "Avoid leading wildcards, or use full-text search",
    },
    {
        "rule": "function-on-column",
        "severity": "warning",
        "pattern": r"\b(UPPER|LOWER|SUBSTR|TRIM|DATE|YEAR|MONTH)\s*\([^)]*\.[^)]*\)",
        "message": "Function on column in WHERE prevents index usage",
        "suggestion": "Store pre-computed values or use functional indexes",
    },
    {
        "rule": "implicit-join",
        "severity": "info",
        "pattern": r"FROM\s+\w+\s*,\s*\w+",
        "message": "Uses implicit join (comma-separated tables)",
        "suggestion": "Use explicit JOIN ... ON syntax",
    },
    {
        "rule": "not-in-subquery",
        "severity": "warning",
        "pattern": r"NOT\s+IN\s*\(",
        "message": "NOT IN (subquery) has poor performance",
        "suggestion": "Use NOT EXISTS instead of NOT IN",
    },
    {
        "rule": "scalar-subquery",
        "severity": "warning",
        "pattern": r"SELECT\s+.*\(SELECT\s+",
        "message": "Scalar subquery in SELECT executes row-by-row",
        "suggestion": "Use JOIN or window functions instead",
    },
    {
        "rule": "order-without-limit",
        "severity": "info",
        "pattern": r"ORDER\s+BY\s+.+?(?!LIMIT)",
        "message": "ORDER BY without LIMIT sorts entire result set",
        "suggestion": "Add LIMIT to reduce sorting overhead",
    },
    {
        "rule": "having-without-group",
        "severity": "warning",
        "pattern": r"\bHAVING\b(?!.*\bGROUP\s+BY\b)",
        "message": "HAVING without GROUP BY",
        "suggestion": "Add GROUP BY or change HAVING to WHERE",
    },
    {
        "rule": "not-equal-filter",
        "severity": "info",
        "pattern": r"[^!]!=\s*['\"\w]",
        "message": "!= conditions cannot effectively use indexes",
        "suggestion": "Consider redesigning the query if possible",
    },
]


def optimize_query(sql: str) -> dict:
    """Analyze SQL query for anti-patterns."""
    sql_upper = sql.upper().strip()
    issues = []

    for rule in OPTIMIZATION_RULES:
        if re.search(rule["pattern"], sql, re.IGNORECASE):
            # Skip unbounded-query if it has WHERE or LIMIT
            if rule["rule"] == "unbounded-query":
                if re.search(r"\bWHERE\b", sql_upper) or re.search(r"\bLIMIT\b", sql_upper):
                    continue
            issues.append({
                "severity": rule["severity"],
                "rule": rule["rule"],
                "message": rule["message"],
                "suggestion": rule["suggestion"],
            })

    return {
        "sql": sql,
        "issues": issues,
        "issue_count": len(issues),
    }


# ─── EXPLAIN Interpretation ─────────────────────────────────────────

def explain_sqlite(db_path: str, sql: str, analyze: bool = False):
    """Run EXPLAIN on SQLite and interpret."""
    conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    cursor = conn.cursor()

    try:
        cursor.execute(f"EXPLAIN QUERY PLAN {sql}")
        plan = cursor.fetchall()
    except sqlite3.Error as e:
        print(json.dumps({"error": str(e)}))
        conn.close()
        return

    interpretation = []
    for row in plan:
        detail = row[2] if len(row) > 2 else str(row)
        if "SCAN TABLE" in detail:
            interpretation.append({
                "severity": "warning",
                "type": "full-table-scan",
                "detail": detail,
                "suggestion": "Consider adding an index for this query",
            })
        elif "SEARCH" in detail and "COVERING" in detail:
            interpretation.append({
                "severity": "ok",
                "type": "covering-index-scan",
                "detail": detail,
                "suggestion": "Covering index is optimal",
            })
        elif "SEARCH" in detail:
            interpretation.append({
                "severity": "ok",
                "type": "index-search",
                "detail": detail,
                "suggestion": "Index lookup is efficient",
            })
        elif "AUTO" in detail:
            interpretation.append({
                "severity": "warning",
                "type": "auto-temporary-index",
                "detail": detail,
                "suggestion": "Create a permanent index to avoid auto-creation overhead",
            })
        else:
            interpretation.append({
                "severity": "info",
                "type": "other",
                "detail": detail,
                "suggestion": "",
            })

    result = {
        "db_type": "sqlite",
        "query": sql,
        "plan": [{"id": r[0], "parent": r[1], "detail": r[2]} for r in plan],
        "interpretation": interpretation,
    }

    print(json.dumps(result, indent=2))
    conn.close()


# ─── Main ───────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    db_type = "sqlite"
    db_path = ""
    dsn = ""
    analyze = False

    args = sys.argv[1:]
    while args:
        if args[0] == "--db-type" and len(args) > 1:
            db_type = args[1]
            args = args[2:]
        elif args[0] == "--db-path" and len(args) > 1:
            db_path = args[1]
            args = args[2:]
        elif args[0] == "--dsn" and len(args) > 1:
            dsn = args[1]
            args = args[2:]
        elif args[0] == "--analyze":
            analyze = True
            args = args[1:]
        else:
            break

    if not args:
        print("❌ Missing subcommand: schema, optimize, or explain")
        sys.exit(1)

    command = args[0]
    rest = args[1:]

    if command == "schema":
        compact = "--compact" in rest
        sample_rows = 3
        for i, a in enumerate(rest):
            if a == "--sample-rows" and i + 1 < len(rest):
                sample_rows = int(rest[i + 1])
        if db_type == "sqlite":
            extract_schema_sqlite(db_path, compact, sample_rows)
        else:
            print("⚠️  PostgreSQL schema extraction requires psycopg2. Install: pip install psycopg2-binary")
            print("   For now, use SQLite or provide schema manually.")

    elif command == "optimize":
        sql = " ".join(rest)
        if not sql:
            print("❌ No SQL query provided")
            sys.exit(1)
        result = optimize_query(sql)
        print(json.dumps(result, indent=2))

    elif command == "explain":
        sql = " ".join(rest)
        if not sql:
            print("❌ No SQL query provided")
            sys.exit(1)

        # Safety: only allow SELECT/WITH/EXPLAIN
        sql_upper = sql.upper().strip()
        if not sql_upper.startswith(("SELECT", "WITH", "EXPLAIN")):
            print(json.dumps({"error": "Only SELECT/WITH/EXPLAIN statements are allowed"}))
            sys.exit(1)

        if db_type == "sqlite":
            explain_sqlite(db_path, sql, analyze)
        else:
            print("⚠️  PostgreSQL EXPLAIN requires psycopg2. Install: pip install psycopg2-binary")

    else:
        print(f"❌ Unknown command: {command}")
        print("   Available: schema, optimize, explain")


if __name__ == "__main__":
    main()
