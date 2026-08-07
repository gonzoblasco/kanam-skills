# Referencia de patrones de testing (JavaScript/TypeScript)

Referencia rápida de patrones de testing de JavaScript/TypeScript: Jest, React Testing Library, Supertest y Playwright, que ilustran los principios universales de la skill `test-driven-development`. Los principios (Arrange-Act-Assert, nombrado, disciplina de mocks, anti-patrones) aplican en cualquier ecosistema; la sintaxis y el tooling mostrados aquí son específicos de JS/TS. En otro stack, sigue los mismos principios con el framework y los comandos de test propios del repositorio.

## Tabla de contenidos

- [Estructura de tests (Arrange-Act-Assert)](#estructura-de-tests-arrange-act-assert)
- [Convenciones de nombrado de tests](#convenciones-de-nombrado-de-tests)
- [Aserciones comunes](#aserciones-comunes)
- [Patrones de mocking](#patrones-de-mocking)
- [Testing de React/Componentes](#testing-de-reactcomponentes)
- [Testing de API / Integración](#testing-de-api--integración)
- [Testing E2E (Playwright)](#testing-e2e-playwright)
- [Anti-patrones de tests](#anti-patrones-de-tests)

## Estructura de tests (Arrange-Act-Assert)

```typescript
it('describe el comportamiento esperado', () => {
  // Arrange: prepara los datos del test y las precondiciones
  const input = { title: 'Tarea de Test', priority: 'high' };

  // Act: ejecuta la acción que se está probando
  const result = createTask(input);

  // Assert: verifica el resultado
  expect(result.title).toBe('Tarea de Test');
  expect(result.priority).toBe('high');
  expect(result.status).toBe('pending');
});
```

## Convenciones de nombrado de tests

```typescript
// Patrón: [unidad] [comportamiento esperado] [condición]
describe('TaskService.createTask', () => {
  it('crea una tarea con estado pending por defecto', () => {});
  it('lanza ValidationError cuando el título está vacío', () => {});
  it('recorta los espacios en blanco del título', () => {});
  it('genera un ID único para cada tarea', () => {});
});
```

## Aserciones comunes

```typescript
// Igualdad
expect(result).toBe(expected);           // Igualdad estricta (===)
expect(result).toEqual(expected);        // Igualdad profunda (objetos/arrays)
expect(result).toStrictEqual(expected);  // Igualdad profunda + coincidencia de tipos

// Verdad / falsedad
expect(result).toBeTruthy();
expect(result).toBeFalsy();
expect(result).toBeNull();
expect(result).toBeDefined();
expect(result).toBeUndefined();

// Números
expect(result).toBeGreaterThan(5);
expect(result).toBeLessThanOrEqual(10);
expect(result).toBeCloseTo(0.3, 5);      // Punto flotante

// Cadenas
expect(result).toMatch(/pattern/);
expect(result).toContain('substring');

// Arrays / Objetos
expect(array).toContain(item);
expect(array).toHaveLength(3);
expect(object).toHaveProperty('key', 'value');

// Errores
expect(() => fn()).toThrow();
expect(() => fn()).toThrow(ValidationError);
expect(() => fn()).toThrow('mensaje específico');

// Async
await expect(asyncFn()).resolves.toBe(value);
await expect(asyncFn()).rejects.toThrow(Error);
```

## Patrones de mocking

### Funciones mock

```typescript
const mockFn = jest.fn();
mockFn.mockReturnValue(42);
mockFn.mockResolvedValue({ data: 'test' });
mockFn.mockImplementation((x) => x * 2);

expect(mockFn).toHaveBeenCalled();
expect(mockFn).toHaveBeenCalledWith('arg1', 'arg2');
expect(mockFn).toHaveBeenCalledTimes(3);
```

### Módulos mock

```typescript
// Mockea un módulo completo
jest.mock('./database', () => ({
  query: jest.fn().mockResolvedValue([{ id: 1, title: 'Test' }]),
}));

// Mockea exports específicos
jest.mock('./utils', () => ({
  ...jest.requireActual('./utils'),
  generateId: jest.fn().mockReturnValue('test-id'),
}));
```

### Mockea solo en los límites

```
Mockea estos:                    No mockees estos:
├── Llamadas a la base de datos   ├── Funciones de utilidad internas
├── Peticiones HTTP               ├── Lógica de negocio
├── Operaciones del sistema de archivos  ├── Transformaciones de datos
├── Llamadas a APIs externas      ├── Funciones de validación
└── Tiempo/Fecha (cuando se necesite)    └── Funciones puras
```

## Testing de React/Componentes

```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';

describe('TaskForm', () => {
  it('envía el formulario con los datos ingresados', async () => {
    const onSubmit = jest.fn();
    render(<TaskForm onSubmit={onSubmit} />);

    // Encuentra elementos por rol/etiqueta accesible (no por test IDs)
    await screen.findByRole('textbox', { name: /título/i });
    fireEvent.change(screen.getByRole('textbox', { name: /título/i }), {
      target: { value: 'Nueva Tarea' },
    });
    fireEvent.click(screen.getByRole('button', { name: /crear/i }));

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({ title: 'Nueva Tarea' });
    });
  });

  it('muestra un error de validación para título vacío', async () => {
    render(<TaskForm onSubmit={jest.fn()} />);

    fireEvent.click(screen.getByRole('button', { name: /crear/i }));

    expect(await screen.findByText(/el título es obligatorio/i)).toBeInTheDocument();
  });
});
```

## Testing de API / Integración

```typescript
import request from 'supertest';
import { app } from '../src/app';

describe('POST /api/tasks', () => {
  it('crea una tarea y devuelve 201', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({ title: 'Tarea de Test' })
      .set('Authorization', `Bearer ${testToken}`)
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      title: 'Tarea de Test',
      status: 'pending',
    });
  });

  it('devuelve 422 para entrada inválida', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({ title: '' })
      .set('Authorization', `Bearer ${testToken}`)
      .expect(422);

    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('devuelve 401 sin autenticación', async () => {
    await request(app)
      .post('/api/tasks')
      .send({ title: 'Test' })
      .expect(401);
  });
});
```

## Testing E2E (Playwright)

```typescript
import { test, expect } from '@playwright/test';

test('el usuario puede crear y completar una tarea', async ({ page }) => {
  // Navega y autentica
  await page.goto('/');
  await page.getByRole('textbox', { name: /email/i }).fill('test@example.com');
  await page.getByLabel(/password/i).fill('testpass123');
  await page.getByRole('button', { name: /iniciar sesión/i }).click();

  // Crea una tarea
  await page.getByRole('button', { name: /nueva tarea/i }).click();
  await page.getByRole('textbox', { name: /título/i }).fill('Comprar víveres');
  await page.getByRole('button', { name: /crear/i }).click();

  // Verifica que la tarea aparezca
  const task = page.getByRole('listitem', { name: /comprar víveres/i });
  await expect(task).toBeVisible();

  // Completa la tarea
  await task.getByRole('checkbox', { name: /completar comprar víveres/i }).check();
  await expect(task).toHaveCSS('text-decoration-line', 'line-through');
});
```

## Anti-patrones de tests

| Anti-patrón | Problema | Mejor enfoque |
|---|---|---|
| Probar detalles de implementación | Se rompe en el refactor | Prueba entradas/salidas |
| Snapshot de todo | Nadie revisa los diffs de snapshot | Afirma valores específicos |
| Estado mutable compartido | Los tests se contaminan entre sí | Setup/teardown por test |
| Probar código de terceros | Pierde tiempo, no es tu bug | Mockea el límite |
| Omitir tests para pasar CI | Oculta bugs reales | Arregla o elimina el test |
| Usar `test.skip` permanentemente | Código muerto | Elimínalo o arréglalo |
| Aserciones demasiado amplias | No detecta regresiones | Sé específico |
| Sin manejo de errores async | Errores tragados, falsos positivos | Siempre `await` en tests async |
