---
name: "mcp-orchestrator"
description: "Re-propuesta del skill mcp-orchestrator (la anterior quedo stale)"
metadata:
  version: 1.0.0
  author: Kanam
  tags: [mcp, integration, orchestration, evaluation]
  user-invocable: true
---

# MCP Orchestrator

Central skill for managing MCP servers as discoverable infrastructure. Decides whether to install an external MCP, absorb its idea into a native OpenClaw skill, or discard it.

## When to use

- Someone shares an MCP server, awesome list, or MCPMarket plugin.
- Need to compare multiple MCP servers for the same task.
- Want to wrap an MCP server in a local helper script (stdio, SSE, Streamable HTTP).
- Need to combine multiple MCP servers into a single workflow.
- Evaluating whether an external tool should become a native skill.

## Principles

1. Prefer native OpenClaw skills over fragile/paid/redundant MCP servers.
2. Absorb good ideas from external tools into native skills instead of installing dependencies.
3. Store all API keys and tokens outside the workspace in `~/.openclaw/secrets/`.
4. Never install a server that requires personal account risk (WhatsApp, Instagram, personal email) without explicit approval.
5. Favor servers that are: open source, actively maintained, free tier actually works, local-first, no OAuth maze.

## Workflow: evaluate one MCP server

1. Fetch README and package info. Use `web_fetch` or `web_search`.
2. Score against checklist:
   - Does OpenClaw already have native coverage? (browser, web_search, db_query, etc.)
   - Is it open source and maintained? (last commit, issues, stars)
   - Does the free tier actually work? (test if needed)
   - Does it require personal credentials or paid service?
   - Is it stable enough to rely on? (stdio/SSE/HTTP, error handling)
   - Is it redundant with an existing skill?
3. Decide:
   - **Install**: run the server, wrap it in `scripts/<server>-mcp.py` or `.sh`, verify `tools/list`.
   - **Absorb**: capture the useful idea in an existing or new skill proposal via `skill_workshop`.
   - **Discard**: document reason in daily notes and move on.
4. If installing, store wrapper under `skills/<skill>/scripts/`, never store secrets in code.
5. If absorbing, create or update a `skill_workshop` proposal immediately.
6. Log decision in `memory/YYYY-MM-DD.md`.

## Workflow: evaluate an awesome list or MCPMarket collection

1. Fetch full list. Save as markdown artifact if large.
2. Categorize entries (DB, web, social, dev tools, multimedia, cloud, etc.).
3. For each entry, run the single-server checklist quickly.
4. Produce triage table: install / absorb / discard / standby.
5. Surface top candidates and ideas to absorb.
6. Register backlog items in SQLite `backlog` table for follow-up skills.

## Workflow: wrap an MCP server

1. Identify transport: stdio, SSE, or Streamable HTTP.
2. For stdio servers (most Node/Python MCPs):
   - Create `scripts/<server>-mcp.py` Python wrapper that performs full MCP initialize handshake.
   - Support subcommands `list` and `call <tool> [args]`.
   - Read token from `~/.openclaw/secrets/<name>` if needed.
   - Example pattern: `skills/github/scripts/github-mcp.py`.
3. For HTTP servers:
   - Create `scripts/<server>-mcp.sh` or Python helper that manages session and posts JSON-RPC.
   - Example pattern: `/tmp/godot-mcp.sh`.
4. Test with `tools/list` and one tool call before considering it working.

## Workflow: orchestrate multiple MCPs

1. Define the task and the MCPs involved.
2. Use wrapper scripts as deterministic step boundaries.
3. Chain outputs: one MCP's result becomes the next MCP's input.
4. Keep intermediate outputs in `/tmp/` or `memory/` artifacts for inspection.
5. Add error handling: if an MCP call fails, stop and report.
6. Document the orchestration recipe in the relevant project `.knowledge/` or skill `references/`.

## Helpers

- `scripts/discover-mcp.py`: Search awesome lists and MCPMarket for MCP servers matching a query.
- `scripts/evaluate-mcp.py`: Score a candidate against the checklist and return install/absorb/discard/standby.
- `scripts/wrap-stdio-mcp.py`: Generate a stdio MCP wrapper from server command and optional secret name.
- `scripts/wrap-http-mcp.py`: Generate an HTTP MCP wrapper for SSE/Streamable endpoints.

If you modify any of these scripts, run `npm test` from the workspace root before committing.

## Safety rules

- Do not execute arbitrary install commands from external READMEs without inspecting them.
- Prefer `npx -y <package>` or `pip install --user` over global installs when testing.
- Never paste API keys into chat, workspace files, or Git commits.
- If a server wants OAuth, browser login, or QR scan, pause and ask the user.
- If a server sends messages, posts public content, or accesses personal accounts, ask first.

## Common decisions

- Web search / fetch / browser automation → use native OpenClaw tools, discard external MCPs.
- Database access → prefer `db_query`/`db_execute` and project-specific skills like `supabase-assistant`.
- Image generation → use native `image-generation` skill (OpenAI/Gemini).
- UI components / shadcn → use native `ui-generation` skill.
- Design research / visual review → use native `design-orchestrator` skill.
- Agent workflow / multi-agent → use native `agent-workflow` skill.
- Godot game dev → use native `godot-mcp` skill with `yanhuifair/godot-mcp`.
- GitHub → use native `github` skill with optional `github-mcp.py` wrapper.

## Backlog integration

After evaluation, register follow-up ideas in the SQLite `backlog` table:

```sql
INSERT INTO backlog (title, priority, status) VALUES
('Evaluar browsermcp/mcp como complemento de browser nativo', 'low', 'pending'),
('Crear skill docker-assistant con docker-mcp', 'low', 'pending');
```

## References

- `references/mcp-transports.md` - stdio, SSE, Streamable HTTP handshake details.
- `references/wrapper-template.py` - template for stdio MCP wrapper.
- `references/evaluation-criteria.md` - full checklist with examples.
