# Technical Documentation

Documentación técnica: ADRs, diagramas, CHANGELOG.

## ¿Para qué sirve?

Para **crear y gestionar documentación técnica** de proyectos: ADRs (Architecture Decision Records), README, API docs, CHANGELOG, guías de contribución y diagramas de arquitectura C4 con Mermaid.

## ¿Cuándo usarlo?

- Al arrancar un proyecto nuevo (docs iniciales + diseño)
- Cuando cambiás una API o feature (actualizar docs)
- Al cerrar un epic o milestone (CHANGELOG + ADRs)
- Cuando necesitás documentar una decisión arquitectónica

## ¿Cómo se usa?

### Workflow completo

1. **Audiencia** - ¿quién lee estos docs?
2. **Diseño Arquitectónico** - diagramas C4, trade-offs, dependencias, riesgos
3. **Estructura** - qué docs necesita el proyecto
4. **ADRs** - crear o sincronizar decisiones arquitecturales
5. **Redacción técnica** - ejemplos concretos, código real
6. **Revisión** - coherencia, completitud, enlaces no rotos
7. **Publicación** - commit + push

### Scripts útiles

```bash
# Crear nuevo ADR
./scripts/generate-adr.sh --title "Usar Supabase para backend" --status proposed

# Agregar entrada al CHANGELOG
./scripts/update-changelog.sh --type added --message "Login con Google"

# Generar diagramas desde el código
python3 scripts/analyze_codebase.py ./src --type architecture
```

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/adr-patterns.md` | Template ADR, patrones comunes, ciclo de vida |
| `references/architecture-diagrams.md` | C4 model con Mermaid: context, containers, components |
| `references/changelog-guide.md` | Formato Keep a Changelog, cuándo actualizar |

## Skills relacionadas

- [Knowledge Management](../knowledge-management) - Para mantener la base de conocimiento
- [Build & Scaffold](../build-scaffold) - Para documentar decisiones de scaffolding
