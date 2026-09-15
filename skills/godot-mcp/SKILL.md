---
name: "godot-mcp"
description: "Learn Godot 4.x step by step with OpenClaw assistance. The MCP server is a complementary tool, not a replacement for the editor."
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

# Godot MCP - Learning Godot together

This skill is NOT about building games from a single prompt. It is about accompanying the user on his journey of learning Godot 4.7, step by step, milestone by milestone.

## Philosophy

- **the user learns by doing, not by reading.** Every milestone is hands-on.
- **Trial and error.** If something breaks, we investigate it together.
- **Shared discovery.** Godot 4.7 has new things that neither of us knows. We explore them together.
- **Do not automate learning.** I do not build the game for the user. I am a guide, a copilot and a tool.
- **Small, celebrateable milestones.** Every step produces something visible that can be tested.

## OpenClaw's role

1. **Guide**: explain Godot concepts when they are needed.
2. **MCP assistant**: use the MCP server for repetitive or verification tasks.
3. **Researcher**: look up docs, examples, and changes in Godot 4.7 vs earlier versions.
4. **Debug companion**: help diagnose errors when something does not work.
5. **NOT a builder**: I do not build entire scenes from a prompt. the user decides what to do and we do it together.

## MCP server setup (when needed)

```bash
cd /path/to/godot/project
npx @yanhuifair/godot-mcp -t streamable-http --port 9877 -p .
```

Health: `http://127.0.0.1:9877/health`
MCP endpoint: `http://127.0.0.1:9877/mcp`

Helper script: `/tmp/godot-mcp.sh` (handles the MCP session automatically).

If this skill ever adds scripts under `skills/godot-mcp/scripts/`, run `npm test` from the workspace root and use `test-skills.sh` to validate them before committing.

## When to use MCP vs the editor

- **MCP**: quick verification, reading state, validation, repetitive operations.
- **Editor**: the user works directly. MCP does not replace the experience of using Godot.
- **Both**: the user can have the editor open while OpenClaw assists through MCP.

## Godot 4.7 - What's new

Godot 4.7 brings changes over 4.6 worth exploring:

- **TileMapLayer**: final replacement for TileMap (a separate node, not TileMap + layers)
- **Rendering improvements**: improved Metal backend on macOS
- **New nodes and properties**: look into changes in CharacterBody2D, Camera2D, etc.
- **Performance**: improvements in 2D culling and batching
- **GDScript**: possible new language features

>Note: check the official 4.7 changelog for exact details before teaching something that may have changed.

## Suggested milestone structure (flexible)

### Milestone 1: First project and editor
- Create a new project from Godot
- Understand the interface: viewport, scene dock, inspector, file system
- Create a first scene with a visible node
- Save and run

### Milestone 2: Nodes and scenes
- Node tree: parent/child
- Node types: Node2D, Sprite2D, CharacterBody2D, StaticBody2D
- Instancing: reusing scenes inside scenes
- Transform: position, rotation, scale

### Milestone 3: Scripts and GDScript
- Attach a script to a node
- _ready, _process, _physics_process
- Variables, @export
- Input handling
- Signals

### Milestone 4: 2D physics
- Collision shapes
- CharacterBody2D vs StaticBody2D vs RigidBody2D
- Gravity and move_and_slide
- Areas (Area2D) for detection

### Milestone 5: Camera and UI
- Camera2D: follow, limits, smoothing
- CanvasLayer and Control nodes
- Labels, Buttons, UI signals

### Milestone 6: Game feel
- Animation (AnimatedSprite2D or _draw)
- Particles
- Sound effects
- Screen shake

### Milestone 7: Levels and progression
- Tilemaps/TileMapLayer
- Scene switching
- Save/load
- Export

## Notes

- Godot 4.7.1 installed at `/Applications/Godot.app`
- The `@yanhuifair/godot-mcp` v1.4.0 MCP server has 282 tools
- Do not install the MCP plugin in the project unless it is needed for something specific
- Prefer the user working in the editor and using OpenClaw as a guide
