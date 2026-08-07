---
name: deprecation-and-migration
description: Gestiona la deprecación y la migración. Úsalo al eliminar sistemas, APIs o funciones antiguas. Úsalo al migrar usuarios de una implementación a otra. Úsalo al decidir si mantener o retirar código existente.
---

# Deprecación y Migración

## Visión General

El código es un pasivo, no un activo. Cada línea de código tiene un coste de mantenimiento continuo: bugs que corregir, dependencias que actualizar, parches de seguridad que aplicar y nuevos ingenieros que incorporar. La deprecación es la disciplina de eliminar código que ya no se gana su mantenimiento, y la migración es el proceso de trasladar a los usuarios de forma segura de lo antiguo a lo nuevo.

La mayoría de las organizaciones de ingeniería son buenas construyendo cosas. Pocas son buenas eliminándolas. Esta skill aborda esa brecha.

## Cuándo Usarla

- Reemplazar un sistema, API o librería antigua por una nueva
- Retirar una función que ya no se necesita
- Consolidar implementaciones duplicadas
- Eliminar código muerto que nadie posee pero del que todos dependen
- Planificar el ciclo de vida de un sistema nuevo (la planificación de la deprecación empieza en el diseño)
- Decidir si mantener un sistema heredado o invertir en la migración

## Principios Fundamentales

### El Código Es un Pasivo

Cada línea de código tiene un coste continuo: necesita tests, documentación, parches de seguridad, actualizaciones de dependencias y sobrecarga mental para cualquiera que trabaje cerca. El valor del código es la funcionalidad que proporciona, no el código en sí. Cuando la misma funcionalidad se puede proporcionar con menos código, menos complejidad o mejores abstracciones, el código antiguo debería desaparecer.

### La Ley de Hyrum Hace Difícil la Eliminación

Con suficientes usuarios, cada comportamiento observable acaba siendo del que se depende, incluidos los bugs, las peculiaridades de timing y los efectos secundarios no documentados. Por eso la deprecación requiere migración activa, no solo un anuncio. Los usuarios no pueden "simplemente cambiar" cuando dependen de comportamientos que el reemplazo no replica.

### La Planificación de la Deprecación Empieza en el Diseño

Cuando construyas algo nuevo, pregúntate: "¿Cómo eliminaríamos esto en 3 años?" Los sistemas diseñados con interfaces limpias, feature flags y una superficie mínima son más fáciles de deprecar que los sistemas que filtran detalles de implementación por todas partes.

## La Decisión de Deprecar

Antes de deprecar nada, responde estas preguntas:

```
1. ¿Este sistema todavía proporciona valor único?
   → Si es así, mantenlo. Si no, continúa.

2. ¿Cuántos usuarios/consumidores dependen de él?
   → Cuantifica el alcance de la migración.

3. ¿Existe un reemplazo?
   → Si no existe, construye el reemplazo primero. No depreques sin una alternativa.

4. ¿Cuál es el coste de migración para cada consumidor?
   → Si es trivialmente automatizable, hazlo. Si es manual y de alto esfuerzo, compáralo con el coste de mantenimiento.

5. ¿Cuál es el coste de mantenimiento continuo de NO deprecar?
   → Riesgo de seguridad, tiempo de los ingenieros, coste de oportunidad de la complejidad.
```

## Deprecación Obligatoria vs. Aconsejable

| Tipo | Cuándo Usarlo | Mecanismo |
|------|---------------|-----------|
| **Aconsejable** | La migración es opcional, el sistema antiguo es estable | Advertencias, documentación, empujoncitos. Los usuarios migran según su propio calendario. |
| **Obligatoria** | El sistema antiguo tiene problemas de seguridad, bloquea el progreso o el coste de mantenimiento es insostenible | Fecha límite dura. El sistema antiguo se eliminará en la fecha X. Proporciona herramientas de migración. |

**El valor por defecto es aconsejable.** Usa la obligatoria solo cuando el coste de mantenimiento o el riesgo justifique forzar la migración. La deprecación obligatoria requiere proporcionar herramientas de migración, documentación y soporte: no puedes simplemente anunciar una fecha límite.

## El Proceso de Migración

### Paso 1: Construye el Reemplazo

No depreques sin una alternativa funcional. El reemplazo debe:

- Cubrir todos los casos de uso críticos del sistema antiguo
- Tener documentación y guías de migración
- Estar probado en producción (no solo "teóricamente mejor")

### Paso 2: Anuncia y Documenta

```markdown
## Aviso de Deprecación: OldService

**Estado:** Deprecado desde 2025-03-01
**Reemplazo:** NewService (consulta la guía de migración abajo)
**Fecha de eliminación:** Aconsejable - todavía sin fecha límite dura
**Motivo:** OldService requiere escalado manual y carece de observabilidad.
            NewService gestiona ambas cosas automáticamente.

### Guía de Migración
1. Reemplaza `import { client } from 'old-service'` por `import { client } from 'new-service'`
2. Actualiza la configuración (consulta los ejemplos abajo)
3. Ejecuta el script de verificación de migración: `npx migrate-check`
```

