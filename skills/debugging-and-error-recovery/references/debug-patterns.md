# Debug Patterns - Modos de fallo comunes y detección

Referencia de patrones de debugging para `debugging-and-error-recovery`. Cubre los modos de fallo más frecuentes y cómo detectarlos temprano.

## Modos de fallo comunes

| Modo de fallo | Síntoma | Detección | Fix típico |
|---|---|---|---|
| **Race condition** | Comportamiento intermitente, pasa en dev falla en prod | Reproducir con stress/paralelismo, revisar async | Serializar, locks, `Promise.all` correcto |
| **Stale state** | UI no refleja estado actual | Revisar closure/cache, comparar timestamps | Invalidar caché, refetch |
| **Off-by-one** | Bordes fallan (primero/último elemento) | Tests de boundary, fuzzing de inputs | Revisar índices y condiciones de límite |
| **Null/undefined** | Crash en runtime | TypeScript strict, guards | Validar input, defaults seguros |
| **Zombie code** | Rama de código que nunca ejecuta | Coverage report, dead code analysis | Eliminar, no parchear encima |
| **Config drift** | Comportamiento difiere entre ambientes | Diff de configs, dotenv checks | Centralizar y versionar config |
| **Leak** | Memoria/recursos crecen | Profiling, heap snapshots | Liberar listeners, streams, timers |

## Estrategias de detección temprana

1. **Reproduce primero** - nunca arregles un bug que no podes reproducir aislado.
2. **Reducí el caso** - eliminá variables hasta el mínimo que falla.
3. **Localizá la capa** - UI, lógica, API o datos. Aislá el dominio del bug.
4. **Escribí el test que falla** - reproducí el bug en un test antes de tocar código.
5. **Arreglá la causa, no el síntoma** - Chesterton's Fence: entendé por qué estaba antes de cambiarlo.
6. **Agregá un guard** - test de regresión que prevenga la reaparición.

## Anti-patrones

| Anti-patrón | Por qué falla |
|---|---|
| Debug con `console.log` disperso | No escala, se olvida, ensucia |
| Parchear sin test | El bug vuelve con otra cara |
| Cambiar muchas cosas a la vez | Imposible aislar la causa |
| Arreglar el síntoma visible | La causa raíz sigue activa |

## Related

- Usado por: `debugging-and-error-recovery`
- Complementa: `docs/checklists/logging-template.md`, `docs/checklists/error-monitoring-setup.md`
