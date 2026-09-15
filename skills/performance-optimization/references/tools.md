# Performance Tools - Reference

## Frontend

| Tool | What for | Usage |
|---|---|---|
| **Chrome DevTools Performance** | Timeline, flamegraph, frames, memory | Record performance profile |
| **React Profiler** | Re-renders, slow components | `Profiler` API or DevTools |
| **Lighthouse** | Core Web Vitals, general audit | CLI or DevTools |
| **WebPageTest** | Tests from multiple locations | webpagetest.org |
| **Bundle Analyzer** | Bundle sizes, code splitting | `@next/bundle-analyzer` or `vite-bundle-visualizer` |

## Backend

| Tool | What for | Usage |
|---|---|---|
| **Node CPU Profiler** | CPU hotspots | `--prof` flag or `clinic` |
| **Heap Snapshots** | Memory leaks, memory usage | Chrome DevTools Memory or `heapdump` |
| **clinic.js** | Doctor, flame, bubbleprof | `npx clinic` |
| **0x** | Flamegraphs | `npx 0x` |
| **autocannon** | HTTP benchmarking | `npx autocannon` |

## Database

| Tool | What for | Usage |
|---|---|---|
| **EXPLAIN ANALYZE** | Query execution plan | Direct SQL |
| **pg_stat_statements** | Slow queries in PostgreSQL | Postgres extension |
| **Index Advisor** | Index recommendations | `pg_hint_plan` or Supabase Advisor |

## AI / LLM

| Tool | What for | Usage |
|---|---|---|
| **Prompt timing** | Prompt latency | Manual logging or SDK |
| **Token counter** | Token consumption | `tiktoken` or provider SDK |
| **Cache hits** | Response cache effectiveness | Provider metrics |

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Domains](./domains.md) - Performance domains
