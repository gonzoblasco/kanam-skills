---
name: "git-changelog"
description: "Auto-genera CHANGELOG.md desde git history con conventional commits"
---

# git-changelog

## Descripción
Lee el historial de git commits convencionales y produce un changelog categorizado y formateado en markdown, agrupado por tipo (feat, fix, breaking change, etc.). El output está listo para pegar en CHANGELOG.md o en una GitHub release.

## Cuándo usarlo
- Antes de taggear una nueva versión
- Al crear una entrada en CHANGELOG.md después de un sprint
- Para revisar qué cambió entre dos tags de git
- Para detectar breaking changes antes de publicar un paquete
- Para resumir commits recientes en una update de equipo

## Workflow
1. Identificar el rango de commits (entre tags, fechas, o desde el último changelog)
2. Ejecutar git-changelog con el rango especificado
3. Revisar el output y pegarlo en CHANGELOG.md
4. Hacer commit del changelog actualizado

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `tech-docs/scripts/update-changelog.sh` | Inserta una entrada `[Unreleased]` en CHANGELOG.md. |
| `release-management/scripts/generate-release-notes.sh` | Genera notas de release desde commits/tags para GitHub. |
| `release-management/scripts/release-check.sh` | Verifica que CHANGELOG tenga la version antes de taggear. |

## Notas
- Asume que los commits siguen Conventional Commits format
- No requiere API keys externas
- El output es markdown, listo para usar
