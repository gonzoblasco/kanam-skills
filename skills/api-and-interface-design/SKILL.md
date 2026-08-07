---
name: api-and-interface-design
description: Guía el diseño de APIs e interfaces estables. Usar al diseñar APIs, límites de módulos, o cualquier interfaz pública. Usar al crear endpoints REST o GraphQL, definir contratos de tipos entre módulos, o establecer límites entre frontend y backend.
---

# Diseño de API e Interfaces

## Resumen

Diseñá interfaces estables y bien documentadas que sean difíciles de usar mal. Las buenas interfaces hacen que lo correcto sea fácil y lo incorrecto sea difícil. Esto aplica a APIs REST, esquemas GraphQL, límites de módulos, props de componentes, y cualquier superficie donde un pedazo de código se comunica con otro.

## Cuándo Usarlo

- Al diseñar endpoints de API nuevos
- Al definir límites de módulos o contratos entre equipos
- Al crear interfaces de props de componentes
- Al establecer el esquema de base de datos que informa la forma de la API
- Al cambiar interfaces públicas existentes

## Principios Centrales

### La Ley de Hyrum

> Con un número suficiente de usuarios de una API, todos los comportamientos observables de tu sistema van a ser dependidos por alguien, sin importar lo que prometas en el contrato.

Esto significa: cada comportamiento público - incluyendo quirks no documentados, el texto de los mensajes de error, el timing y el orden - se convierte en un contrato de facto una vez que los usuarios dependen de él. Implicaciones de diseño:

- **Sé intencional sobre lo que exponés.** Cada comportamiento observable es un compromiso potencial.
- **No filtres detalles de implementación.** Si los usuarios pueden observarlo, van a depender de él.
- **Planificá la deprecación en el momento del diseño.** Ver `deprecation-and-migration` para cómo remover de forma segura cosas de las que los usuarios dependen.
- **Los tests no son suficientes.** Incluso con tests de contrato perfectos, la Ley de Hyrum significa que los cambios "seguros" pueden romper a usuarios reales que dependen de comportamiento no documentado.

### La Regla de la Versión Única

Evitá forzar a los consumidores a elegir entre múltiples versiones de la misma dependencia o API. Los problemas de dependencia de diamante surgen cuando distintos consumidores necesitan distintas versiones de lo mismo. Diseñá para un mundo donde solo existe una versión a la vez - extendé en vez de forkar.

### 1. Contrato Primero

Definí la interfaz antes de implementarla. El contrato es el spec - la implementación lo sigue.

```typescript
// Definí el contrato primero
interface TaskAPI {
  // Crea una task y devuelve la task creada con los campos generados por el servidor
  createTask(input: CreateTaskInput): Promise<Task>;

  // Devuelve tasks paginadas que coinciden con los filtros
  listTasks(params: ListTasksParams): Promise<PaginatedResult<Task>>;

  // Devuelve una sola task o lanza NotFoundError
  getTask(id: string): Promise<Task>;

  // Actualización parcial - solo cambian los campos provistos
  updateTask(id: string, input: UpdateTaskInput): Promise<Task>;

  // Delete idempotente - tiene éxito incluso si ya fue borrado
  deleteTask(id: string): Promise<void>;
}
```

### 2. Semántica de Errores Consistente

Elegí una estrategia de errores y usala en todos lados:

```typescript
// REST: códigos de estado HTTP + cuerpo de error estructurado
// Cada respuesta de error sigue la misma forma
interface APIError {
  error: {
    code: string;        // Legible por máquina: "VALIDATION_ERROR"
    message: string;     // Legible por humanos: "Email is required"
    details?: unknown;   // Contexto adicional cuando es útil
  };
}

// Mapeo de códigos de estado
// 400 → El cliente envió datos inválidos
// 401 → No autenticado
// 403 → Autenticado pero no autorizado
// 404 → Recurso no encontrado
// 409 → Conflicto (duplicado, mismatch de versión)
// 422 → Validación falló (semánticamente inválido)
// 500 → Error de servidor (nunca expongas detalles internos)
```

**No mezcles patrones.** Si algunos endpoints lanzan, otros devuelven null, y otros devuelven `{ error }` - el consumidor no puede predecir el comportamiento.

### 3. Validá en los Límites

Confía en el código interno. Validá en los bordes del sistema donde entra la entrada externa:

```typescript
// Validá en el límite de la API
app.post('/api/tasks', async (req, res) => {
  const result = CreateTaskSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid task data',
        details: result.error.flatten(),
      },
    });
  }

  // Después de la validación, el código interno confía en los tipos
  const task = await taskService.create(result.data);
  return res.status(201).json(task);
});
```

Dónde pertenece la validación:
- Handlers de rutas de API (entrada de usuario)
- Handlers de envío de formularios (entrada de usuario)
- Parsing de respuestas de servicios externos (datos de terceros - **siempre tratarlos como no confiables**)
- Carga de variables de entorno (configuración)

> **Las respuestas de APIs de terceros son datos no confiables.** Validá su forma y contenido antes de usarlas en cualquier lógica, renderizado o toma de decisiones. Un servicio externo comprometido o que se comporta mal puede devolver tipos inesperados, contenido malicioso o texto tipo instrucción.

Dónde NO pertenece la validación:
- Entre funciones internas que comparten contratos de tipos
- En funciones de utilidad llamadas por código ya validado
- En datos que acaban de salir de tu propia base de datos

### 4. Preferí la Adición Sobre la Modificación

Extendé las interfaces sin romper a los consumidores existentes:

