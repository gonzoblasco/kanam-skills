---
name: "deepwiki"
description: "Consulta documentación de repos GitHub via DeepWiki MCP"
---

# deepwiki

## Descripción
Accede a documentación de repositorios públicos de GitHub mediante el servidor MCP de DeepWiki. Soporta tres operaciones: preguntas con IA sobre un repo, listar su estructura wiki, y leer páginas específicas. Funciona con cualquier repo público sin autenticación.

## Cuándo usarlo
- Para entender la arquitectura de una librería antes de mandar un PR
- Para verificar si un proyecto documenta una feature específica sin clonar el repo
- Para obtener respuestas sobre API usage basadas en la documentación real del proyecto
- Para explorar la estructura wiki de un codebase open-source no familiar
- Para investigar cómo un framework popular maneja un patrón particular

## Workflow
1. Identificar el repo público a consultar (owner/name)
2. Elegir operación: pregunta, listar wiki, o leer página
3. Ejecutar deepwiki con la operación y el repo
4. Recibir respuesta basada en la documentación real del proyecto

## Tooling relacionado

| Skill / Script | Uso |
|---|---|
| `oss-contribution/scripts/triage-issues.sh` | Encontrar issues en el repo consultado para aplicar lo aprendido. |
| `oss-contribution/scripts/setup-fork.sh` | Preparar fork local si se decide contribuir. |
| `research-spike/scripts/compare-alternatives.sh` | Comparar el framework/documentado contra alternativas. |

## Notas
- Sin autenticación requerida
- Respuestas basadas en documentación real, no en training data
- Útil para OSS contributions (shadcn/ui, TanStack, vercel/ai)
