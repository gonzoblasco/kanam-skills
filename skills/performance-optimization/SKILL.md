---
name: "performance-optimization"
metadata:
  category: "Workflow"
  tags:
    - performance
    - optimizacion
    - profiling
description: "Workflow de Performance Optimization: análisis, profiling y optimización sistemática de frontend, backend, base de datos e infraestructura sin cambiar el comportamiento funcional."
user-invocable: false
---

# Workflow: Performance Optimization

## Propósito

Mejorar el rendimiento del sistema mediante evidencia, medición y optimizaciones incrementales.

No desarrolla nuevas funcionalidades.

No corrige bugs funcionales.

No persigue métricas arbitrarias.

Su misión es eliminar cuellos de botella reales.

---

# Filosofía

> Measure. Understand. Optimize. Verify.

Nunca optimizar por intuición.

Nunca sacrificar mantenibilidad por micro-optimizaciones.

Optimizar donde exista impacto medible.

---

# Cuándo usarlo

- Lighthouse bajo
- tiempos de respuesta altos
- consumo excesivo de CPU
- consumo excesivo de memoria
- consultas lentas
- bundles grandes
- degradación después de releases
- crecimiento de usuarios

---

# Relación con otros workflows

Observability

↓

Performance Optimization

↓

Task Execution

↓

Review Quality

↓

Pre-Deploy QA

---

# Dominios

Ver [dominios de performance](./references/domains.md).

---

# Fases

## 1. Baseline

Medir.

Nunca comenzar optimizando.

Registrar:

- tiempos
- consumo
- métricas actuales

Construir línea base.

---

## 2. Profiling

Encontrar cuellos de botella. Ver [herramientas de performance](./references/tools.md).

---

## 3. Bottleneck Analysis

Clasificar.

CPU

Memoria

I/O

Network

Database

Rendering

LLM

Cache

Identificar el cuello dominante.

Nunca optimizar varios al mismo tiempo.

---

## 4. Optimization Strategy

Elegir la intervención mínima.

Ejemplos:

Frontend

- memoization
- virtualization
- code splitting
- lazy loading
- image optimization

Backend

- caching
- batching
- streaming
- async
- pooling

Database

- índices
- query rewrite
- eliminar N+1

AI

- prompt compression
- context pruning
- caching
- embeddings
- reranking

---

## 5. Implementation Planning

Definir:

impacto esperado

riesgo

esfuerzo

rollback

No escribir código.

Generar plan.

---

## 6. Verification

Volver a medir.

Comparar contra baseline.

Responder:

¿Realmente mejoró?

¿Cuánto?

¿Hubo regresiones?

---

## 7. Cost / Benefit

Evaluar.

¿Cuánto costó optimizar?

¿Cuánto mejoró?

¿Vale la pena?

Evitar optimizaciones prematuras.

---

## 8. Knowledge Capture

Actualizar:

ADRs (si cambia arquitectura)

CHANGELOG

Performance Notes

Engineering Knowledge

Registrar benchmark antes/después.

---

# Outputs

PERFORMANCE_REPORT.md

Baseline

Perfil de rendimiento

Cuellos de botella

Plan de optimización

Benchmark Before / After

Recomendaciones

---

# Checklist

¿Existe baseline?

¿Existe profiling?

¿Hay evidencia?

¿Se identificó el cuello dominante?

¿La mejora fue medida?

¿Se documentó?

¿Hubo regresiones?

---

# Decisiones

Puede:

✔ medir

✔ perfilar

✔ recomendar optimizaciones

✔ priorizar cuellos de botella

✔ generar benchmarks

Nunca:

✖ optimizar sin métricas

✖ modificar comportamiento funcional

✖ perseguir micro-optimizaciones

✖ sacrificar legibilidad sin justificación

---

# Principios

La medición precede a la optimización.

Optimizar el cuello dominante produce el mayor impacto.

Una mejora no medida es una opinión.

La simplicidad sigue siendo un requisito de rendimiento.

El mejor código es el que no necesita ejecutarse.

## Helper Scripts

Scripts en `skills/performance-optimization/scripts/`:

| Script | Uso |
|---|---|
| `benchmark.sh` | Corre benchmarks automatizados y compara antes/después. Usar en Fase 1 (Baseline) y Fase 7 (Verify). |
| `lighthouse-check.sh <url>` | Corre Lighthouse CI contra una URL y genera reporte. Usar en Fase 2 (Profiling) y Fase 7. |

## Related Skills

- [Observability](../observability): Para medir y monitorear performance
- [Debug Investigation](../debug-investigation): Para investigar causas de degradación
