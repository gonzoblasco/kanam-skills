# I18n Expert

Internacionalización y localización de proyectos UI.

## ¿Para qué sirve?

Para **configurar, auditar y mantener la internacionalización** en proyectos web. Incluye setup del framework de i18n, reemplazo de strings hardcodeadas por claves traducibles, validación de paridad entre locales, y localización de mensajes de error.

**Filosofía:** Every user deserves the app in their language. La internacionalización no es un feature post-hoc, es una decisión arquitectónica.

## ¿Cuándo usarlo?

- Cuando arrancás un proyecto que va a tener múltiples idiomas
- Cuando querés auditar que no haya strings sin traducir
- Cuando necesitás agregar un nuevo locale
- Cuando querés localizar mensajes de error (nunca exponer raw error.message)

## ¿Cómo se usa?

### Workflow completo

1. **Scope** — framework, estado actual, locales target, formato
2. **Setup** — instalar framework (next-intl, react-i18next, vue-i18n)
3. **Auditoría** — ejecutar script para detectar keys faltantes y huérfanas
4. **Reemplazo** — buscar strings hardcodeadas y reemplazar con `t('key')`
5. **Localización de errores** — mapear códigos a claves localizadas
6. **Validación** — re-ejecutar auditoría hasta 0 issues
7. **Performance** — lazy-load locale bundles, split archivos grandes

### Script

```bash
# Auditar paridad entre locales
python3 scripts/i18n_audit.py --src src/ --locale public/locales/en-US.json --locale public/locales/es-AR.json
```

Reporta: keys faltantes, keys huérfanas, brecha de paridad entre locales.

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/locale-setup.md` | Configuración por framework: next-intl, react-i18next |
| `references/translation-strategy.md` | AI vs professional vs community, pluralización, RTL |

## Skills relacionadas

- [Build & Scaffold](../build-scaffold) — Para incluir i18n en el scaffolding inicial
- [Review & Quality](../review-quality) — Para revisar que no haya strings hardcodeadas
