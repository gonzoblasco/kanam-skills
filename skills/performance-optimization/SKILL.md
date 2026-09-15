---
name: "performance-optimization"
metadata:
  category: "Workflow"
  tags:
    - performance
    - optimization
    - profiling
description: "Performance Optimization workflow: systematic analysis, profiling and optimization of frontend, backend, database and infrastructure without changing functional behavior."
user-invocable: false
---

# Workflow: Performance Optimization

## Purpose

Improve system performance through evidence, measurement and incremental optimizations.

Does not develop new features.

Does not fix functional bugs.

Does not chase arbitrary metrics.

Its mission is to remove real bottlenecks.

---

# Philosophy

> Measure. Understand. Optimize. Verify.

Never optimize by intuition.

Never sacrifice maintainability for micro-optimizations.

Optimize where there is measurable impact.

---

# When to use it

- Low Lighthouse scores
- high response times
- excessive CPU usage
- excessive memory usage
- slow queries
- large bundles
- degradation after releases
- user growth

---

# Relationship with other workflows

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

# Domains

See [performance domains](./references/domains.md).

---

# Phases

## 1. Baseline

Measure.

Never start by optimizing.

Record:

- times
- usage
- current metrics

Build the baseline.

---

## 2. Profiling

Find bottlenecks. See [performance tools](./references/tools.md).

---

## 3. Bottleneck Analysis

Classify.

CPU

Memory

I/O

Network

Database

Rendering

LLM

Cache

Identify the dominant bottleneck.

Never optimize several at the same time.

---

## 4. Optimization Strategy

Choose the minimal intervention.

Examples:

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

- indexes
- query rewrite
- eliminate N+1

AI

- prompt compression
- context pruning
- caching
- embeddings
- reranking

---

## 5. Implementation Planning

Define:

expected impact

risk

effort

rollback

Do not write code.

Generate a plan.

---

## 6. Verification

Measure again.

Compare against baseline.

Answer:

Did it really improve?

By how much?

Were there regressions?

---

## 7. Cost / Benefit

Evaluate.

How much did optimizing cost?

How much did it improve?

Is it worth it?

Avoid premature optimizations.

---

## 8. Knowledge Capture

Update:

ADRs (if architecture changes)

CHANGELOG

Performance Notes

Engineering Knowledge

Record the before/after benchmark.

---

# Outputs

PERFORMANCE_REPORT.md

Baseline

Performance profile

Bottlenecks

Optimization plan

Before / After Benchmark

Recommendations

---

# Checklist

Is there a baseline?

Is there profiling?

Is there evidence?

Was the dominant bottleneck identified?

Was the improvement measured?

Was it documented?

Were there regressions?

---

# Decisions

May:

✔ measure

✔ profile

✔ recommend optimizations

✔ prioritize bottlenecks

✔ generate benchmarks

Never:

✖ optimize without metrics

✖ modify functional behavior

✖ chase micro-optimizations

✖ sacrifice readability without justification

---

# Principles

Measurement precedes optimization.

Optimizing the dominant bottleneck produces the greatest impact.

An unmeasured improvement is an opinion.

Simplicity is still a performance requirement.

The best code is the code that does not need to run.

## Helper Scripts

Scripts in `skills/performance-optimization/scripts/`:

| Script | Usage |
|---|---|
| `benchmark.sh` | Runs automated benchmarks and compares before/after. Use in Phase 1 (Baseline) and Phase 7 (Verify). |
| `lighthouse-check.sh <url>` | Runs Lighthouse CI against a URL and generates a report. Use in Phase 2 (Profiling) and Phase 7. |

## Related Skills

- [Observability](../observability-and-instrumentation): To measure and monitor performance
- [Debug Investigation](../debugging-and-error-recovery): To investigate causes of degradation
