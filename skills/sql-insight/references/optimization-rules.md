# SQL Optimization Rules - SQL Insight Reference

The 13 SQL anti-pattern detection rules.

## 1. SELECT * (avoid-select-star)
**Severity:** warning
**Problem:** Reads unnecessary columns, increases I/O and network transfer.
**Fix:** List only the needed columns.

```sql
-- ❌ Bad
SELECT * FROM users;

-- ✅ Good
SELECT id, name, email FROM users;
```

## 2. No WHERE/LIMIT (unbounded-query)
**Severity:** info
**Problem:** Query without filter or limit, can return millions of rows.
**Fix:** Add WHERE and/or LIMIT.

## 3. LIKE with leading wildcard (leading-wildcard-like)
**Severity:** warning
**Problem:** `LIKE '%text'` cannot use indexes.
**Fix:** Avoid leading wildcard, or use full-text search.

```sql
-- ❌ Bad (no index usage)
SELECT * FROM users WHERE name LIKE '%gonzalo%';

-- ✅ Good (index usage)
SELECT * FROM users WHERE name LIKE 'gonzalo%';
```

## 4. OR conditions (or-condition)
**Severity:** info
**Problem:** OR can prevent composite index usage.
**Fix:** Use UNION or IN.

```sql
-- ❌ Bad
SELECT * FROM orders WHERE status = 'pending' OR status = 'active';

-- ✅ Good
SELECT * FROM orders WHERE status IN ('pending', 'active');
```

## 5. NOT IN subquery (not-in-subquery)
**Severity:** warning
**Problem:** NOT IN with subquery has poor performance and issues with NULLs.
**Fix:** Use NOT EXISTS.

```sql
-- ❌ Bad
SELECT * FROM users WHERE id NOT IN (SELECT user_id FROM orders);

-- ✅ Good
SELECT * FROM users u WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.id);
```

## 6. Scalar subquery in SELECT (scalar-subquery)
**Severity:** warning
**Problem:** Subquery runs for each row (N+1).
**Fix:** Use JOIN or window functions.

## 7. Function on WHERE column (function-on-column)
**Severity:** warning
**Problem:** `WHERE UPPER(email) = 'X'` does not use index.
**Fix:** Store lowercase or use functional indexes.

## 8. Implicit joins (implicit-join)
**Severity:** info
**Problem:** Less readable, easy to forget join conditions.
**Fix:** Use explicit JOIN.

## 9. Unnecessary DISTINCT (distinct-usage)
**Severity:** info
**Problem:** DISTINCT can hide duplication caused by an incorrect JOIN.
**Fix:** Check if the JOIN is causing duplicates.

## 10. ORDER BY without LIMIT (order-without-limit)
**Severity:** info
**Problem:** Sorting everything without limit is expensive.
**Fix:** Add LIMIT.

## 11. Deep nested subqueries (deep-nesting)
**Severity:** warning
**Problem:** Hard to read and optimize.
**Fix:** Use CTEs (WITH).

## 12. HAVING without GROUP BY (having-without-group)
**Severity:** warning
**Problem:** HAVING without GROUP BY makes no sense.
**Fix:** Add GROUP BY or change to WHERE.

## 13. != filter (not-equal-filter)
**Severity:** info
**Problem:** `!=` cannot use indexes effectively.
**Fix:** Redesign the query if possible.

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [EXPLAIN Guide](./explain-guide.md) - EXPLAIN interpretation
