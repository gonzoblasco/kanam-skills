# Audit Checklist de Workflows — Referencia

## Responsabilidad Única

- [ ] ¿El workflow hace una sola cosa?
- [ ] ¿Su nombre refleja exactamente lo que hace?
- [ ] ¿Hay responsabilidades mezcladas?
- [ ] ¿Depende de otro workflow para algo que debería hacer solo?

## Duplicación

- [ ] ¿Hay checklists repetidos en múltiples workflows?
- [ ] ¿Hay fases idénticas en diferentes workflows?
- [ ] ¿Hay prompts similares que deberían unificarse?
- [ ] ¿Hay validaciones duplicadas?

## Actualización

- [ ] ¿El SKILL.md refleja la práctica actual?
- [ ] ¿Las referencias están actualizadas?
- [ ] ¿Los templates siguen siendo válidos?
- [ ] ¿Los principios que referencia siguen vigentes?

## Engineering Principles

- [ ] ¿Respeta los principios de ingeniería del OS?
- [ ] ¿Hay contradicciones con otros workflows?
- [ ] ¿Promueve buenas prácticas?
- [ ] ¿Desalienta malas prácticas?

## Tamaño

- [ ] ¿Es demasiado largo? (>300 líneas → considerar split)
- [ ] ¿Es demasiado corto? (<30 líneas → ¿realmente es un workflow?)
- [ ] ¿Tiene contenido referencial que debería estar en `references/`?

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
