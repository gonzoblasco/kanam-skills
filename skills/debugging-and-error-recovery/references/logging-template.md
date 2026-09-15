# Logging Template - Captura estructurada de errores

Template de logging estructurado para `debugging-and-error-recovery`. Logs que el debug no tendría que adivinar.

## Principio

Un log sirve para **reconstruir el camino al error** sin tener que adivinar. Cada entrada debe responder: qué pasó, dónde, con qué input, en qué contexto.

## Formato estándar (structured logging)

```
[LEVEL] [timestamp] [service] [event] message { context }
```

Ejemplo:
```
[ERROR] [2026-08-17T13:00:00Z] [checkout] [payment_failed] "Payment declined" { userId: "u_123", orderId: "o_456", amount: 99.5, gateway: "stripe", code: "card_declined" }
```

## Campos obligatorios en un error

| Campo | Qué es | Ejemplo |
|---|---|---|
| `level` | Severidad | `error`, `warn`, `info` |
| `event` | Nombre del evento, no mensaje libre | `payment_failed` |
| `message` | Descripción corta legible | `"Payment declined"` |
| `context` | Datos estructurados del error | `{ userId, orderId, code }` |
| `timestamp` | ISO 8601 | `2026-08-17T13:00:00Z` |
| `error` | Stack trace / cause original | `{ name, message, stack }` |

## Buenas prácticas

- **Estructurado, no free-text:** cada campo es queryable (JSON, no strings planos).
- **`event` estable, `message` humano:** el event permite filtrar/alertar; el message es para lectura.
- **Contexto rico:** incluí ids, inputs y estado que permitan reproducir.
- **Nunca secretos:** no loguees passwords, tokens, ni PII.
- **Nivel correcto:** `error` solo para fallas accionables; `warn` para recuperables; `info` para trazas.
- **Error original preservado:** nunca descartes el `cause`/stack al envolver.

## Template de handler de error

```ts
function handleError(error: unknown, context: Record<string, unknown>) {
  logger.error({
    level: "error",
    event: "unhandled",
    message: error instanceof Error ? error.message : "Unknown error",
    context,
    timestamp: new Date().toISOString(),
    error: error instanceof Error
      ? { name: error.name, message: error.message, stack: error.stack }
      : { raw: String(error) },
  });
}
```

## Related

- Usado por: `debugging-and-error-recovery`
- Complementa: `docs/checklists/debug-patterns.md`, `docs/checklists/error-monitoring-setup.md`
