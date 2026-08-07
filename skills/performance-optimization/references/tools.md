# Herramientas de Performance - Referencia

## Frontend

| Herramienta | Para qué | Uso |
|---|---|---|
| **Chrome DevTools Performance** | Timeline, flamegraph, frames, memoria | Grabación de perfil de rendimiento |
| **React Profiler** | Re-renders, componentes lentos | `Profiler` API o DevTools |
| **Lighthouse** | Core Web Vitals, auditoría general | CLI o DevTools |
| **WebPageTest** | Pruebas desde múltiples ubicaciones | webpagetest.org |
| **Bundle Analyzer** | Tamaño de bundles, code splitting | `@next/bundle-analyzer` o `vite-bundle-visualizer` |

## Backend

| Herramienta | Para qué | Uso |
|---|---|---|
| **Node CPU Profiler** | CPU hotspots | `--prof` flag o `clinic` |
| **Heap Snapshots** | Memory leaks, uso de memoria | Chrome DevTools Memory o `heapdump` |
| **clinic.js** | Doctor, flame, bubbleprof | `npx clinic` |
| **0x** | Flamegraphs | `npx 0x` |
| **autocannon** | HTTP benchmarking | `npx autocannon` |

## Base de Datos

| Herramienta | Para qué | Uso |
|---|---|---|
| **EXPLAIN ANALYZE** | Plan de ejecución de queries | SQL directo |
| **pg_stat_statements** | Queries lentas en PostgreSQL | Extensión de Postgres |
| **Index Advisor** | Recomendación de índices | `pg_hint_plan` o Supabase Advisor |

## AI / LLM

| Herramienta | Para qué | Uso |
|---|---|---|
| **Prompt timing** | Latencia de prompts | Logging manual o SDK |
| **Token counter** | Consumo de tokens | `tiktoken` o SDK del provider |
| **Cache hits** | Efectividad de caché de respuestas | Métricas del provider |

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [Domains](./domains.md) - Dominios de performance
