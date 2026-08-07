# Definition of Done

Un estandar de todo el proyecto, permanente, que cada cambio debe superar antes de contarse como hecho. A diferencia de los criterios de aceptacion, que varian por tarea y responden "construimos lo correcto?", la Definition of Done es la misma siempre y responde "esta terminado segun nuestro estandar?". Usala como la puerta final en `planning-and-task-breakdown`, `incremental-implementation` y `shipping-and-launch`.

## Definition of Done vs. Criterios de Aceptacion

| | Criterios de Aceptacion | Definition of Done |
|---|---|---|
| Alcance | Especificos de una tarea o spec | Aplican a cada incremento |
| Cambios | Diferentes para cada item | Fijos y reutilizados |
| Responden | "Construimos *esto*?" | "Esta *listo*?" |
| Dueno | Se definen al planificar la tarea | Se definen una vez para el proyecto |
| Ejemplo | "El usuario puede resetear la contrasena por enlace de email" | "Las pruebas pasan, sin regresiones, docs actualizados" |

Las dos son complementarias. Una tarea esta hecha solo cuando **sus** criterios de aceptacion se cumplen **y** se satisface la Definition of Done permanente. Saltearse cualquiera deja trabajo que se ve terminado pero no lo esta.

## La Checklist Permanente

Aplica esto a cada cambio antes de declararlo hecho.

### Correccion
- [ ] Todos los criterios de aceptacion de la tarea se cumplen
- [ ] El codigo corre y se comporta como se pretende, verificado en runtime, no solo compilado o type-checkeado
- [ ] El nuevo comportamiento esta cubierto por pruebas que fallan sin el cambio y pasan con el
- [ ] Las pruebas existentes siguen pasando; no se introdujeron regresiones
- [ ] Los casos borde y los caminos de error se manejan, no solo el camino feliz

### Calidad
- [ ] El codigo revela la intencion mediante el naming y la estructura; no se necesitan comentarios para explicar *que* hace
- [ ] No hay logica de negocio duplicada
- [ ] No queda codigo muerto, output de debug ni bloques comentados
- [ ] Los cambios estan acotados a la tarea; no se colaron refactors no relacionados
- [ ] El linting y el formateo pasan

La profundidad detras de estos items vive en `code-review-and-quality` (la revision de cinco ejes) y `code-simplification` (reducir la complejidad sin cambiar el comportamiento).

### Integracion
- [ ] El cambio funciona con el resto del sistema, no solo aislado
- [ ] Las migraciones de la base de datos, los cambios de configuracion y los feature flags estan contemplados
- [ ] Se considera la compatibilidad hacia atras para cualquier interfaz publica o cambio de API

### Documentacion
- [ ] Las interfaces publicas, las APIs y el comportamiento orientado al usuario estan documentados
- [ ] Las decisiones arquitectonicas que vale la pena preservar estan registradas (ver `documentation-and-adrs`)
- [ ] La documentacion describe el estado actual en lenguaje atemporal, no el historial de cambios

### Listo para Publicar
- [ ] Se revisaron las implicaciones de seguridad para cualquier entrada no confiable, auth o manejo de datos (ver `security-and-hardening`)
- [ ] Observabilidad en su lugar para los nuevos caminos criticos (logs, metricas, traces) (ver `observability-and-instrumentation`)
- [ ] Existe un camino de rollback para cualquier cosa riesgosa (ver `shipping-and-launch`)
- [ ] El humano reviso y aprobo antes del merge o despliegue

## Como Aplicarlo

- **Por tarea:** confirma las secciones de Correccion y Calidad antes de marcar la tarea como hecha.
- **Por funcion:** confirma Integracion y Documentacion antes de considerar la funcion completa.
- **Por lanzamiento:** la checklist completa es el piso; `shipping-and-launch` agrega las puertas especificas del despliegue encima.

Ajusta la lista al proyecto una vez, luego reusala sin cambios. Una Definition of Done que se renegocia cada sprint no es una Definition of Done.

## Senales de Alerta

- "Esta hecho, solo que aun no lo ejecute": el trabajo no verificado no esta hecho.
- "Las pruebas pasan" usado como sinonimo de hecho mientras se saltean docs, regresiones o verificacion en runtime.
- Un estandar diferente segun la presion de la fecha limite.
- Los criterios de aceptacion tratados como todo el estandar, sin piso de calidad permanente.
- "Hecho" declarado antes de la revision humana en cambios que la necesitan.