### Paso 3: Migra de Forma Incremental

Migra a los consumidores uno a la vez, no todos a la vez. Para cada consumidor:

```
1. Identifica todos los puntos de contacto con el sistema deprecado
2. Actualiza para usar el reemplazo
3. Verifica que el comportamiento coincide (tests, comprobaciones de integración)
4. Elimina las referencias al sistema antiguo
5. Confirma que no hay regresiones
```

**La Regla del Churn:** Si posees la infraestructura que se está deprecando, eres responsable de migrar a tus usuarios, o de proporcionar actualizaciones compatibles hacia atrás que no requieran migración. No anuncies la deprecación y dejes que los usuarios lo resuelvan por su cuenta.

### Paso 4: Elimina el Sistema Antiguo

Solo después de que todos los consumidores hayan migrado:

```
1. Verifica cero uso activo (métricas, logs, análisis de dependencias)
2. Elimina el código
3. Elimina los tests, la documentación y la configuración asociados
4. Elimina los avisos de deprecación
5. Celebra: eliminar código es un logro
```

## Patrones de Migración

### Patrón Strangler (Asfixiador)

Ejecuta los sistemas antiguo y nuevo en paralelo. Enruta el tráfico de forma incremental de lo antiguo a lo nuevo. Cuando el sistema antiguo maneje el 0% del tráfico, elimínalo.

```
Fase 1: El sistema nuevo maneja el 0%, el antiguo el 100%
Fase 2: El sistema nuevo maneja el 10% (canary)
Fase 3: El sistema nuevo maneja el 50%
Fase 4: El sistema nuevo maneja el 100%, el antiguo en reposo
Fase 5: Elimina el sistema antiguo
```

### Patrón Adaptador

Crea un adaptador que traduzca las llamadas de la interfaz antigua a la nueva implementación. Los consumidores siguen usando la interfaz antigua mientras migras el backend.

```typescript
// Adaptador: interfaz antigua, implementación nueva
class LegacyTaskService implements OldTaskAPI {
  constructor(private newService: NewTaskService) {}

  // Firma de método antigua, delega en la implementación nueva
  getTask(id: number): OldTask {
    const task = this.newService.findById(String(id));
    return this.toOldFormat(task);
  }
}
```

### Migración con Feature Flags

Usa feature flags para cambiar a los consumidores del sistema antiguo al nuevo uno a la vez:

```typescript
function getTaskService(userId: string): TaskService {
  if (featureFlags.isEnabled('new-task-service', { userId })) {
    return new NewTaskService();
  }
  return new LegacyTaskService();
}
```

### Migraciones de Esquema de Base de Datos (Expandir/Contraer)

Un cambio de esquema es la migración más arriesgada porque los datos son lo único que no puedes revertir revirtiendo un deploy. El modo de fallo es acoplar el cambio de esquema al cambio de código: renombrar una columna en el mismo release que empieza a usar el nombre nuevo, y durante la ventana de rollout, cuando el código antiguo y el nuevo se ejecutan a la vez, uno de ellos consultará una columna que no existe. La solución es **nunca cambiar una columna en el lugar**. Migra en fases aditivas para que el código antiguo y el nuevo sean válidos en cada paso.

```
EXPANDIR ──────────────→ MIGRAR ──────────────→ CONTRAER
añade la columna nueva,   rellena las filas      una vez que ningún código
nullable, junto a la      existentes, escribe    lea la columna antigua,
antigua                   antiguo+nuevo desde    elimínala en un deploy
                          la app                 posterior y separado
```

**Ejemplo trabajado: renombrar `name` a `full_name`:**

1. **Expandir.** Añade `full_name` como nullable. Deploy. (El código antiguo lo ignora; nada se rompe.)
2. **Escritura dual.** La app escribe tanto `name` como `full_name` en cada insert/update. Deploy.
3. **Rellenar.** Copia `name → full_name` para las filas existentes, por lotes, para no bloquear la tabla.
4. **Cambiar las lecturas.** Apunta la app a `full_name`, sigue escribiendo ambas. Deploy y deja reposar.
5. **Contraer.** Deja de escribir `name` y luego, en un deploy *posterior y separado*, elimina la columna.

Cada paso es desplegable y reversible de forma independiente: si el paso 4 se comporta mal, revierte el código y `full_name` sigue poblándose. Trata cada fase como una rebanada vertical fina: consulta la skill `incremental-implementation`.

