---
name: incremental-implementation
description: "Entrega cambios de forma incremental. Usar al implementar cualquier feature o cambio que toque más de un archivo. Usar cuando estés por escribir una gran cantidad de código de una vez, o cuando una tarea se sienta demasiado grande como para aterrizar en un solo paso."
---

# Implementación incremental

## Resumen

Construir en slices verticales delgados - implementar una pieza, testeala, verificala, y luego expandí. Evitar implementar una feature entera de una sola pasada. Cada incremento debería dejar el sistema en un estado funcional y testeable. Esta es la disciplina de ejecución que hace manejables las features grandes.

## Cuándo usar

- Implementar cualquier cambio de múltiples archivos
- Construir una nueva feature a partir de un desglose de tareas
- Refactorizar código existente
- Cada vez que te tiente escribir más de ~100 líneas antes de testear

**Cuándo NO usar:** cambios de un solo archivo y una sola función donde el alcance ya es mínimo.

## El ciclo del incremento

```
┌──────────────────────────────────────┐
│                                      │
│   Implementar ──→ Test ──→ Verificar ─┐  │
│       ▲                           │  │
│       └───── Commit ◄─────────────┘  │
│              │                       │
│              ▼                       │
│          Siguiente slice             │
│                                      │
└──────────────────────────────────────┘
```

Para cada slice:

1. **Implementar** la pieza de funcionalidad completa más pequeña
2. **Testear** - correr la suite de tests (o escribir un test si no existe)
3. **Verificar** - confirmar que el slice funciona como se espera (tests pasan, build tiene éxito, chequeo manual)
4. **Commit** - guardar tu progreso con un mensaje descriptivo (ver `git-workflow-and-versioning` para guía de commits atómicos)
5. **Pasar al siguiente slice** - avanzar, no reiniciar

## Estrategias de slicing

### Slices verticales (Preferidos)

Construir un camino completo a través del stack:

```
Slice 1: Crear una tarea (DB + API + UI básica)
    → Tests pasan, el usuario puede crear una tarea vía la UI

Slice 2: Listar tareas (query + API + UI)
    → Tests pasan, el usuario puede ver sus tareas

Slice 3: Editar una tarea (update + API + UI)
    → Tests pasan, el usuario puede modificar tareas

Slice 4: Eliminar una tarea (delete + API + UI + confirmación)
    → Tests pasan, CRUD completo
```

Cada slice entrega funcionalidad end-to-end funcionando.

### Slicing contract-first

Cuando backend y frontend necesitan desarrollarse en paralelo:

```
Slice 0: Definir el contrato de API (types, interfaces, spec de OpenAPI)
Slice 1a: Implementar backend contra el contrato + tests de API
Slice 1b: Implementar frontend contra mock data que coincida con el contrato
Slice 2: Integrar y testear end-to-end
```

### Slicing risk-first

Atacar la pieza más riesgosa o incierta primero:

```
Slice 1: Probar que la conexión WebSocket funciona (mayor riesgo)
Slice 2: Construir actualizaciones de tareas en tiempo real sobre la conexión probada
Slice 3: Agregar soporte offline y reconexión
```

Si el Slice 1 falla, lo descubrís antes de invertir en los Slices 2 y 3.

## Reglas de implementación

### Regla 0: Simplicidad primero

Antes de escribir cualquier código, preguntar: "¿Cuál es la cosa más simple que podría funcionar?"

Después de escribir código, revisarlo contra estos chequeos:
- ¿Se puede hacer en menos líneas?
- ¿Estas abstracciones justifican su complejidad?
- ¿Un staff engineer lo miraría y diría "¿por qué no simplemente...?"?
- ¿Estoy construyendo para requisitos futuros hipotéticos, o para la tarea actual?

```
CHECEO DE SIMPLICIDAD:
✗ EventBus genérico con pipeline de middleware para una notificación
✓ Llamada a función simple

✗ Patrón de abstract factory para dos componentes similares
✓ Dos componentes directos con utilities compartidas

✗ Form builder config-driven para tres formularios
✓ Tres componentes de formulario
```

Tres líneas de código similares son mejores que una abstracción prematura. Implementar primero la versión naive y obviamente correcta. Optimizar solo después de que la corrección esté probada con tests.

### Regla 0.5: Disciplina de alcance

Tocar solo lo que la tarea requiere.

NO:
- "Limpiar" código adyacente a tu cambio
- Refactorizar imports en archivos que no estás modificando
- Eliminar comentarios que no entendés del todo
- Agregar features que no están en el spec porque "parecen útiles"
- Modernizar sintaxis en archivos que solo estás leyendo

Si notás algo que vale la pena mejorar fuera del alcance de tu tarea, anotalo - no lo arregles:

```
NOTADO PERO NO TOCADO:
- src/utils/format.ts tiene un import sin usar (no relacionado con esta tarea)
- El middleware de auth podría tener mejores mensajes de error (tarea separada)
→ ¿Querés que cree tareas para esto?
```

### Regla 1: Una cosa a la vez

Cada incremento cambia una sola cosa lógica. No mezclar preocupaciones:

**Malo:** Un commit que agrega un componente nuevo, refactoriza uno existente y actualiza la config de build.

