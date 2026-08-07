---
name: code-simplification
description: Simplifica el código para mayor claridad. Úsalo al refactorizar código para claridad sin cambiar el comportamiento. Úsalo cuando el código funciona pero es más difícil de leer, mantener o extender de lo que debería. Úsalo al revisar código que ha acumulado complejidad innecesaria.
---

# Simplificación de Código

> Inspirado en el [plugin Claude Code Simplifier](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/code-simplifier/agents/code-simplifier.md). Adaptado aquí como una skill agnóstica al modelo y dirigida por proceso para cualquier agente de codificación con IA.

## Visión General

Simplifica el código reduciendo la complejidad mientras preservas el comportamiento exacto. El objetivo no son menos líneas: es un código más fácil de leer, entender, modificar y depurar. Toda simplificación debe pasar una prueba simple: "¿Un miembro nuevo del equipo lo entendería más rápido que el original?"

## Cuándo Usarla

- Después de que una función funciona y los tests pasan, pero la implementación se siente más pesada de lo necesario
- Durante la revisión de código cuando se marcan problemas de legibilidad o complejidad
- Cuando te encuentras con lógica profundamente anidada, funciones largas o nombres poco claros
- Al refactorizar código escrito bajo presión de tiempo
- Al consolidar lógica relacionada repartida entre archivos
- Después de fusionar cambios que introdujeron duplicación o inconsistencia

**Cuándo NO usarla:**

- El código ya está limpio y es legible: no simplifiques por simplificar
- Todavía no entiendes qué hace el código: comprende antes de simplificar
- El código es crítico para el rendimiento y la versión "más simple" sería mediblemente más lenta
- Estás a punto de reescribir el módulo por completo: simplificar código desechable desperdicia esfuerzo

## Los Cinco Principios

### 1. Preserva el Comportamiento Exactamente

No cambies lo que hace el código, solo cómo lo expresa. Todas las entradas, salidas, efectos secundarios, comportamientos de error y casos límite deben permanecer idénticos. Si no estás seguro de que una simplificación preserve el comportamiento, no la hagas.

```
PREGUNTA ANTES DE CADA CAMBIO:
→ ¿Esto produce la misma salida para cada entrada?
→ ¿Mantiene el mismo comportamiento de error?
→ ¿Preserva los mismos efectos secundarios y su orden?
→ ¿Siguen pasando todos los tests existentes sin modificación?
```

### 2. Sigue las Convenciones del Proyecto

Simplificar significa hacer que el código sea más coherente con el codebase, no imponer preferencias externas. Antes de simplificar:

```
1. Lee CLAUDE.md / las convenciones del proyecto
2. Estudia cómo el código vecino maneja patrones similares
3. Haz coincidir el estilo del proyecto en:
   - Orden de imports y sistema de módulos
   - Estilo de declaración de funciones
   - Convenciones de nomenclatura
   - Patrones de manejo de errores
   - Profundidad de anotaciones de tipos
```

La simplificación que rompe la coherencia del proyecto no es simplificación: es churn.

### 3. Prefiere la Claridad Sobre la Astucia

El código explícito es mejor que el código compacto cuando la versión compacta requiere una pausa mental para analizarla.

```typescript
// POCO CLARO: Cadena densa de ternarios
const label = isNew ? 'New' : isUpdated ? 'Updated' : isArchived ? 'Archived' : 'Active';

// CLARO: Mapeo legible
function getStatusLabel(item: Item): string {
  if (item.isNew) return 'New';
  if (item.isUpdated) return 'Updated';
  if (item.isArchived) return 'Archived';
  return 'Active';
}
```

```typescript
// POCO CLARO: Reducciones encadenadas con lógica en línea
const result = items.reduce((acc, item) => ({
  ...acc,
  [item.id]: { ...acc[item.id], count: (acc[item.id]?.count ?? 0) + 1 }
}), {});

// CLARO: Paso intermedio con nombre
const countById = new Map<string, number>();
for (const item of items) {
  countById.set(item.id, (countById.get(item.id) ?? 0) + 1);
}
```

### 4. Mantén el Equilibrio

La simplificación tiene un modo de fallo: la sobre-simplificación. Vigila estas trampas:

- **Inline demasiado agresivo**: eliminar un helper que le daba nombre a un concepto hace que el sitio de la llamada sea más difícil de leer
- **Combinar lógica no relacionada**: dos funciones simples fusionadas en una función compleja no es más simple
- **Eliminar abstracción "innecesaria"**: algunas abstracciones existen para la extensibilidad o la testabilidad, no para la complejidad
- **Optimizar por número de líneas**: menos líneas no es el objetivo; la comprensión más fácil sí lo es

### 5. Acota a lo que Cambió

El valor por defecto es simplificar el código modificado recientemente. Evita refactorizaciones al paso de código no relacionado a menos que se te pida explícitamente ampliar el alcance. La simplificación sin acotar crea ruido en los diffs y arriesga regresiones no intencionadas.

## El Proceso de Simplificación

### Paso 1: Entiende Antes de Tocar (La Valla de Chesterton)

