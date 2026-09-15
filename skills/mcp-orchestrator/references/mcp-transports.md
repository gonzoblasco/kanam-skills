# MCP transports

## stdio

- Server reads JSON-RPC messages from stdin, one per line.
- Server writes responses to stdout.
- Client must send `initialize` request first, then `initialized` notification.
- Typical invocation: `npx -y <package>` or `python -m <module>`.

## SSE (Server-Sent Events)

- Server exposes an HTTP endpoint that streams events.
- Client POSTs JSON-RPC messages to a separate message endpoint.
- Session management varies by implementation.

## Streamable HTTP

- Single HTTP endpoint accepts POST with JSON-RPC messages and returns responses.
- Used by `@yanhuifair/godot-mcp` at `http://127.0.0.1:9877/mcp`.
- No long-lived SSE stream; each request/response is independent.