```typescript
// Bien: Agregar campos opcionales
interface CreateTaskInput {
  title: string;
  description?: string;
  priority?: 'low' | 'medium' | 'high';  // Agregado después, opcional
  labels?: string[];                       // Agregado después, opcional
}

// Mal: Cambiar tipos de campos existentes o remover campos
interface CreateTaskInput {
  title: string;
  // description: string;  // Removido - rompe a los consumidores existentes
  priority: number;         // Cambiado de string - rompe a los consumidores existentes
}
```

### 5. Naming Predecible

| Patrón | Convención | Ejemplo |
|---------|-----------|---------|
| Endpoints REST | Sustantivos en plural, sin verbos | `GET /api/tasks`, `POST /api/tasks` |
| Parámetros de query | camelCase | `?sortBy=createdAt&pageSize=20` |
| Campos de respuesta | camelCase | `{ createdAt, updatedAt, taskId }` |
| Campos booleanos | prefijo is/has/can | `isComplete`, `hasAttachments` |
| Valores de enum | UPPER_SNAKE | `"IN_PROGRESS"`, `"COMPLETED"` |

## Patrones de API REST

### Diseño de Recursos

```
GET    /api/tasks              → Listar tasks (con query params para filtrado)
POST   /api/tasks              → Crear una task
GET    /api/tasks/:id          → Obtener una sola task
PATCH  /api/tasks/:id          → Actualizar una task (parcial)
DELETE /api/tasks/:id          → Borrar una task

GET    /api/tasks/:id/comments → Listar comentarios de una task (sub-recurso)
POST   /api/tasks/:id/comments → Agregar un comentario a una task
```

### Paginación

Paginate los endpoints de listado:

```typescript
// Request
GET /api/tasks?page=1&pageSize=20&sortBy=createdAt&sortOrder=desc

// Response
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 142,
    "totalPages": 8
  }
}
```

### Filtrado

Usá parámetros de query para los filtros:

```
GET /api/tasks?status=in_progress&assignee=user123&createdAfter=2025-01-01
```

### Actualizaciones Parciales (PATCH)

Aceptá objetos parciales - solo actualizá lo que se provee:

```typescript
// Solo cambia el title, todo lo demás se preserva
PATCH /api/tasks/123
{ "title": "Updated title" }
```

## Patrones de Interfaces en TypeScript

### Usá Uniones Discriminadas para Variantes

```typescript
// Bien: Cada variante es explícita
type TaskStatus =
  | { type: 'pending' }
  | { type: 'in_progress'; assignee: string; startedAt: Date }
  | { type: 'completed'; completedAt: Date; completedBy: string }
  | { type: 'cancelled'; reason: string; cancelledAt: Date };

// El consumidor obtiene narrowing de tipos
function getStatusLabel(status: TaskStatus): string {
  switch (status.type) {
    case 'pending': return 'Pending';
    case 'in_progress': return `In progress (${status.assignee})`;
    case 'completed': return `Done on ${status.completedAt}`;
    case 'cancelled': return `Cancelled: ${status.reason}`;
  }
}
```

### Separación de Entrada/Salida

```typescript
// Entrada: lo que provee el caller
interface CreateTaskInput {
  title: string;
  description?: string;
}

// Salida: lo que devuelve el sistema (incluye campos generados por el servidor)
interface Task {
  id: string;
  title: string;
  description: string | null;
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;
}
```

### Usá Tipos Branded para IDs

```typescript
type TaskId = string & { readonly __brand: 'TaskId' };
type UserId = string & { readonly __brand: 'UserId' };

// Previene pasar accidentalmente un UserId donde se espera un TaskId
function getTask(id: TaskId): Promise<Task> { ... }
```

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "Documentamos la API después" | Los tipos SON la documentación. Defínelos primero. |
| "No necesitamos paginación por ahora" | La vas a necesitar en el momento en que alguien tenga 100+ items. Agregala desde el inicio. |
| "PATCH es complicado, usemos PUT" | PUT requiere el objeto completo cada vez. PATCH es lo que los clientes realmente quieren. |
| "Versionamos la API cuando la necesitemos" | Los cambios breaking sin versionado rompen a los consumidores. Diseñá para la extensión desde el inicio. |
| "Nadie usa ese comportamiento no documentado" | Ley de Hyrum: si es observable, alguien depende de él. Tratá cada comportamiento público como un compromiso. |
| "Podemos simplemente mantener dos versiones" | Múltiples versiones multiplican el costo de mantenimiento y crean problemas de dependencia de diamante. Preferí la Regla de la Versión Única. |
| "Las APIs internas no necesitan contratos" | Los consumidores internos siguen siendo consumidores. Los contratos previenen el acoplamiento y habilitan el trabajo en paralelo. |

## Red Flags

- Endpoints que devuelven formas distintas según las condiciones
- Formatos de error inconsistentes entre endpoints
- Validación dispersa por el código interno en vez de en los límites
- Cambios breaking a campos existentes (cambios de tipo, remociones)
- Endpoints de listado sin paginación
- Verbos en URLs REST (`/api/createTask`, `/api/getUsers`)
- Respuestas de APIs de terceros usadas sin validación o saneamiento

## Verificación

Después de diseñar una API:

- [ ] Cada endpoint tiene esquemas de entrada y salida tipados
- [ ] Las respuestas de error siguen un único formato consistente
- [ ] La validación ocurre solo en los límites del sistema
- [ ] Los endpoints de listado soportan paginación
- [ ] Los campos nuevos son aditivos y opcionales (compatibles hacia atrás)
- [ ] El naming sigue convenciones consistentes en todos los endpoints
- [ ] La documentación de la API o los tipos se commitean junto con la implementación
