# SQL Optimization Rules - SQL Insight Reference

Las 13 reglas de detección de anti-patrones SQL.

## 1. SELECT * (avoid-select-star)
**Severidad:** warning
**Problema:** Lee columnas innecesarias, aumenta I/O y transferencia de red.
**Fix:** Listar solo las columnas necesarias.

```sql
-- ❌ Bad
SELECT * FROM users;

-- ✅ Good
SELECT id, name, email FROM users;
```

## 2. Sin WHERE/LIMIT (unbounded-query)
**Severidad:** info
**Problema:** Query sin filtro ni límite, puede devolver millones de filas.
**Fix:** Agregar WHERE y/o LIMIT.

## 3. LIKE con wildcard inicial (leading-wildcard-like)
**Severidad:** warning
**Problema:** `LIKE '%text'` no puede usar índices.
**Fix:** Evitar wildcard al inicio, o usar búsqueda全文.

```sql
-- ❌ Bad (no index usage)
SELECT * FROM users WHERE name LIKE '%gonzalo%';

-- ✅ Good (index usage)
SELECT * FROM users WHERE name LIKE 'gonzalo%';
```

## 4. OR conditions (or-condition)
**Severidad:** info
**Problema:** OR puede impedir uso de índices compuestos.
**Fix:** Usar UNION o IN.

```sql
-- ❌ Bad
SELECT * FROM orders WHERE status = 'pending' OR status = 'active';

-- ✅ Good
SELECT * FROM orders WHERE status IN ('pending', 'active');
```

## 5. NOT IN subquery (not-in-subquery)
**Severidad:** warning
**Problema:** NOT IN con subquery tiene poor performance y problemas con NULLs.
**Fix:** Usar NOT EXISTS.

```sql
-- ❌ Bad
SELECT * FROM users WHERE id NOT IN (SELECT user_id FROM orders);

-- ✅ Good
SELECT * FROM users u WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.id);
```

## 6. Scalar subquery en SELECT (scalar-subquery)
**Severidad:** warning
**Problema:** Subquery se ejecuta por cada fila (N+1).
**Fix:** Usar JOIN o window functions.

## 7. Función en columna WHERE (function-on-column)
**Severidad:** warning
**Problema:** `WHERE UPPER(email) = 'X'` no usa índice.
**Fix:** Almacenar en minúsculas o usar índices funcionales.

## 8. Joins implícitos (implicit-join)
**Severidad:** info
**Problema:** Menos legibles, fácil olvidar condiciones de join.
**Fix:** Usar JOIN explícito.

## 9. DISTINCT innecesario (distinct-usage)
**Severidad:** info
**Problema:** DISTINCT puede ocultar duplicación por JOIN incorrecto.
**Fix:** Verificar si el JOIN está causando duplicados.

## 10. ORDER BY sin LIMIT (order-without-limit)
**Severidad:** info
**Problema:** Ordenar todo sin límite es caro.
**Fix:** Agregar LIMIT.

## 11. Subqueries anidadas profundas (deep-nesting)
**Severidad:** warning
**Problema:** Difícil de leer y optimizar.
**Fix:** Usar CTEs (WITH).

## 12. HAVING sin GROUP BY (having-without-group)
**Severidad:** warning
**Problema:** HAVING sin GROUP BY no tiene sentido.
**Fix:** Agregar GROUP BY o cambiar a WHERE.

## 13. Filtro != (not-equal-filter)
**Severidad:** info
**Problema:** `!=` no puede usar índices efectivamente.
**Fix:** Rediseñar query si es posible.

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [EXPLAIN Guide](./explain-guide.md) - Interpretación de EXPLAIN
