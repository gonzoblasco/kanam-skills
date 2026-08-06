---
name: "i18n-expert"
metadata:
  category: "Workflow"
  tags:
    - i18n
    - localizacion
    - internacionalizacion
description: "Workflow de internacionalización y localización: setup, auditoría, reemplazo de strings y validación de paridad de locales."
user-invocable: false
---

# Workflow: I18n Expert

## Propósito

Configurar, auditar y mantener la internacionalización (i18n) y localización (l10n) en proyectos UI. Incluye setup del framework, reemplazo de strings hardcodeadas, validación de paridad entre locales y manejo de plurales, formatos y RTL.

## Filosofía

> Every user deserves the app in their language.

La internacionalización no es un feature post-hoc. Es una decisión arquitectónica que se toma al inicio.

---

# Cuándo usarlo

- Configurar i18n en un proyecto nuevo
- Reemplazar strings hardcodeadas por claves traducibles
- Auditar paridad entre locales (claves faltantes, keys huérfanas)
- Agregar un nuevo locale
- Localizar mensajes de error (nunca exponer raw error.message)
- Configurar routing con detección de idioma

---

# Fases

## 1. Scope

Confirmar:

- Framework y routing
- Estado actual de i18n (none, partial, legacy)
- Locales target (default: en-US + es-AR)
- Necesidad de traducción (AI, professional, manual)
- Formato de locales (JSON, YAML, PO, XLIFF)
- Requerimientos de formalidad cultural

## 2. Setup

Elegir e instalar framework:

| Framework | Librería recomendada |
|---|---|
| Next.js App Router | `next-intl` |
| Next.js Pages Router | `next-i18next` |
| React (Vite, CRA) | `react-i18next` |
| Vue | `vue-i18n` |

Wire provider, cargar recursos, agregar language switcher.

## 3. Auditoría

Ejecutar script de auditoría para detectar:

- Claves faltantes en algún locale
- Keys huérfanas (existen en archivo pero no se usan)
- Strings hardcodeadas sin traducir
- Problemas de pluralización

```bash
python3 scripts/i18n_audit.py --src src/ --locale public/locales/en-US.json --locale public/locales/es-AR.json
```

## 4. Reemplazo

Buscar y reemplazar strings hardcodeadas:

```bash
# Buscar texto visible en JSX
rg -n --glob 'src/**/*.{ts,tsx}' '<[^>]+>[^<{]*[A-Za-z][^<{]*<'

# Buscar aria-labels, titles, placeholders
rg -n --glob 'src/**/*.{ts,tsx}' 'aria-label="[^"]+"|title="[^"]+"|placeholder="[^"]+"'
```

Reemplazar con `t('namespace.key')`.

## 5. Localización de Errores

- Mapear códigos de error a claves localizadas
- Mostrar solo strings localizados en UI
- Loggear raw error details solo en backend
- Proveer fallback localizado para códigos desconocidos

## 6. Validación

- Re-ejecutar auditoría hasta 0 issues
- Validar JSON: `python3 -m json.tool <file>`
- Actualizar tests que afirman texto visible
- Verificar plurales y formatos en todos los locales

## 7. Performance

- Lazy-load locale bundles
- Split archivos grandes por namespace
- Cachear recursos de idioma

---

# Outputs

- i18n config/provider wiring
- Locale files para cada idioma target
- Strings reemplazadas con claves estables
- Language switcher con persistencia
- Tests actualizados para texto localizado
- Reporte de auditoría de paridad

---

# Principios

- Nunca exponer raw `error.message` en UI
- Preferir namespaces estructurados (`errors.*`, `buttons.*`, `workspace.*`)
- Términos técnicos/marca pueden quedar sin traducir (product name, API, MCP)
- Mantener traducciones concisas y consistentes
- La clave es estable aunque el texto cambie

## Helper Scripts

Scripts en `skills/i18n-expert/scripts/`:

| Script | Uso |
|---|---|
| `i18n_audit.py --src src/ --locale path/to/en.json --locale path/to/es.json` | Detecta claves faltantes, keys huérfanas, strings hardcodeadas y problemas de pluralización. Usar en Fase 3 (Auditoría) y Fase 6 (Validación). |

---

# Related Skills

- [Build & Scaffold](../build-scaffold): Para incluir i18n en el scaffolding inicial
- [Review & Quality](../review-quality): Para revisar que no haya strings hardcodeadas
