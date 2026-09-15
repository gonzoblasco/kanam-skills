---
name: "deepwiki"
description: "Query GitHub repo documentation via DeepWiki MCP"
---

# deepwiki

## Description
Accesses documentation of public GitHub repositories through the DeepWiki MCP server. Supports three operations: AI questions about a repo, listing its wiki structure, and reading specific pages. Works with any public repo without authentication.

## When to use it
- To understand a library's architecture before sending a PR
- To verify whether a project documents a specific feature without cloning the repo
- To get answers about API usage based on the project's real documentation
- To explore the wiki structure of an unfamiliar open-source codebase
- To research how a popular framework handles a particular pattern

## Workflow
1. Identify the public repo to query (owner/name)
2. Choose the operation: question, list wiki, or read page
3. Run deepwiki with the operation and the repo
4. Receive the answer based on the project's real documentation

## Related tooling

| Skill / Script | Use |
|---|---|
| `oss-contribution/scripts/triage-issues.sh` | Find issues in the queried repo to apply what was learned. |
| `oss-contribution/scripts/setup-fork.sh` | Prepare a local fork if you decide to contribute. |

## Notes
- No authentication required
- Answers based on real documentation, not training data
- Useful for OSS contributions (shadcn/ui, TanStack, vercel/ai)
