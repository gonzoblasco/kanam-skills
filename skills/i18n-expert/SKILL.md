---
name: "i18n-expert"
metadata:
  category: "Workflow"
  tags:
    - i18n
    - localization
    - internationalization
description: "Internationalization and localization workflow: setup, audit, string replacement and locale parity validation."
user-invocable: false
---

# Workflow: I18n Expert

## Purpose

Configure, audit and maintain internationalization (i18n) and localization (l10n) in UI projects. Includes framework setup, replacing hardcoded strings, validating parity between locales and handling plurals, formats and RTL.

## Philosophy

> Every user deserves the app in their language.

Internationalization is not a post-hoc feature. It's an architectural decision made at the start.

---

# When to use it

- Configure i18n in a new project
- Replace hardcoded strings with translatable keys
- Audit parity between locales (missing keys, orphaned keys)
- Add a new locale
- Localize error messages (never expose raw error.message)
- Configure routing with language detection

---

# Phases

## 1. Scope

Confirm:

- Framework and routing
- Current i18n state (none, partial, legacy)
- Target locales (default: en-US + es-AR)
- Translation need (AI, professional, manual)
- Locale format (JSON, YAML, PO, XLIFF)
- Cultural formality requirements

## 2. Setup

Choose and install framework:

| Framework | Recommended library |
|---|---|
| Next.js App Router | `next-intl` |
| Next.js Pages Router | `next-i18next` |
| React (Vite, CRA) | `react-i18next` |
| Vue | `vue-i18n` |

Wire provider, load resources, add language switcher.

## 3. Audit

Run the audit script to detect:

- Missing keys in any locale
- Orphaned keys (they exist in the file but are not used)
- Hardcoded strings without translation
- Pluralization problems

```bash
python3 scripts/i18n_audit.py --src src/ --locale public/locales/en-US.json --locale public/locales/es-AR.json
```

## 4. Replacement

Find and replace hardcoded strings:

```bash
# Find visible text in JSX
rg -n --glob 'src/**/*.{ts,tsx}' '<[^>]+>[^<{]*[A-Za-z][^<{]*<'

# Find aria-labels, titles, placeholders
rg -n --glob 'src/**/*.{ts,tsx}' 'aria-label="[^"]+"|title="[^"]+"|placeholder="[^"]+"'
```

Replace with `t('namespace.key')`.

## 5. Error Localization

- Map error codes to localized keys
- Show only localized strings in UI
- Log raw error details only in backend
- Provide localized fallback for unknown codes

## 6. Validation

- Re-run audit until 0 issues
- Validate JSON: `python3 -m json.tool <file>`
- Update tests that assert visible text
- Verify plurals and formats in all locales

## 7. Performance

- Lazy-load locale bundles
- Split large files by namespace
- Cache language resources

---

# Outputs

- i18n config/provider wiring
- Locale files for each target language
- Strings replaced with stable keys
- Language switcher with persistence
- Tests updated for localized text
- Parity audit report

---

# Principles

- Never expose raw `error.message` in UI
- Prefer structured namespaces (`errors.*`, `buttons.*`, `workspace.*`)
- Technical/brand terms can stay untranslated (product name, API, MCP)
- Keep translations concise and consistent
- The key is stable even if the text changes

## Helper Scripts

Scripts in `skills/i18n-expert/scripts/`:

| Script | Use |
|---|---|
| `i18n_audit.py --src src/ --locale path/to/en.json --locale path/to/es.json` | Detects missing keys, orphaned keys, hardcoded strings and pluralization problems. Use in Phase 3 (Audit) and Phase 6 (Validation). |

---

# Related Skills

- [Review & Quality](../code-review-and-quality): To review that there are no hardcoded strings
