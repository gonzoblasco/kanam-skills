# Frontend Optimization - Performance Optimization Reference

Frontend optimization techniques.

## Bundle Optimization

```bash
# Analyze bundle
npx next build --debug
npx vite build --analyze

# Check bundle size
npx bundlesize
```

### Code Splitting

```typescript
// Dynamic imports
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <Skeleton />,
});

// Route-based splitting (Next.js does this automatically)
```

### Image Optimization

```typescript
// Next.js Image
import Image from 'next/image';

<Image
  src="/hero.jpg"
  width={1200}
  height={630}
  priority={isAboveFold}
  loading={isAboveFold ? undefined : 'lazy'}
/>
```

## Rendering Optimization

### Memoization

```typescript
// Component memo
const ExpensiveList = React.memo(({ items }: Props) => {
  return items.map(item => <Item key={item.id} {...item} />);
});

// Hook memo
const filtered = useMemo(
  () => items.filter(i => i.active),
  [items]
);

// Callback memo
const handleClick = useCallback(
  (id: string) => setSelected(id),
  []
);
```

### Virtualization

```typescript
// For long lists
import { Virtualizer } from '@tanstack/react-virtual';
```

## Core Web Vitals

| Metric | Target | How to Improve |
|---|---|---|
| **LCP** | < 2.5s | Optimize images, preload hero, reduce TTFB |
| **FID** | < 100ms | Code splitting, lazy load non-critical JS |
| **CLS** | < 0.1 | Set image dimensions, avoid layout shifts |

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Backend Optimization](./backend-optimization.md) - Backend optimization
- Database Optimization - indexes, N+1, query plans (see `references/domains.md`)
