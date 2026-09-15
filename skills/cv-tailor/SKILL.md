---
name: "cv-tailor"
metadata:
  category: "Career"
  tags:
    - cv
    - resume
    - busqueda-laboral
    - ats
    - star
description: "Optimizar CVs: matching de keywords contra JD, reescritura STAR con datos cuantificados, y verificación de compatibilidad ATS."
user-invocable: false
---

# Workflow: CV Tailor

## Propósito

Optimizar currículums para maximizar el rate de aprobación en procesos de selección. Tres pilares: análisis de keywords contra la descripción del puesto, reescritura de experiencia con método STAR y datos cuantificados, y verificación de compatibilidad con ATS (Applicant Tracking System).

## Filosofía

> Your resume doesn't get you the job. It gets you the interview.

Cada palabra cuenta. Cada número suma. Cada keyword mal ubicada resta.

---

# Cuándo usarlo

- Optimizar CV para una postulación específica
- Analizar cobertura de keywords contra un JD
- Reescribir experiencia laboral con STAR
- Verificar compatibilidad ATS
- Preparar CV para búsqueda activa

---

# Fases

## 1. Input Collection

Recolectar:
- CV actual (texto o archivo)
- JD target (texto o descripción del rol)
- Si no hay JD, preguntar: industria + posición + seniority

## 2. Keyword Match Analysis

Extraer keywords del JD en 3 categorías:

| Categoría | Ejemplos |
|---|---|
| **Hard skills** | Python, SQL, React, A/B testing, Scrum |
| **Soft skills** | Cross-team collaboration, data-driven, project management |
| **Industry/domain** | DAU, conversion rate, SaaS, user growth |

Generar matriz de matching:
- Required keyword coverage ≥ 80% = passing, ≥ 90% = excellent
- Recomendar dónde agregar keywords faltantes

### ⚠️ Checkpoint obligatorio

**Después de Fase 2, PAUSAR.** Presentar al usuario:
- Matriz de cobertura con gaps identificados
- Preguntar: ¿tenés experiencia en [gap 1], [gap 2], [gap 3]?
- Esperar respuesta antes de continuar a Fase 3

No asumir ni inventar. El usuario decide qué gaps puede cubrir y cómo.

## 3. STAR Rewriting

Reescribir cada entrada de experiencia:

| Elemento | Checkpoint |
|---|---|
| **S** Situation | Contexto, escala, cuándo |
| **T** Task | Objetivo, responsabilidad personal |
| **A** Action | Acciones específicas, métodos, herramientas |
| **R** Result | Outcomes cuantificados, datos |

Cada entry rewrite debe:
- [ ] Al menos 1 dato cuantificado
- [ ] Cubrir ≥ 3 de 4 elementos STAR
- [ ] Empezar con verbo de acción (led, built, optimized, drove)
- [ ] Máximo 3 líneas (legibilidad ATS)
- [ ] Incorporar keywords faltantes del Phase 2, según lo confirmado por el usuario

## 4. ATS Compatibility Check

| Check | Standard |
|---|---|
| File format | PDF o DOCX (PDF preferred) |
| Layout | Single-column, standard headings |
| Fonts | Arial, Calibri, Times New Roman |
| Tables | Avoid complex layouts |
| Section titles | "Work Experience", "Education", "Skills" |
| Date format | Consistent (Jan 2023 - Jun 2024) |
| File naming | FirstName_LastName_Role_Resume.pdf |

## 5. Output

- Optimization summary (coverage %, STAR score, ATS score)
- CV reescrito con cambios en **bold**
- Recomendaciones adicionales

---

# Outputs

- Keyword match matrix
- Before/after STAR comparison
- ATS compatibility scorecard
- CV optimizado listo para postular

## Helper Scripts

Scripts en `skills/cv-tailor/scripts/`:

| Script | Uso |
|---|---|
| `keyword-matcher.py <cv.txt> <jd.txt>` | Compara keywords del CV contra la descripción del puesto y genera matriz de cobertura. Usar en Fase 2 (Keyword Match Analysis). |

---

# Principios

- Autenticidad primero: no inventar datos
- Cada cambio debe servir al JD alignment
- Recomendaciones accionables, no genéricas
- Privacidad: recordar redactar datos sensibles

---

## STAR Examples by Role

### Frontend Engineer

**Before:** "Built UI components for the dashboard"
**After:** "Designed and built 12 reusable React components for the analytics dashboard, adopted across 3 product teams, reducing UI development time by 40% and improving Lighthouse accessibility score from 72 to 94."

**Before:** "Responsible for performance improvements"
**After:** "Led frontend performance initiative for a SaaS product (MAU 200K+), implementing code splitting, lazy loading, and image optimization. Reduced LCP from 4.2s to 1.8s and improved Lighthouse Performance score from 55 to 92, directly impacting user retention."

### Fullstack Engineer

**Before:** "Worked on the billing system"
**After:** "Architected and built the complete billing system from scratch (Stripe + Supabase + Edge Functions), handling subscription management, invoicing, and payment reconciliation. Processed $50K+ MRR with 99.9% uptime and zero payment failures in 6 months."

**Before:** "Built APIs and frontend features"
**After:** "Designed and implemented 15 RESTful API endpoints for the user management system (Node.js + PostgreSQL), serving 50K+ daily requests with <100ms p95 latency. Built the corresponding React admin panel, reducing manual user management time by 80%."

### Product / Growth Engineer

**Before:** "Worked on user growth initiatives"
**After:** "During a user growth plateau (DAU 500K+), led activation funnel analysis, identified 3 critical drop-off points, and designed an A/B tested onboarding flow. Increased D1 retention from 32% to 45% and MAU by 18% within 3 months."

**Before:** "Did A/B testing"
**After:** "Designed and executed 20+ A/B experiments on the pricing page, analyzing statistical significance (p<0.05) and user behavior. The winning variant increased trial-to-paid conversion by 22%, adding $15K MRR."

### Accessibility Specialist

**Before:** "Made the app accessible"
**After:** "Conducted a full WCAG 2.1 AA audit of a React SPA (200+ components), identifying and fixing 85 accessibility issues. Implemented automated a11y testing with axe-core in CI, achieving 100% pass rate. Reduced accessibility-related bug reports by 90%."

**Before:** "Worked on accessibility"
**After:** "Led the accessibility remediation of a legacy dashboard used by 10K+ government employees. Upgraded from WCAG 2.0 A to WCAG 2.1 AA compliance, trained 5 developers on ARIA patterns, and established a11y as a gating criterion in code review."

---

# Related Skills

- [Mock Interview Drill](../mock-interview-drill): Para practicar entrevistas post-CV
