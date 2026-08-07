---
name: observability-and-instrumentation
description: Instrumenta el código para que el comportamiento de producción sea visible y diagnosticable. Usar al agregar logging, métricas, tracing o alertas. Usar al enviar cualquier funcionalidad que corra en producción y necesites evidencia de que funciona. Usar cuando se reporten problemas de producción pero no puedas decir qué pasó a partir de los datos disponibles.
---

# Observabilidad e instrumentación

## Descripción general

El código que no puedes observar es código que no puedes operar. La observabilidad es la capacidad de responder "¿qué está haciendo el sistema y por qué?" desde afuera, usando la telemetría que el código emite. La instrumentación no es un añadido posterior al lanzamiento: se escribe junto con la funcionalidad, de la misma manera que los tests. Si una funcionalidad se lanza sin telemetría, el primer bug reportado por un usuario se convierte en arqueología en lugar de una consulta.

## Cuándo usar

- Al construir cualquier funcionalidad que correrá en producción
- Al agregar un nuevo servicio, endpoint, job en background o integración externa
- Un incidente de producción tardó demasiado en diagnosticarse ("no pudimos decir qué pasó")
- Al configurar o revisar reglas de alertas
- Al revisar un PR que agrega I/O, retries, colas o llamadas entre servicios

**NO para:**
- Diagnosticar una falla que está ocurriendo ahora: usa la skill `debugging-and-error-recovery` (la observabilidad es lo que hace esa skill rápida la próxima vez)
- Perfilar y optimizar lentitud medida: usa la skill `performance-optimization`
- Listas de verificación de monitoreo para el día del lanzamiento y triggers de rollback: consulta la skill `shipping-and-launch`; esta skill cubre la instrumentación que las alimenta

## Proceso

### 1. Define "funciona" antes de instrumentar

La telemetría sin una pregunta es ruido. Antes de agregar cualquier instrumentación, escribe de 2 a 4 preguntas que un ingeniero de guardia hará sobre esta funcionalidad:

```
FUNCIONALIDAD: reintento de pago en checkout
PREGUNTAS DE GUARDIA:
1. ¿Qué fracción de pagos tiene éxito en el primer intento vs después del reintento?
2. Cuando un pago falla permanentemente, ¿por qué? (¿error del proveedor? ¿timeout? ¿validación?)
3. ¿Está el proveedor de pagos más lento de lo habitual?
→ Cada señal de abajo debe ayudar a responder una de estas.
```

Si no puedes nombrar las preguntas, no estás listo para instrumentar: registrarás todo y aprenderás nada.

### 2. Elige la señal correcta para cada pregunta

| Señal | Responde | Perfil de costo | Ejemplo |
|---|---|---|---|
| **Log estructurado** | "¿Qué pasó en este caso específico?" | Por evento; crece con el tráfico | `payment_failed` con código de error del proveedor |
| **Métrica** | "¿Con qué frecuencia / qué tan rápido, en agregado?" | Fija por serie; barata de consultar | latencia p99 de llamadas al proveedor |
| **Traza** | "¿Dónde se fue el tiempo entre servicios?" | Por petición; normalmente muestreada | Un checkout lento, desglosado por salto |

Regla general: las métricas te dicen **que** algo anda mal, las trazas te dicen **dónde**, los logs te dicen **por qué**.

### 3. Logging estructurado

Registra eventos, no prosa. Cada línea de log es un objeto JSON con un nombre de evento estable y campos legibles por máquina:

```typescript
// MAL: interpolación de cadenas: no consultable, inconsistente
logger.info(`Payment ${id} failed for user ${userId} after ${n} retries`);

// BIEN: nombre de evento estable + campos estructurados
logger.warn({
  event: 'payment_failed',
  paymentId: id,
  provider: 'stripe',
  errorCode: err.code,
  attempt: n,
}, 'pago fallido');
```

**Niveles de log: úsalos de forma consistente:**

| Nivel | Significado | Acción de guardia |
|---|---|---|
| `error` | Invariante roto; alguien puede necesitar actuar | Investigar |
| `warn` | Degradado pero manejado (reintento exitoso, fallback usado) | Observar tendencias |
| `info` | Evento de negocio significativo (pedido colocado, job terminado) | Ninguna |
| `debug` | Detalle de diagnóstico | Desactivado en producción por defecto |