**Reglas:**
- **Primero aditivo, destructivo al final y solo.** Las adiciones (columna nullable nueva, tabla nueva, índice nuevo) son seguras en cualquier deploy; los drops y renombrados tienen su propio deploy *después* de que ningún código referencie la forma antigua.
- **Toda migración tiene un camino de bajada probado.** Una migración que no puedes revertir es un deploy que no puedes revertir. Escribe y ejecuta el `down` antes de fusionar.
- **Rellena por lotes, fuera del camino caliente.** Un único `UPDATE` sobre millones de filas bloquea la tabla; divide en partes y regula el ritmo.
- **Construye índices grandes sin bloquear las escrituras** (p. ej., `CREATE INDEX CONCURRENTLY` en Postgres).
- **Desacopla del código con feature flag** cuando el cambio sea arriesgado, exactamente como en el patrón de Migración con Feature Flags de arriba.

## Código Zombi

El código zombi es código que nadie posee pero del que todos dependen. No se mantiene activamente, no tiene dueño claro y acumula vulnerabilidades de seguridad y problemas de compatibilidad. Señales:

- Sin commits en 6+ meses pero con consumidores activos
- Sin maintainer o equipo asignado
- Tests que fallan y nadie corrige
- Dependencias con vulnerabilidades conocidas que nadie actualiza
- Documentación que referencia sistemas que ya no existen

**Respuesta:** O asigna un dueño y mantenlo adecuadamente, o deprécalo con un plan de migración concreto. El código zombi no puede quedarse en el limbo: o recibe inversión o se elimina.

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "Todavía funciona, ¿por qué eliminarlo?" | El código funcional que nadie mantiene acumula deuda de seguridad y complejidad. El coste de mantenimiento crece en silencio. |
| "Alguien podría necesitarlo más tarde" | Si se necesita más tarde, se puede reconstruir. Mantener código sin usar "por si acaso" cuesta más que reconstruir. |
| "La migración es demasiado cara" | Compara el coste de migración con el coste de mantenimiento continuo durante 2-3 años. La migración suele ser más barata a largo plazo. |
| "Lo deprecaremos después de terminar el sistema nuevo" | La planificación de la deprecación empieza en el diseño. Para cuando el sistema nuevo esté terminado, tendrás prioridades nuevas. Planifica ahora. |
| "Los usuarios migrarán por su cuenta" | No lo harán. Proporciona herramientas, documentación e incentivos, o haz la migración tú mismo (la Regla del Churn). |
| "Podemos mantener ambos sistemas indefinidamente" | Dos sistemas haciendo lo mismo es el doble de mantenimiento, testing, documentación y coste de incorporación. |
| "Solo renombra la columna, es una línea" | Durante el rollout, el código antiguo y el nuevo se ejecutan juntos: uno consultará una columna que ya no existe. Expandir/contraer, nunca renombrar en el lugar. |
| "Añadiré la columna y eliminaré la antigua en la misma migración" | Eso acopla una adición segura a un drop destructivo. Los drops tienen su propio deploy, después de que ningún código referencie la forma antigua. |
| "Escribiremos el rollback si lo necesitamos" | Una migración sin camino de bajada es un deploy que no puedes revertir. Escribe y ejecuta el `down` antes de fusionar. |

## Señales de Alerta

- Sistemas deprecados sin reemplazo disponible
- Anuncios de deprecación sin herramientas de migración ni documentación
- Deprecación "blanda" que lleva años en modo aconsejable sin progreso
- Código zombi sin dueño y con consumidores activos
- Funciones nuevas añadidas a un sistema deprecado (invierte en el reemplazo en su lugar)
- Deprecación sin medir el uso actual
- Eliminar código sin verificar cero consumidores activos
- Un cambio de esquema y el código que depende de él enviados en el mismo deploy
- Una columna renombrada o eliminada en el lugar en lugar de mediante expandir/contraer
- Una migración fusionada sin camino de bajada probado, o un relleno que bloquea la tabla

## Verificación

Después de completar una deprecación:

- [ ] El reemplazo está probado en producción y cubre todos los casos de uso críticos
- [ ] Existe una guía de migración con pasos y ejemplos concretos
- [ ] Todos los consumidores activos han migrado (verificado por métricas/logs)
- [ ] El código, los tests, la documentación y la configuración antiguos están completamente eliminados
- [ ] No quedan referencias al sistema deprecado en el codebase
- [ ] Los avisos de deprecación se eliminan (ya cumplieron su propósito)

Después de una migración de esquema de base de datos:

- [ ] El cambio se envía en fases aditivas (expandir → rellenar → contraer), no en una única edición en el lugar
- [ ] El código antiguo y el nuevo son ambos válidos contra el esquema en cada paso del deploy
- [ ] Cada migración tiene un camino de bajada probado; los rellenos se ejecutan en lotes regulados
- [ ] Los pasos destructivos (drop/renombrar) se envían en su propio deploy después de que ningún código referencie la forma antigua
