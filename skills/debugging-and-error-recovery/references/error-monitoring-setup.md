# Error Monitoring Setup - Integración de monitoreo de errores

Referencia para configurar monitoreo de errores en producción (Sentry/Bugsnag). Para `debugging-and-error-recovery`.

## Qué monitorear

1. **Excepciones no capturadas** - crashes, promises rechazadas sin manejar
2. **Errores HTTP 4xx/5xx** - errores de API con contexto de request
3. **Errores de frontend** - excepciones JS, errores de React, assets fallidos
4. **Fallas de terceros** - CDN, webhooks, servicios externos
5. **Alertas de rendimiento** - LCP, FCP, errores de recursos (opcional, si el plan lo incluye)

## Configuración típica (Sentry)

### Frontend (browser)
```ts
import * as Sentry from "@sentry/browser";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.COMMIT_SHA, // versiona con el deploy
  tracesSampleRate: 0.1, // muestreo para no saturar
});
```

### Backend (Node)
```ts
import * as Sentry from "@sentry/node";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
});
```

## Buenas prácticas

- **Contexto rico:** capturá user id, route, action y datos relevantes en cada evento.
- **Versionado:** asociá cada error a la versión/release que lo generó.
- **Muestreo:** no envíes el 100% de eventos; muestreá para balancear costo vs cobertura.
- **Agrupación:** usá breadcrumbs para reconstruir el camino al error.
- **Alertas accionables:** solo alarma lo que requiere acción; evita ruido.
- **No loguear secretos:** nunca captures tokens, passwords ni PII en los eventos.

## Checklist de integración

- [ ] SDK inicializado con DSN en variables de entorno
- [ ] `release` versionado con el commit/deploy
- [ ] Errors no capturados + promises rechazadas cubiertos
- [ ] Contexto (user, route) adjunto a eventos
- [ ] Secretos/PII excluidos de los payloads
- [ ] Alertas configuradas con thresholds accionables

## Related

- Usado por: `debugging-and-error-recovery`
- Complementa: `docs/checklists/debug-patterns.md`, `docs/checklists/logging-template.md`
