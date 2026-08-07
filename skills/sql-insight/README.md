# SQL Insight

Asistente de SQL: traducción, optimización y EXPLAIN.

## ¿Para qué sirve?

Para **escribir SQL, optimizar queries lentas y entender planes de ejecución**. Traduce lenguaje natural a SQL, detecta anti-patrones (SELECT *, N+1, funciones en WHERE), e interpreta EXPLAIN para SQLite y PostgreSQL.

## ¿Cuándo usarlo?

- Cuando necesitás escribir una SQL y no te acordás la sintaxis
- Cuando tenés una query lenta y no sabés por qué
- Cuando querés entender un EXPLAIN plan
- Cuando querés detectar anti-patrones en queries existentes

## ¿Cómo se usa?

### Workflow

1. **Schema Extraction** - extraer estructura de tablas para dar contexto
2. **NL → SQL** - describís lo que querés en lenguaje natural
3. **Query Optimization** - analizar contra 13 reglas anti-patrón
4. **EXPLAIN Analysis** - verificar el plan de ejecución

### Script

```bash
# Extraer schema (compacto, para dar contexto al modelo)
python3 scripts/sql_query_helper.py --db-path data.db schema --compact

# Analizar SQL en busca de anti-patrones (no necesita DB)
python3 scripts/sql_query_helper.py optimize "SELECT * FROM orders WHERE user_id = 100"

# Correr EXPLAIN e interpretar
python3 scripts/sql_query_helper.py --db-path data.db explain "SELECT * FROM orders WHERE user_id = 100"
```

### Anti-patrones que detecta

| Regla | Severidad | Ejemplo |
|---|---|---|
| SELECT * | warning | `SELECT * FROM users` |
| LIKE '%...' | warning | `WHERE name LIKE '%text'` |
| Función en WHERE | warning | `WHERE UPPER(email) = 'X'` |
| NOT IN subquery | warning | `WHERE id NOT IN (SELECT ...)` |
| Scalar subquery | warning | Subquery en SELECT que se ejecuta por fila |

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/optimization-rules.md` | Las 13 reglas con ejemplos before/after |
| `references/explain-guide.md` | Interpretación de EXPLAIN para SQLite y PostgreSQL |

## Skills relacionadas

- [Observability](../observability) - Para monitorear performance de DB
- [Performance Optimization](../performance-optimization) - Para optimizar queries lentas