**Bueno:** Tres commits separados - uno por cada cambio.

### Regla 2: Mantenerlo compilable

Después de cada incremento, el proyecto debe compilar y los tests existentes deben pasar. No dejar el codebase en un estado roto entre slices.

### Regla 3: Feature flags para features incompletas

Si una feature no está lista para usuarios pero necesitás mergear incrementos:

```typescript
// Feature flag para work-in-progress
const ENABLE_TASK_SHARING = process.env.FEATURE_TASK_SHARING === 'true';

if (ENABLE_TASK_SHARING) {
  // Nueva UI de sharing
}
```

Esto te permite mergear incrementos chicos a la rama main sin exponer trabajo incompleto.

### Regla 4: Defaults seguros

El código nuevo debería tener por default un comportamiento seguro y conservador:

```typescript
// Seguro: deshabilitado por default, opt-in
export function createTask(data: TaskInput, options?: { notify?: boolean }) {
  const shouldNotify = options?.notify ?? false;
  // ...
}
```

### Regla 5: Amigable con rollback

Cada incremento debería ser reversible de forma independiente:

- Los cambios aditivos (archivos nuevos, funciones nuevas) son fáciles de revertir
- Las modificaciones a código existente deberían ser mínimas y enfocadas
- Las migraciones de base de datos deberían tener migraciones de rollback correspondientes
- Evitar borrar algo en un commit y reemplazarlo en el mismo commit - separarlos

## Trabajar con agentes

Al dirigir un agente para que implemente incrementalmente:

```
"Implementemos la Tarea 3 del plan.

Empezá solo con el cambio de schema de base de datos y el endpoint de API.
No toques la UI todavía - eso lo haremos en el próximo incremento.

Después de implementar, corré los comandos de test y build del repo para
verificar que nada esté roto."
```

Ser explícito sobre qué está en alcance y qué NO está en alcance para cada incremento.

## Checklist del incremento

Después de cada incremento, verificar con los comandos propios del repo (ver la sección Descubre el stack primero de la skill test-driven-development):

- [ ] El cambio hace una cosa y la hace completa
- [ ] Todos los tests existentes siguen pasando (el comando de test del repo: `npm test`, `./gradlew test`, `pytest`, ...)
- [ ] El build tiene éxito (el comando de build del repo)
- [ ] El type checking pasa, donde el stack tenga uno (`npx tsc --noEmit`, `mypy`, ...)
- [ ] El linting pasa (el comando de lint del repo)
- [ ] La funcionalidad nueva funciona como se espera
- [ ] El cambio está commiteado con un mensaje descriptivo

**Nota:** Correr cada comando de verificación después de un cambio que podría afectarlo. Después de una corrida exitosa, no repetir el mismo comando salvo que el código haya cambiado desde entonces - repetirlo sobre código sin cambios no agrega información.

## Racionalizaciones comunes

| Racionalización | Realidad |
|---|---|
| "Lo testearé todo al final" | Los bugs se acumulan. Un bug en el Slice 1 hace que los Slices 2-5 estén mal. Testear cada slice. |
| "Es más rápido hacerlo todo de una vez" | *Se siente* más rápido hasta que algo se rompe y no encontrás cuál de las 500 líneas cambiadas lo causó. |
| "Estos cambios son demasiado chicos para commitearlos por separado" | Los commits chicos son gratis. Los commits grandes esconden bugs y hacen doloroso el rollback. |
| "Agregaré el feature flag después" | Si la feature no está completa, no debería ser visible para el usuario. Agregar el flag ahora. |
| "Este refactor es lo bastante chico para incluirlo" | Los refactors mezclados con features hacen que ambos sean más difíciles de revisar y debuggear. Separarlos. |
| "Déjame correr el comando de build otra vez solo para asegurarme" | Después de una corrida exitosa, repetir el mismo comando no agrega nada salvo que el código haya cambiado desde entonces. Correrlo de nuevo después de ediciones posteriores, no como reaseguro. |

## Red flags

- Más de 100 líneas de código escritas sin correr tests
- Múltiples cambios no relacionados en un solo incremento
- "Déjame agregar esto también rápido" expansión de alcance
- Omitir el paso de test/verify para moverse más rápido
- Build o tests rotos entre incrementos
- Cambios grandes sin commitear acumulándose
- Construir abstracciones antes de que el tercer caso de uso lo demande
- Tocar archivos fuera del alcance de la tarea "ya que estoy acá"
- Crear archivos de utility nuevos para operaciones de una sola vez
- Correr el mismo comando de build/test dos veces seguidas sin ningún cambio de código intermedio

## Verificación

Después de completar todos los incrementos de una tarea:

- [ ] Cada incremento fue testeado y commiteado individualmente
- [ ] La suite de tests completa pasa
- [ ] El build está limpio
- [ ] La feature funciona end-to-end como se especificó
- [ ] No quedan cambios sin commitear

## Ver también

La verificación por incremento es el chequeo local. Antes de declarar una tarea terminada, aplicar el Definition of Done a nivel de proyecto como gate final, el estándar permanente que cada incremento debe superar independientemente de la tarea. Ver `references/definition-of-done.md`.
