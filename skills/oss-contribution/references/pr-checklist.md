# PR Checklist — OSS Contribution Reference

Checklist para PRs a repositorios externos.

## Pre-PR

- [ ] Fork creado desde el repo original (no clonar directo)
- [ ] Branch con nombre descriptivo: `fix/issue-123`, `feat/add-x`
- [ ] Upstream configurado: `git remote add upstream <original-url>`
- [ ] Sin cambios de formato/whitespace no relacionados
- [ ] Sin cambios a archivos no relacionados
- [ ] Commits firmados con SSH
- [ ] Sin trazas de automatización en commits (repos Tier 0)

## PR Description

```markdown
## Description

[Clear, human description of what this PR does and why]

## Related Issue

Closes #123

## Testing

- [ ] Added tests
- [ ] Existing tests pass
- [ ] Manual testing done

## Screenshots (if applicable)

[Only if UI changes]
```

## Post-PR

- [ ] Responder a comments de maintainers dentro de 24h
- [ ] Si piden cambios, hacerlos rápido
- [ ] Registrar la cadena completa en CONTRIBUTING.md (Issue → PR tercero → nuestro aporte → nuestro PR → contexto)
