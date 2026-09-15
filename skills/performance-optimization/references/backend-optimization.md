# Backend Optimization - Performance Optimization Reference

Backend optimization techniques.

## Caching Strategies

```typescript
// In-memory cache
const cache = new Map<string, { data: unknown; expiry: number }>();

function getCached<T>(key: string): T | null {
  const entry = cache.get(key);
  if (!entry || Date.now() > entry.expiry) {
    cache.delete(key);
    return null;
  }
  return entry.data as T;
}

function setCache<T>(key: string, data: T, ttlMs: number = 60000) {
  cache.set(key, { data, expiry: Date.now() + ttlMs });
}
```

### HTTP Caching

```typescript
// Response headers
res.setHeader('Cache-Control', 'public, max-age=60, stale-while-revalidate=300');
```

## Database Optimization

### Indexing

```sql
-- Check slow queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
```

### Query Optimization

```typescript
// Before: N+1
const users = await db.user.findMany();
for (const user of users) {
  const posts = await db.post.findMany({ where: { userId: user.id } });
}

// After: Single query with include
const users = await db.user.findMany({
  include: { posts: true },
});
```

## Connection Pooling

```typescript
// Supabase/PostgreSQL
const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});
```

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Frontend Optimization](./frontend-optimization.md) - Frontend optimization
- Database Optimization - indexes, N+1, query plans (see `references/domains.md`)
