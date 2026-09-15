# Translation Strategy - I18n Expert Reference

Strategies for generating and maintaining translations.

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

- Use logical CSS properties (`margin-inline-start` instead of `margin-left`)
- Test layout with Arabic/Hebrew text
- The i18n framework must support `direction` per locale

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Locale Setup](./locale-setup.md) - Configuration by framework
