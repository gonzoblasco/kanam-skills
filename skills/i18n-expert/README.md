# I18n Expert

Internationalization and localization of UI projects.

## What is it for?

To **configure, audit and maintain internationalization** in web projects. Includes framework setup, replacing hardcoded strings with translatable keys, validating parity between locales, and localizing error messages.

**Philosophy:** Every user deserves the app in their language. Internationalization is not a post-hoc feature, it's an architectural decision.

## When to use it?

- When you start a project that will have multiple languages
- When you want to audit that there are no untranslated strings
- When you need to add a new locale
- When you want to localize error messages (never expose raw error.message)

## How do you use it?

### Full workflow

1. **Scope** - framework, current state, target locales, format
2. **Setup** - install framework (next-intl, react-i18next, vue-i18n)
3. **Audit** - run script to detect missing and orphaned keys
4. **Replacement** - find hardcoded strings and replace with `t('key')`
5. **Error localization** - map codes to localized keys
6. **Validation** - re-run audit until 0 issues
7. **Performance** - lazy-load locale bundles, split large files

### Script

```bash
# Audit parity between locales
python3 scripts/i18n_audit.py --src src/ --locale public/locales/en-US.json --locale public/locales/es-AR.json
```

Reports: missing keys, orphaned keys, parity gap between locales.

## References

| File | What it contains |
|---|---|
| `references/locale-setup.md` | Configuration by framework: next-intl, react-i18next |
| `references/translation-strategy.md` | AI vs professional vs community, pluralization, RTL |

## Related skills

- [Spec-Driven Development](../spec-driven-development) - To include i18n in the initial scaffolding
- [Code Review & Quality](../code-review-and-quality) - To review that there are no hardcoded strings
