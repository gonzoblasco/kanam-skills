---
name: "shortcuts-generator"
description: "Genera Shortcuts de Apple válidos desde lenguaje natural"
---

# shortcuts-generator

## Descripción
Genera archivos .shortcut plist válidos para la app Shortcuts de Apple en macOS e iOS. Cubre 1,155 acciones incluyendo control flow, variables references, y app integrations. Output firmado listo para importar directamente en Shortcuts.

## Cuándo usarlo
- Para automatizar una rutina matutina (clima + notificación)
- Para procesar fotos en batch con filtros condicionales
- Para encadenar URL fetches y llamadas a modelos de IA en un solo shortcut
- Para construir automatizaciones de macOS activadas por teclado
- Para crear shortcuts reusables con menús y loops

## Workflow
1. Describir en lenguaje natural la automatización deseada
2. shortcuts-generator produce el archivo .shortcut
3. El archivo se guarda en el directorio de salida
4. Hacer doble clic en el archivo para importarlo a Shortcuts.app
5. El shortcut está listo para usar

## Notas
- No requiere API keys externas
- El output es un archivo plist firmado, listo para importar
- Cubre acciones nativas de Apple y de apps de terceros via AppIntents
