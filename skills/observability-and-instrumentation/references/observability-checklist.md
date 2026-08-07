# Lista de verificación de observabilidad

Referencia rápida para instrumentar código de producción. Úsala junto con la skill `observability-and-instrumentation`.

## Tabla de contenidos

- [Preguntas de guardia (empezar aquí)](#preguntas-de-guardia-empezar-aquí)
- [Logging estructurado](#logging-estructurado)
- [Métricas](#métricas)
- [Tracing distribuido](#tracing-distribuido)
- [Alertas](#alertas)
- [Dashboards](#dashboards)
- [Verifica la telemetría](#verifica-la-telemetría)
- [Puerta previa al lanzamiento](#puerta-previa-al-lanzamiento)

## Preguntas de guardia (empezar aquí)

La telemetría sin una pregunta es ruido. Antes de instrumentar cualquier cosa:

- [ ] Están escritas de 2 a 4 preguntas que un ingeniero de guardia hará sobre esta funcionalidad
- [ ] Cada señal de abajo se mapea a una de esas preguntas
- [ ] Cada pregunta se empareja con el tipo de señal correcto: las métricas dicen **que** algo anda mal, las trazas dicen **dónde**, los logs dicen **por qué**

## Logging estructurado

- [ ] Los logs están estructurados (JSON) con nombres de evento estables, no cadenas de forma libre
- [ ] Cada línea de log lleva un ID de correlación/petición, generado o aceptado en el límite del sistema
- [ ] El ID de correlación se propaga en cada llamada saliente y límite async (cabeceras HTTP, metadata de cola)
- [ ] Los niveles de log son consistentes: `error` = invariante roto, alguien puede actuar; `warn` = degradado pero manejado; `info` = evento de negocio significativo; `debug` = desactivado en producción
- [ ] Sin secretos, tokens, contraseñas ni PII sin redactar en ninguna línea de log (regla dura de `security-and-hardening`)
- [ ] Los campos están en lista blanca: sin cuerpos de petición/respuesta completos, sin cabeceras de auth
- [ ] Llamadas a servicios externos registradas solo con metadata: endpoint, estado, latencia, número de intento, identificadores sanitizados
- [ ] Salida de log real verificada por muestreo: campos estructurados, no `[object Object]`

## Métricas

- [ ] **RED** instrumentado para cada endpoint y cada dependencia externa: Rate, Errors, Duration
- [ ] **USE** instrumentado para cada recurso (colas, pools, hosts): Utilization, Saturation, Errors
- [ ] La latencia es un histograma; p50/p95/p99 consultables, nunca un promedio
- [ ] Todas las etiquetas vienen de conjuntos pequeños y fijos (plantilla de ruta, clase de estado, nombre del proveedor)
- [ ] Sin valores de etiqueta ilimitados: sin IDs de usuario, IDs de tenant, emails, URLs crudas, IDs de petición ni texto de mensajes de error
- [ ] Códigos de estado agrupados por clase (`5xx`, no `503`)
- [ ] Profundidad de cola y duración de procesamiento rastreadas para cada worker/cola

## Tracing distribuido

- [ ] OpenTelemetry (o equivalente) inicializado al arrancar el servicio, antes de otros imports
- [ ] Auto-instrumentación habilitada para HTTP, gRPC y clientes de base de datos
- [ ] Contexto de traza propagado en cada llamada saliente (W3C `traceparent`/`tracestate`) y extraído de cada petición entrante
- [ ] El contexto sobrevive los límites async: los mensajes de cola llevan metadata de traza
- [ ] Spans manuales solo alrededor de unidades de trabajo internas significativas, con los atributos por los que la guardia filtrará
- [ ] Sin secretos ni PII como atributos de span
- [ ] Muestreo head-based a una tasa baja por defecto; 100% de errores conservados si hay tail sampling disponible

## Alertas

- [ ] Cada alerta se basa en síntomas (tasa de error, latencia p99, edad de cola); las causas (CPU, disco, reinicios) van a dashboards, no a pagers
- [ ] Cada alerta es accionable; las alertas de "ignórala, se auto-cura" se eliminan
- [ ] Cada alerta enlaza a un runbook: mínimo tres líneas: qué significa, primera consulta a ejecutar, ruta de escalación
- [ ] Umbrales y duraciones justificados por un SLO o datos históricos, no por conjeturas
- [ ] Solo dos severidades: **page** (orientada al usuario, actúa ya) y **ticket** (degradación, actúa esta semana)
- [ ] Cada alerta nueva se disparó una vez en prueba: llegó al canal correcto y el enlace del runbook funciona
- [ ] Sin alertas que se disparen a diario y se reconozcan sin acción

## Dashboards

- [ ] Existe el dashboard de salud del servicio: tasa de error, latencia p99, tráfico, saturación
- [ ] El panel de salud de dependencias muestra tasas de error y latencia por servicio
- [ ] El dashboard responde las preguntas de guardia del inicio de esta lista, no "todo excepto la respuesta"
- [ ] El rango de tiempo por defecto es razonable (1h-6h, no 30d)

## Verifica la telemetría

La instrumentación es código; puede estar mal:

- [ ] Forzó un error en staging y lo encontró en los logs por ID de correlación
- [ ] Envió tráfico de prueba y las series de métricas aparecen con etiquetas esperadas y valores razonables
- [ ] Siguió una petición de punta a punta en la UI de tracing sin spans rotos
- [ ] Una falla inducida se diagnosticó solo desde la telemetría, sin leer el código fuente

## Puerta previa al lanzamiento

Antes de que una funcionalidad llegue a producción, todo lo siguiente es verdadero:

- [ ] Logs estructurados fluyendo al agregador de logs
- [ ] Métricas RED visibles en los dashboards para cada endpoint y dependencia nuevos
- [ ] Al menos una alerta basada en síntomas configurada, con runbook y disparada en prueba
- [ ] Una petición puede rastrearse a través de cada servicio que toca
- [ ] La guardia sabe dónde están los runbooks

Para la secuencia de monitoreo del día del lanzamiento y los triggers de rollback, consulta la skill `shipping-and-launch`.
