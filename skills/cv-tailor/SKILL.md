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

> Tu CV no consigue el trabajo. Consigue la entrevista.

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

## 1. Recopilación de inputs

Recolectar:
- CV actual (texto o archivo)
- JD target (texto o descripción del rol)
- Si no hay JD, preguntar: industria + posición + seniority

## 2. Análisis de matching de keywords

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

**Después de la Fase 2, PAUSAR.** Presentar al usuario:
- Matriz de cobertura con gaps identificados
- Preguntar: ¿tenés experiencia en [gap 1], [gap 2], [gap 3]?
- Esperar respuesta antes de continuar a la Fase 3

No asumir ni inventar. El usuario decide qué gaps puede cubrir y cómo.

## 3. Reescritura STAR

Reescribir cada entrada de experiencia:

| Elemento | Checkpoint |
|---|---|
| **S** Situation | Contexto, escala, cuándo |
| **T** Task | Objetivo, responsabilidad personal |
| **A** Action | Acciones específicas, métodos, herramientas |
| **R** Result | Outcomes cuantificados, datos |

Cada rewrite de entry debe:
- [ ] Al menos 1 dato cuantificado
- [ ] Cubrir ≥ 3 de 4 elementos STAR
- [ ] Empezar con verbo de acción (led, built, optimized, drove)
- [ ] Máximo 3 líneas (legibilidad ATS)
- [ ] Incorporar keywords faltantes de la Fase 2, según lo confirmado por el usuario

## 4. Verificación de compatibilidad ATS

| Check | Estándar |
|---|---|
| Formato de archivo | PDF o DOCX (PDF preferred) |
| Layout | Una sola columna, headings estándar |
| Fuentes | Arial, Calibri, Times New Roman |
| Tablas | Evitar layouts complejos |
| Títulos de sección | "Work Experience", "Education", "Skills" |
| Formato de fechas | Consistente (Jan 2023 – Jun 2024) |
| Nombre de archivo | FirstName_LastName_Role_Resume.pdf |

## 5. Output

- Optimization summary (coverage %, STAR score, ATS score)
- CV reescrito con cambios en **bold**
- Recomendaciones adicionales

---

# Outputs

- Keyword match matrix
- Comparación STAR antes/después
- Scorecard de compatibilidad ATS
- CV optimizado listo para postular

## Scripts auxiliares

Scripts en `skills/cv-tailor/scripts/`:

| Script | Uso |
|---|---|
| `keyword-matcher.py <cv.txt> <jd.txt>` | Compara keywords del CV contra la descripción del puesto y genera matriz de cobertura. Usar en la Fase 2 (Keyword Match Analysis). |

---

# Principios

- Autenticidad primero: no inventar datos
- Cada cambio debe servir al JD alignment
- Recomendaciones accionables, no genéricas
- Privacidad: recordar redactar datos sensibles

---

## Ejemplos STAR por rol

### Frontend Engineer

**Antes:** "Construí componentes de UI para el dashboard"
**Después:** "Diseñé y construí 12 componentes React reutilizables para el dashboard de analytics, adoptados en 3 equipos de producto, reduciendo el tiempo de desarrollo de UI en 40% y mejorando el score de accesibilidad de Lighthouse de 72 a 94."

**Antes:** "Responsable de mejoras de performance"
**Después:** "Lideré la iniciativa de performance del frontend de un producto SaaS (MAU 200K+), implementando code splitting, lazy loading y optimización de imágenes. Reduje el LCP de 4.2s a 1.8s y mejoré el score de Performance de Lighthouse de 55 a 92, impactando directamente en la retención de usuarios."

### Fullstack Engineer

**Antes:** "Trabajé en el sistema de billing"
**Después:** "Arquitecté y construí desde cero el sistema completo de billing (Stripe + Supabase + Edge Functions), manejando gestión de suscripciones, facturación y conciliación de pagos. Procesé $50K+ MRR con 99.9% de uptime y cero fallos de pago en 6 meses."

**Antes:** "Construí APIs y features de frontend"
**Después:** "Diseñé e implementé 15 endpoints RESTful de API para el sistema de gestión de usuarios (Node.js + PostgreSQL), sirviendo 50K+ requests diarios con <100ms de latencia p95. Construí el panel de admin en React correspondiente, reduciendo el tiempo de gestión manual de usuarios en 80%."

### Product / Growth Engineer

**Antes:** "Trabajé en iniciativas de crecimiento de usuarios"
**Después:** "Durante una meseta de crecimiento de usuarios (DAU 500K+), lideré el análisis del funnel de activación, identifiqué 3 puntos críticos de abandono y diseñé un flujo de onboarding testeado con A/B. Incrementé la retención D1 de 32% a 45% y el MAU en 18% en 3 meses."

**Antes:** "Hice A/B testing"
**Después:** "Diseñé y ejecuté 20+ experimentos A/B en la página de precios, analizando significancia estadística (p<0.05) y comportamiento de usuarios. La variante ganadora incrementó la conversión de trial a pago en 22%, sumando $15K MRR."

### Accessibility Specialist

**Antes:** "Hice la app accesible"
**Después:** "Conduje una auditoría completa de WCAG 2.1 AA de una SPA de React (200+ componentes), identificando y arreglando 85 problemas de accesibilidad. Implementé testing automatizado de a11y con axe-core en CI, logrando 100% de pass rate. Reduje los reportes de bugs relacionados con accesibilidad en 90%."

**Antes:** "Trabajé en accesibilidad"
**Después:** "Lideré la remediación de accesibilidad de un dashboard legacy usado por 10K+ empleados del gobierno. Subí de cumplimiento WCAG 2.0 A a WCAG 2.1 AA, entrené a 5 developers en patrones ARIA y establecí a11y como criterio de gating en code review."

---

# Skills relacionadas

- [Mock Interview Drill](../mock-interview-drill): Para practicar entrevistas post-CV
- [Narrative Content](../narrative-content): Para contar tu historia profesional
