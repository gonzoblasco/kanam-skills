# Performance Optimization

System performance optimization.

## What is it for?

To **improve system performance** through evidence, measurement and incremental optimizations. It does not develop features, does not fix functional bugs. It removes real bottlenecks.

**Philosophy:** Measure. Understand. Optimize. Verify. Never optimize by intuition.

## When to use it?

- Low Lighthouse scores
- High response times
- Excessive CPU/memory
- Slow queries
- Large bundles
- Degradation after releases

## How is it used?

### Full workflow

1. **Baseline** - measure before optimizing
2. **Profiling** - find bottlenecks
3. **Bottleneck Analysis** - classify (CPU, memory, I/O, network, DB, rendering, LLM)
4. **Optimization Strategy** - choose the minimal intervention
5. **Implementation Planning** - define impact, risk, effort, rollback
6. **Verification** - measure again, compare against baseline
7. **Cost/Benefit** - how much did it cost? how much did it improve?
8. **Knowledge Capture** - before/after benchmark, ADRs, CHANGELOG

### Useful scripts

```bash
# Response times benchmark
./scripts/benchmark.sh --url https://yoursite.com

# Lighthouse check with threshold
./scripts/lighthouse-check.sh https://yoursite.com --min-score 90
```

## References

| File | What it contains |
|---|---|
| `references/domains.md` | Performance domains |
| `references/tools.md` | Profiling tools |
| `references/frontend-optimization.md` | Bundle, images, rendering, Core Web Vitals |
| `references/backend-optimization.md` | Caching, indexing, query optimization, connection pooling |

## Related skills

- [Observability & Instrumentation](../observability-and-instrumentation) - To measure and monitor performance
- [Debugging & Error Recovery](../debugging-and-error-recovery) - To investigate causes of degradation
