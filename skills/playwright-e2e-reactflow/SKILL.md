---
name: "playwright-e2e-reactflow"
description: "Playwright E2E specs for React Flow editors. Use when node selection, drag connections, or role locators fail in E2E."
---

# Playwright E2E for React Flow editors

## Overview

E2E specs against React Flow editors fail in predictable ways: programmatic state changes do not drive React Flow's internal selection, the controls overlay intercepts drags, and aria-label collisions break role locators. Apply these patterns before running the suite.

## Steps

1. **Discover the E2E setup first.** Read `playwright.config.ts` (baseURL, webServer command, testDir) and one existing spec to copy conventions (locators, waits, download handling). Run the new spec alone before the full suite.

2. **Select nodes by clicking the canvas node, not by programmatic creation.** Adding a node via the toolbar does not change React Flow's selection, so the node inspector (`#node-title`) stays closed. After each add, click the node: `page.locator('.react-flow__node').nth(i).click()`, then assert `#node-title` has the default value before filling a distinct title.

3. **Use `force: true` on handle drags.** Nodes placed in cascade can land under the React Flow controls overlay (bottom-right), which intercepts pointer events and makes `dragTo` retry forever. Pass `{ force: true }` to `dragTo` for source-to-target handle connections.

4. **Resolve aria-label collisions by element id.** When a section's `aria-label` equals a label's text (for example the same phrase on both the section and the select), `getByLabel` throws a strict mode violation. Locate the control by id (`#character-select`) instead.

5. **Keep AI-dependent flows deterministic.** E2E must not call AI endpoints: verify panel UI exists (inputs, buttons, selectors) without sending messages. For one real integration smoke, POST the minimal valid payload and `test.skip(!ollamaUp, ...)` after probing the model server's health endpoint with a short timeout.

6. **Verify the full gate before finishing.** New spec green, then full `npx playwright test`, `npm test`, `npx tsc --noEmit`, `npm run lint`, `npm run build`.