**Los IDs de correlación son obligatorios.** Genera (o acepta) un ID de petición en el límite del sistema y adjúntalo a cada línea de log, span y llamada saliente. Sin él, no puedes reconstruir una sola petición a partir de logs intercalados:

```typescript
// Express: logger hijo por petición, ID propagado downstream
app.use((req, res, next) => {
  req.id = req.headers['x-request-id'] ?? crypto.randomUUID();
  req.log = logger.child({ requestId: req.id });
  res.setHeader('x-request-id', req.id);
  next();
});
```

**Nunca registres secretos, tokens, contraseñas ni PII completa.** Esta es una regla dura de la skill `security-and-hardening`: los pipelines de telemetría son una ruta clásica de fuga de datos. Usa listas blancas de campos; no registres cuerpos de petición completos.

### 4. Métricas

Para servicios orientados a peticiones, instrumenta **RED** en cada endpoint y cada dependencia externa: **R**ate (peticiones/seg), **E**rrors (tasa de fallos), **D**uration (histograma de latencia, no promedio). Para recursos (colas, pools, hosts), usa **USE**: **U**tilización, **S**aturación, **E**rrors.

Al igual que con el tracing, el camino neutral de proveedor es la API de métricas de OpenTelemetry (mismo SDK y contexto que el paso 5). El ejemplo de abajo usa `prom-client` de Prometheus, una opción de backend común, no la única; las reglas de RED/USE y cardinalidad son idénticas en cualquier caso.

```typescript
import { Histogram } from 'prom-client';

const httpDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duración de la petición HTTP',
  labelNames: ['method', 'route', 'status_class'],  // '2xx', no '200'
  buckets: [0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
});
```

**La cardinalidad es el modo de falla.** Cada combinación única de etiquetas es una serie temporal separada. Las etiquetas deben venir de conjuntos pequeños y fijos (plantilla de ruta, clase de estado, nombre del proveedor). Nunca uses IDs de usuario, URLs crudas, mensajes de error u otros valores ilimitados como etiquetas: eso pertenece a los logs y las trazas.

```
OK como etiqueta:    route="/api/tasks/:id"   status_class="5xx"   provider="stripe"
NUNCA una etiqueta:  user_id, email, request_id, URL completa, texto del mensaje de error
```

Nunca rastrees promedios, siempre percentiles: un promedio oculta al 1% de usuarios que lo están pasando mal. Usa histogramas y lee p50/p95/p99.

### 5. Tracing distribuido

Usa OpenTelemetry: es el estándar neutral de proveedor, y la auto-instrumentación cubre HTTP, gRPC y clientes de base de datos comunes con código casi nulo:

```typescript
// tracing.ts: debe importarse antes que cualquier otra cosa
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';

const sdk = new NodeSDK({
  serviceName: 'checkout-service',
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();
```

Agrega spans manuales solo alrededor de unidades de trabajo internas significativas (por ejemplo, `applyDiscounts`, `chargeProvider`) y adjunta los atributos por los que la guardia filtrará. Propaga el contexto a través de cada límite async: cabeceras HTTP, metadata de mensajes de cola; o la traza muere en el hueco. Muestrea head-based a una tasa baja por defecto; mantén el 100% de los errores si tu backend soporta tail sampling.

### 6. Alertas

Alerta sobre **síntomas que sienten los usuarios**, no sobre causas:

```
SÍNTOMA (digno de page):           CAUSA (dashboard, no un page):
tasa de error > 1% por 5 min        CPU al 85%
latencia p99 > 2s                   un pod reiniciado
edad de cola > 10 min               disco al 70%
```

Las alertas basadas en causas se disparan cuando nada anda mal y fallan en detectar fallas que no predijiste. Las alertas basadas en síntomas se disparan exactamente cuando los usuarios resultan afectados, sin importar la causa.

Reglas para cada alerta que crees:

