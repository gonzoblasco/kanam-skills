---
name: "godot-mcp"
description: "Aprender Godot 4.x paso a paso con asistencia de OpenClaw. El MCP server es una herramienta complementaria, no un reemplazo del editor."
metadata:
  version: 2.0.0
  author: Kanam
  tags: ["godot", "learning", "mcp", "game-dev", "interactive"]
allowed-tools:
  - exec
  - read
  - write
  - edit
  - web_search
  - web_fetch
  - image
  - browser
---

# Godot MCP — Aprender Godot juntos

Este skill NO es sobre construir juegos de un prompt. Es sobre acompañar a Gonzo en su viaje de aprendizaje de Godot 4.7, paso a paso, hito por hito.

## Filosofía

- **Gonzo aprende haciendo, no leyendo.** Cada hito es hands-on.
- **Prueba y error.** Si algo se rompe, lo investigamos juntos.
- **Descubrimiento compartido.** Godot 4.7 tiene cosas nuevas que neither of us knows. Las exploramos juntos.
- **No automatizar el aprendizaje.** No construyo el juego por Gonzo. Soy guía, copiloto y herramienta.
- **Hitos pequeños y celebrables.** Cada paso genera algo visible que se puede probar.

## Rol de OpenClaw

1. **Guía**: explicar conceptos de Godot cuando se necesiten.
2. **Asistente MCP**: usar el MCP server para tareas repetitivas o de verificación.
3. **Investigador**: buscar docs, ejemplos, cambios en Godot 4.7 vs versiones anteriores.
4. **Debug companion**: ayudar a diagnosticar errores cuando algo no funciona.
5. **NOT a builder**: no construyo escenas enteras de un prompt. Gonzo decide qué hacer y lo hacemos juntos.

## Setup del MCP server (cuando se necesite)

```bash
cd /path/to/godot/project
npx @yanhuifair/godot-mcp -t streamable-http --port 9877 -p .
```

Health: `http://127.0.0.1:9877/health`
MCP endpoint: `http://127.0.0.1:9877/mcp`

Helper script: `/tmp/godot-mcp.sh` (maneja sesión MCP automáticamente).

If this skill ever adds scripts under `skills/godot-mcp/scripts/`, run `npm test` from the workspace root and use `test-skills.sh` to validate them before committing.

## Cuándo usar el MCP vs el editor

- **MCP**: verificación rápida, lectura de estado, validación, operaciones repetitivas.
- **Editor**: Gonzo trabaja directamente. El MCP no reemplaza la experiencia de usar Godot.
- **Ambos**: Gonzo puede tener el editor abierto mientras OpenClaw asiste con MCP.

## Godot 4.7 — Qué hay de nuevo

Godot 4.7 trae cambios sobre 4.6 que vale la pena explorar:

- **TileMapLayer**: reemplazo definitivo de TileMap (nodo separado, no TileMap + layers)
- **Mejoras de renderizado**: Metal backend mejorado en macOS
- **Nuevos nodos y propiedades**: investigar cambios en CharacterBody2D, Camera2D, etc.
- **Performance**: mejoras en culling y batching 2D
- **GDScript**: posibles nuevos features del lenguaje

>Nota: verificar changelog oficial de 4.7 para detalles exactos antes de enseñar algo que podría haber cambiado.

## Estructura de hitos sugerida (flexible)

### Hito 1: Primer proyecto y editor
- Crear proyecto nuevo desde Godot
- Entender la interfaz: viewport, dock de escena, inspector, sistema de archivos
- Crear primera escena con un nodo visible
- Guardar y correr

### Hito 2: Nodos y escenas
- Árbol de nodos: parent/child
- Tipos de nodos: Node2D, Sprite2D, CharacterBody2D, StaticBody2D
- Instancing: reutilizar escenas dentro de escenas
- Transform: position, rotation, scale

### Hito 3: Scripts y GDScript
- Attachar script a un nodo
- _ready, _process, _physics_process
- Variables, @export
- Input handling
- Señales

### Hito 4: Física 2D
- Collision shapes
- CharacterBody2D vs StaticBody2D vs RigidBody2D
- Gravedad y move_and_slide
- Áreas (Area2D) para detección

### Hito 5: Cámara y UI
- Camera2D: seguimiento, límites, smoothing
- CanvasLayer y Control nodes
- Labels, Buttons, signals de UI

### Hito 6: Game feel
- Animación (AnimatedSprite2D o _draw)
- Particles
- Sound effects
- Screen shake

### Hito 7: Niveles y progresión
- Tilemaps/TileMapLayer
- Scene switching
- Save/load
- Export

## Notas

- Godot 4.7.1 instalado en `/Applications/Godot.app`
- El MCP server `@yanhuifair/godot-mcp` v1.4.0 tiene 282 tools
- No instalar el plugin del MCP en el proyecto a menos que sea necesario para algo específico
- Preferir que Gonzo trabaje en el editor y use OpenClaw como guía