Antes de cambiar o eliminar nada, entiende por qué existe. Esta es la Valla de Chesterton: si ves una valla al otro lado de un camino y no entiendes por qué está ahí, no la derribes. Primero entiende la razón, luego decide si la razón sigue aplicando.

```
ANTES DE SIMPLIFICAR, RESPONDE:
- ¿Cuál es la responsabilidad de este código?
- ¿Qué lo llama? ¿A qué llama?
- ¿Cuáles son los casos límite y los caminos de error?
- ¿Hay tests que definen el comportamiento esperado?
- ¿Por qué podría haberse escrito así? (¿Rendimiento? ¿Restricción de plataforma? ¿Motivo histórico?)
- Revisa el git blame: ¿cuál era el contexto original de este código?
```

Si no puedes responder a estas preguntas, no estás listo para simplificar. Lee más contexto primero.

### Paso 2: Identifica Oportunidades de Simplificación

Busca estos patrones: cada uno es una señal concreta, no un olor vago:

**Complejidad estructural:**

| Patrón | Señal | Simplificación |
|--------|-------|----------------|
| Anidamiento profundo (3+ niveles) | Flujo de control difícil de seguir | Extrae las condiciones a guardas o funciones helper |
| Funciones largas (50+ líneas) | Múltiples responsabilidades | Divide en funciones enfocadas con nombres descriptivos |
| Ternarios anidados | Requiere pila mental para analizar | Reemplaza con cadenas if/else, switch u objetos de búsqueda |
| Flags de parámetros booleanos | `doThing(true, false, true)` | Reemplaza con objetos de opciones o funciones separadas |
| Condicionales repetidos | La misma comprobación `if` en varios lugares | Extrae a una función de predicado bien nombrada |

**Nomenclatura y legibilidad:**

| Patrón | Señal | Simplificación |
|--------|-------|----------------|
| Nombres genéricos | `data`, `result`, `temp`, `val`, `item` | Renombra para describir el contenido: `userProfile`, `validationErrors` |
| Nombres abreviados | `usr`, `cfg`, `btn`, `evt` | Usa palabras completas a menos que la abreviatura sea universal (`id`, `url`, `api`) |
| Nombres engañosos | Función llamada `get` que también muta estado | Renombra para reflejar el comportamiento real |
| Comentarios que explican "qué" | `// increment counter` sobre `count++` | Elimina el comentario: el código ya es bastante claro |
| Comentarios que explican "por qué" | `// Reintenta porque la API es inestable bajo carga` | Consérvalos: llevan intención que el código no puede expresar |

**Redundancia:**

| Patrón | Señal | Simplificación |
|--------|-------|----------------|
| Lógica duplicada | Las mismas 5+ líneas en varios lugares | Extrae a una función compartida |
| Código muerto | Ramas inalcanzables, variables sin usar, bloques comentados | Elimina (después de confirmar que está realmente muerto) |
| Abstracciones innecesarias | Wrapper que no añade valor | Aplica inline al wrapper, llama a la función subyacente directamente |
| Patrones sobre-ingenierizados | Fábrica-de-una-fábrica, estrategia-con-una-estrategia | Reemplaza con el enfoque directo y simple |
| Afirmaciones de tipo redundantes | Casting a un tipo que ya está inferido | Elimina la afirmación |

### Paso 3: Aplica los Cambios de Forma Incremental

Haz una simplificación a la vez. Ejecuta los tests después de cada cambio. **Envía los cambios de refactorización por separado de los cambios de función o corrección de bugs.** Un PR que refactoriza y añade una función son dos PR: divídelos.

```
POR CADA SIMPLIFICACIÓN:
1. Haz el cambio
2. Ejecuta la suite de tests
3. Si los tests pasan → commit (o continúa con la siguiente simplificación)
4. Si los tests fallan → revierte y reconsidera
```

Evita agrupar múltiples simplificaciones en un solo cambio sin probar. Si algo se rompe, necesitas saber qué simplificación lo causó.

**La Regla de 500:** Si una refactorización tocaría más de 500 líneas, invierte en automatización (codemods, scripts de sed, transformaciones AST) en lugar de hacer los cambios a mano. Las ediciones manuales a esa escala son propensas a errores y agotadoras de revisar.

### Paso 4: Verifica el Resultado

Después de todas las simplificaciones, da un paso atrás y evalúa el conjunto:

```
COMPARA ANTES Y DESPUÉS:
- ¿La versión simplificada es genuinamente más fácil de entender?
- ¿Introdujiste patrones nuevos inconsistentes con el codebase?
- ¿El diff está limpio y es revisable?
- ¿Un compañero aprobaría este cambio?
```

Si la versión "simplificada" es más difícil de entender o revisar, revierte. No todo intento de simplificación tiene éxito.

## Guía Específica por Lenguaje

### TypeScript / JavaScript

