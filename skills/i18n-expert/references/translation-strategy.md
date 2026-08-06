# Translation Strategy — I18n Expert Reference

Estrategias para generar y mantener traducciones.

## Quality Tiers

| Tier | Method | Cost | Quality | Use Case |
|---|---|---|---|---|
| **AI** | LLM translation | $0 | Good | MVP, internal tools |
| **Professional** | Human translator | $$ | Excellent | Production, customer-facing |
| **Community** | Crowdsourcing | $ | Variable | Open source |
| **Hybrid** | AI + human review | $ | Very good | Most projects |

## Pluralization Rules

```json
{
  "items": {
    "one": "{{count}} item",
    "other": "{{count}} items"
  }
}
```

```typescript
t('items', { count: items.length });
```

## Date/Time/Number Formatting

```typescript
// Use Intl API, not manual formatting
new Intl.DateTimeFormat('es-AR', {
  dateStyle: 'long',
  timeStyle: 'short',
}).format(new Date());

new Intl.NumberFormat('es-AR', {
  style: 'currency',
  currency: 'ARS',
}).format(amount);
```

## RTL Support

- Usar propiedades CSS lógicas (`margin-inline-start` en vez de `margin-left`)
- Testear layout con texto en árabe/hebreo
- El framework de i18n debe soportar `direction` por locale

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
- [Locale Setup](./locale-setup.md) — Configuración por framework
