# Performance Optimization

Optimización de rendimiento del sistema.

## ¿Para qué sirve?

Para **mejorar el rendimiento** del sistema mediante evidencia, medición y optimizaciones incrementales. No desarrolla features, no corrige bugs funcionales. Elimina cuellos de botella reales.

**Filosofía:** Measure. Understand. Optimize. Verify. Nunca optimizar por intuición.

## ¿Cuándo usarlo?

- Lighthouse bajo
- Tiempos de respuesta altos
- CPU/memoria excesivos
- Queries lentas
- Bundles grandes
- Degradación después de releases

## ¿Cómo se usa?

### Workflow completo

1. **Baseline** — medir antes de optimizar
2. **Profiling** — encontrar cuellos de botella
3. **Bottleneck Analysis** — clasificar (CPU, memoria, I/O, network, DB, rendering, LLM)
4. **Optimization Strategy** — elegir intervención mínima
5. **Implementation Planning** — definir impacto, riesgo, esfuerzo, rollback
6. **Verification** — volver a medir, comparar contra baseline
7. **Cost/Benefit** — ¿cuánto costó? ¿cuánto mejoró?
8. **Knowledge Capture** — benchmark before/after, ADRs, CHANGELOG

### Scripts útiles

```bash
# Benchmark de response times
./scripts/benchmark.sh --url https://tusitio.com

# Lighthouse check con threshold
./scripts/lighthouse-check.sh https://tusitio.com --min-score 90
```

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/domains.md` | Dominios de performance |
| `references/tools.md` | Herramientas de profiling |
| `references/frontend-optimization.md` | Bundle, imágenes, rendering, Core Web Vitals |
| `references/backend-optimization.md` | Caching, indexing, query optimization, connection pooling |

## Skills relacionadas

- [Observability](../observability) — Para medir y monitorear performance
- [Debug Investigation](../debug-investigation) — Para investigar causas de degradación
