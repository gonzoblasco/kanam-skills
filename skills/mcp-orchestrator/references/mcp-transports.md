# Transportes de MCP

## stdio

- El servidor lee mensajes JSON-RPC de stdin, uno por línea.
- El servidor escribe las respuestas en stdout.
- El cliente debe enviar primero el request `initialize`, y luego la notificación `initialized`.
- Invocación típica: `npx -y <package>` o `python -m <module>`.

## SSE (Server-Sent Events)

- El servidor expone un endpoint HTTP que transmite eventos.
- El cliente envía por POST mensajes JSON-RPC a un endpoint de mensajes separado.
- La gestión de sesión varía según la implementación.

## Streamable HTTP

- Un único endpoint HTTP acepta POST con mensajes JSON-RPC y devuelve respuestas.
- Usado por `@yanhuifair/godot-mcp` en `http://127.0.0.1:9877/mcp`.
- Sin stream SSE de larga duración; cada request/response es independiente.
