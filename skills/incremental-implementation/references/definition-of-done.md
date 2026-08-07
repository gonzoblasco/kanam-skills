# Definition of Done

Un estándar permanente a nivel de proyecto que todo cambio debe superar antes de contarse como terminado. A diferencia de los acceptance criteria, que varían por tarea y responden "¿construimos lo correcto?", el Definition of Done es el mismo siempre y responde "¿está terminado según nuestro estándar?". Usarlo como gate final en `planning-and-task-breakdown`, `incremental-implementation` y `shipping-and-launch`.

## Definition of Done vs. Acceptance Criteria

| | Acceptance Criteria | Definition of Done |
|---|---|---|
| Alcance | Específico de una tarea o spec | Aplica a cada incremento |
| Cambios | Diferente para cada ítem | Fijo y reutilizado |
| Responde | "¿Construimos *esta cosa*?" | "¿Está *listo*?" |
| Dueño | Definido al planificar la tarea | Definido una vez para el proyecto |
| Ejemplo | "El usuario puede resetear la contraseña vía link de email" | "Los tests pasan, sin regresiones, docs actualizados" |

Ambos son complementarios. Una tarea está terminada solo cuando **sus** acceptance criteria se cumplen **y** el Definition of Done permanente se satisface. Omitir cualquiera de los dos deja trabajo que parece terminado pero no lo está.

## El checklist permanente

Aplicarlo a cada cambio antes de declararlo terminado.

### Corrección
- [ ] Todos los acceptance criteria de la tarea se cumplen
- [ ] El código corre y se comporta como se intentó, verificado en runtime, no solo compilado o con typecheck
- [ ] El comportamiento nuevo está cubierto por tests que fallan sin el cambio y pasan con él
- [ ] Los tests existentes siguen pasando; no se introdujeron regresiones
- [ ] Los edge cases y los caminos de error están manejados, no solo el happy path

### Calidad
- [ ] El código revela la intención a través del naming y la estructura; no se necesitan comentarios para explicar *qué* hace
- [ ] Sin lógica de negocio duplicada
- [ ] Sin dead code, output de debug ni bloques comentados dejados atrás
- [ ] Los cambios están acotados a la tarea; sin refactors no relacionados colados
- [ ] Linting y formato pasan

La profundidad detrás de estos ítems vive en `code-review-and-quality` (la review de cinco ejes) y `code-simplification` (reducir complejidad sin cambiar comportamiento).

### Integración
- [ ] El cambio funciona con el resto del sistema, no solo de forma aislada
- [ ] Las migraciones de base de datos, cambios de config y feature flags están contemplados
- [ ] Se consideró la retrocompatibilidad para cualquier interfaz pública o cambio de API

### Documentación
- [ ] Las interfaces públicas, APIs y el comportamiento orientado al usuario están documentados
- [ ] Las decisiones arquitectónicas que valen la pena preservar están registradas (ver `documentation-and-adrs`)
- [ ] La documentación describe el estado actual en lenguaje atemporal, no el historial de cambios

### Ship-readiness
- [ ] Se revisaron las implicaciones de seguridad para cualquier input no confiable, auth o manejo de datos (ver `security-and-hardening`)
- [ ] Hay observabilidad en su lugar para nuevos caminos críticos (logs, métricas, traces) (ver `observability-and-instrumentation`)
- [ ] Existe un camino de rollback para cualquier cosa riesgosa (ver `shipping-and-launch`)
- [ ] El humano revisó y aprobó antes del merge o deploy

## Cómo aplicar

- **Por tarea**: confirmar las secciones de Corrección y Calidad antes de marcar la tarea.
- **Por feature**: confirmar Integración y Documentación antes de considerar la feature completa.
- **Por release**: el checklist completo es el piso; `shipping-and-launch` agrega los gates específicos de deploy encima.

Adaptar la lista al proyecto una vez, luego reutilizarla sin cambios. Un Definition of Done que se renegocia cada sprint no es un Definition of Done.

## Red flags

- "Está hecho, solo que todavía no lo corrí": el trabajo no verificado no está hecho.
- "Los tests pasan" usado como sinónimo de hecho mientras se omiten docs, regresiones o verificación en runtime.
- Un estándar distinto aplicado según la presión de plazos.
- Los acceptance criteria tratados como el estándar completo, sin piso de calidad permanente.
- "Hecho" declarado antes de la revisión humana en cambios que la necesitan.
