---
name: "tech-docs"
metadata:
  category: "Content"
  tags:
    - documentacion
    - adr
    - changelog
description: "Workflow de Technical Documentation: ADRs, README, API docs, CHANGELOG, guías técnicas y diseño arquitectónico."
user-invocable: false
---

# Workflow: Technical Documentation

## Skills que reemplaza
- `adr-framework`
- `adr-sync`

## Propósito
Creación y gestión de documentación técnica de proyectos: ADRs, README, API docs, CHANGELOG, guías de contribución y diseño arquitectónico.

## Fases

### 1. Audiencia
¿Quién lee estos docs? (devs del equipo, contributors externos, usuarios finales, stakeholders)

### 2. Diseño Arquitectónico (pre-ADRs)
Antes de documentar decisiones, diseñar la arquitectura:
- **Diagramas C4/Mermaid** — contexto, contenedores, componentes, código
- **Trade-offs** — evaluar opciones de stack, patrones, base de datos
- **Análisis de dependencias** — salud del proyecto, versiones, compatibilidad
- **Riesgos técnicos** — identificar temprano

### 3. Estructura
Qué docs necesita el proyecto (README, API docs, guías, ADRs, CHANGELOG, CONTRIBUTING).

### 4. ADRs
Crear o sincronizar decisiones arquitecturales con el formato estándar: contexto, decisión, consecuencias, alternativas consideradas.

Referencia de patrones:
- **Hexagonal Architecture** — puertos y adaptadores, dependencias inward
- **Clean Architecture** — capas, reglas de dependencia
- **Domain-Driven Design** — bounded contexts, entidades, value objects

### 5. Redacción técnica
Escribir o actualizar docs con ejemplos concretos, no teoría. Código real, no pseudocódigo.

### 6. Revisión
Coherencia, completitud, ejemplos funcionan, enlaces no rotos, tono consistente.

### 7. Publicación
Commit + push, integración con el proyecto.

## Outputs
- README.md actualizado
- Diagramas C4 de arquitectura
- ADRs en `docs/adr/` (creados o sincronizados)
- CHANGELOG.md actualizado
- API docs, guías técnicas
- CONTRIBUTING.md si aplica

## Cuándo usarlo
- Al arrancar un proyecto nuevo (docs iniciales + diseño)
- Cuando se cambia una API o feature (actualizar docs)
- Al cerrar un epic o milestone (actualizar CHANGELOG + ADRs)
- Cuando se necesita documentar una decisión arquitectónica
- Cuando un contributor necesita guías claras

## Helper Scripts

Scripts en `skills/tech-docs/scripts/`:

| Script | Uso |
|---|---|
| `generate-adr.sh "Titulo de la decision"` | Crea un ADR numerado secuencialmente en `docs/adr/`. Usar en Fase 4. |
| `update-changelog.sh` | Inserta una entrada `[Unreleased]` en CHANGELOG.md. Usar al cerrar un epic o feature. |
| `analyze_codebase.py` | Analiza el codebase para extraer patrones y generar contexto para docs. Usar en Fase 2 (Diseño Arquitectónico) y Fase 5. |

Si se tocan estos scripts, correr `npm test` en el workspace antes de commitear.

## Related Skills

- [Knowledge Management](../knowledge-management): Para mantener la base de conocimiento
- [Build & Scaffold](../build-scaffold): Para documentar decisiones de scaffolding