1. **Debe ser accionable.** Si la respuesta es "ignórala, se auto-cura", elimina la alerta.
2. **Debe enlazar a un runbook**, incluso de tres líneas: qué significa, primera consulta a ejecutar, ruta de escalación.
3. **Debe tener un umbral y una duración** justificados por el SLO o por datos históricos, no por una conjetura.
4. Usa solo dos severidades: **page** (orientada al usuario, actúa ya) y **ticket** (degradación, actúa esta semana). Un tercer nivel se vuelve ruido que entrena a la gente a ignorar todo.

### 7. Verifica la propia telemetría

La instrumentación es código; puede estar mal. Antes de dar por terminado el trabajo, dispara las rutas y mira la salida real:

- Fuerza un error en staging y encuéntralo en los logs por `requestId`; confirma que los campos estén estructurados (no `[object Object]`)
- Envía tráfico de prueba y confirma que las series de métricas aparezcan con las etiquetas esperadas y valores razonables
- Sigue una petición entre servicios en la UI de tracing: sin spans rotos
- Dispara cada alerta nueva una vez (baja el umbral temporalmente) y confirma que llegue al canal correcto y que el enlace del runbook funcione

## Racionalizaciones comunes

| Racionalización | Realidad |
|---|---|
| "Agregaré logging después de que funcione" | "Después" se vuelve "después del primer incidente", que es el momento más caro para descubrir que estás a ciegas. Instrumenta mientras construyes. |
| "Más logs = más observabilidad" | El ruido no estructurado hace los incidentes más lentos, no más rápidos. Tres eventos consultables ganan a trescientas líneas de prosa. |
| "console.log está bien por ahora" | La salida no estructurada no puede filtrarse, correlacionarse ni alertarse. El logger estructurado cuesta cinco minutos extra una sola vez. |
| "Podemos mirar los dashboards cuando algo se rompa" | Los dashboards construidos sin preguntas definidas te muestran todo excepto la respuesta. Empieza desde las preguntas de guardia. |
| "Alerta sobre todo lo importante, ya lo ajustaremos" | Un pager ruidoso entrena a la gente a ignorarlo. El ajuste nunca ocurre; el page real que se pierde sí ocurre. |
| "El ID de usuario como etiqueta de métrica facilita la depuración" | También hace que tu backend de métricas se caiga. Las búsquedas de alta cardinalidad pertenecen a logs y trazas. |
| "El tracing es excesivo para nuestros dos servicios" | Dos servicios ya significan preguntas de latencia entre servicios que los logs no pueden responder. La auto-instrumentación hace el costo trivial. |

## Red flags

- Un PR de funcionalidad con retries, colas o llamadas externas y cero telemetría nueva
- Líneas de log construidas por interpolación de cadenas en lugar de campos estructurados
- Sin ID de correlación/petición: cada línea de log es un huérfano
- Métricas etiquetadas con IDs de usuario, URLs crudas o texto de mensajes de error (bomba de cardinalidad)
- Latencia rastreada como promedio sin percentiles
- Alertas que se disparan a diario y se reconocen sin acción
- Alertas sobre causas (CPU, memoria) que pagean a humanos mientras la tasa de error orientada al usuario no está monitoreada
- Secretos, tokens o cuerpos de petición completos apareciendo en logs
- "En mi máquina funciona" como única evidencia de que una funcionalidad de producción está sana

## Verificación

Después de instrumentar una funcionalidad, confirma:

- [ ] Las preguntas de guardia para esta funcionalidad están escritas, y cada señal se mapea a una
- [ ] Toda la salida de log es estructurada (JSON), con nombres de evento estables y un ID de correlación en cada línea
- [ ] Sin secretos, tokens ni PII sin redactar en ninguna línea de log (verifica muestras de la salida real)
- [ ] Métricas RED existen para cada endpoint nuevo y cada dependencia externa, con conjuntos de etiquetas acotados
- [ ] La latencia es un histograma; p95/p99 son consultables
- [ ] Una sola petición puede seguirse de punta a punta en la UI de tracing sin spans rotos
- [ ] Cada alerta nueva se basa en síntomas, tiene enlace a runbook y se disparó una vez en prueba
- [ ] Una falla inducida en staging se localizó solo con telemetría, sin leer el código fuente

Para la versión de un vistazo de esta lista, incluida la puerta de instrumentación previa al lanzamiento, consulta `references/observability-checklist.md`.