```typescript
// SIMPLIFICA: Wrapper async innecesario
// Antes
async function getUser(id: string): Promise<User> {
  return await userService.findById(id);
}
// Después
function getUser(id: string): Promise<User> {
  return userService.findById(id);
}

// SIMPLIFICA: Asignación condicional verbosa
// Antes
let displayName: string;
if (user.nickname) {
  displayName = user.nickname;
} else {
  displayName = user.fullName;
}
// Después
const displayName = user.nickname || user.fullName;

// SIMPLIFICA: Construcción manual de arrays
// Antes
const activeUsers: User[] = [];
for (const user of users) {
  if (user.isActive) {
    activeUsers.push(user);
  }
}
// Después
const activeUsers = users.filter((user) => user.isActive);

// SIMPLIFICA: Retorno booleano redundante
// Antes
function isValid(input: string): boolean {
  if (input.length > 0 && input.length < 100) {
    return true;
  }
  return false;
}
// Después
function isValid(input: string): boolean {
  return input.length > 0 && input.length < 100;
}
```

### Python

```python
# SIMPLIFICA: Construcción verbosa de diccionarios
# Antes
result = {}
for item in items:
    result[item.id] = item.name
# Después
result = {item.id: item.name for item in items}

# SIMPLIFICA: Condicionales anidados con retorno temprano
# Antes
def process(data):
    if data is not None:
        if data.is_valid():
            if data.has_permission():
                return do_work(data)
            else:
                raise PermissionError("No permission")
        else:
            raise ValueError("Invalid data")
    else:
        raise TypeError("Data is None")
# Después
def process(data):
    if data is None:
        raise TypeError("Data is None")
    if not data.is_valid():
        raise ValueError("Invalid data")
    if not data.has_permission():
        raise PermissionError("No permission")
    return do_work(data)
```

### React / JSX

```tsx
// SIMPLIFICA: Renderizado condicional verboso
// Antes
function UserBadge({ user }: Props) {
  if (user.isAdmin) {
    return <Badge variant="admin">Admin</Badge>;
  } else {
    return <Badge variant="default">User</Badge>;
  }
}
// Después
function UserBadge({ user }: Props) {
  const variant = user.isAdmin ? 'admin' : 'default';
  const label = user.isAdmin ? 'Admin' : 'User';
  return <Badge variant={variant}>{label}</Badge>;
}

// SIMPLIFICA: Prop drilling a través de componentes intermedios
// Antes - considera si el contexto o la composición resuelven esto mejor.
// Esto es un juicio - márcalo, no lo auto-refactorices.
```

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "Funciona, no hace falta tocarlo" | El código funcional difícil de leer será difícil de arreglar cuando se rompa. Simplificar ahora ahorra tiempo en cada cambio futuro. |
| "Menos líneas siempre es más simple" | Un ternario anidado de 1 línea no es más simple que un if/else de 5 líneas. La simplicidad se trata de velocidad de comprensión, no del número de líneas. |
| "Simplificaré rápido también este código no relacionado" | La simplificación sin acotar crea diffs ruidosos y arriesga regresiones en código que no tenías intención de cambiar. Mantente enfocado. |
| "Los tipos lo hacen autodocumentable" | Los tipos documentan estructura, no intención. Una función bien nombrada explica el *por qué* mejor de lo que una firma de tipos explica el *qué*. |
| "Esta abstracción podría ser útil más tarde" | No conserves abstracciones especulativas. Si no se usa ahora, es complejidad sin valor. Elimínala y vuelve a añadirla cuando se necesite. |
| "El autor original debía de tener una razón" | Quizás. Revisa el git blame: aplica la Valla de Chesterton. Pero la complejidad acumulada a menudo no tiene razón; es solo el residuo de la iteración bajo presión. |
| "Refactorizaré mientras añado esta función" | Separa la refactorización del trabajo de funciones. Los cambios mezclados son más difíciles de revisar, revertir y entender en el historial. |

## Señales de Alerta

- Simplificación que requiere modificar los tests para que pasen (probablemente cambiaste el comportamiento)
- Código "simplificado" que es más largo y más difícil de seguir que el original
- Renombrar cosas para que coincidan con tus preferencias en lugar de con las convenciones del proyecto
- Eliminar el manejo de errores porque "hace que el código sea más limpio"
- Simplificar código que no entiendes del todo
- Agrupar muchas simplificaciones en un commit grande y difícil de revisar
- Refactorizar código fuera del alcance de la tarea actual sin que te lo pidan

## Verificación

Después de completar una pasada de simplificación:

- [ ] Todos los tests existentes pasan sin modificación
- [ ] El build tiene éxito sin advertencias nuevas
- [ ] El linter/formateador pasa (sin regresiones de estilo)
- [ ] Cada simplificación es un cambio incremental y revisable
- [ ] El diff está limpio: sin cambios no relacionados mezclados
- [ ] El código simplificado sigue las convenciones del proyecto (verificado contra CLAUDE.md o equivalente)
- [ ] No se eliminó ni debilitó ningún manejo de errores
- [ ] No quedó código muerto (imports sin usar, ramas inalcanzables)
- [ ] Un compañero o agente de revisión aprobaría el cambio como una mejora neta
