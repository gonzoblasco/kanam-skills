---
name: "shortcuts-generator"
description: "Generates valid Apple Shortcuts from natural language"
---

# shortcuts-generator

## Description
Generates valid .shortcut plist files for the Apple Shortcuts app on macOS and iOS. Covers 1,155 actions including control flow, variable references, and app integrations. Signed output ready to import directly into Shortcuts.

## When to use it
- To automate a morning routine (weather + notification)
- To process photos in batch with conditional filters
- To chain URL fetches and AI model calls in a single shortcut
- To build keyboard-triggered macOS automations
- To create reusable shortcuts with menus and loops

## Workflow
1. Describe the desired automation in natural language
2. shortcuts-generator produces the .shortcut file
3. The file is saved to the output directory
4. Double-click the file to import it into Shortcuts.app
5. The shortcut is ready to use

## Notes
- No external API keys required
- The output is a signed plist file, ready to import
- Covers native Apple actions and third-party apps via AppIntents
