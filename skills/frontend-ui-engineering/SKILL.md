---
name: frontend-ui-engineering
description: Construye UIs de cara al usuario de calidad de producción, accesibles y responsivas. Integra estándares de accesibilidad (WCAG 2.1 AA), adherencia a design systems y prompts de generación para la creación de componentes. Úsala al construir o modificar interfaces, crear componentes, implementar layouts, manejar estado, o cuando el resultado deba verse y sentirse de calidad de producción en lugar de generado por IA.
---

# Ingeniería de UI Frontend

## Resumen

Construye interfaces de usuario de calidad de producción que sean accesibles, performantes y pulidas visualmente. Esta skill integra **estándares de accesibilidad (WCAG 2.1 AA)**, **adherencia a design systems** y **prompts de generación de componentes** para crear UIs que parezcan construidas por un ingeniero con consciencia de diseño, no generadas por IA.

## Cuándo Usarla

- Construir nuevos componentes o páginas de UI
- Modificar interfaces existentes de cara al usuario
- Implementar layouts responsivos
- Agregar interactividad o manejo de estado
- Corregir problemas visuales, de accesibilidad o de UX
- Crear patrones de componentes reutilizables a partir de specs de diseño

---

## 🎨 Fase 1: Integración con el Design System

### Estructura de Archivos (Componentes Colocados con su Contexto)

```
src/components/
  TaskList/
    TaskList.tsx           # Implementación del componente
    TaskList.test.tsx      # Tests + cheques de accesibilidad
    TaskList.stories.tsx   # Storybook stories
    use-task-list.ts       # Custom hook (estado complejo)
    types.ts               # Tipos específicos del componente
    _story-prompt.md       # Prompt de generación por IA para el componente
```

### Integración de Design Tokens

Al crear componentes, asegura la alineación con:
- **Paleta de colores**: usa tokens semánticos (`text-primary`, `bg-surface`), no valores hex crudos
- **Jerarquía tipográfica**: sigue la escala tipográfica del design system
- **Escala de espaciado**: usa incrementos consistentes (0.25rem o equivalente)
- **Radio de borde**: valores consistentes de los design tokens
- **Movimiento**: respeta las preferencias de movimiento y las duraciones de transición

---

## ♿ Fase 2: Accesibilidad (Cumplimiento WCAG 2.1 AA)

Todo componente debe cumplir estos estándares de accesibilidad:

### ✅ Checklist de Navegación por Teclado
```tsx
// Todo elemento interactivo debe ser accesible por teclado
<button onClick={handleClick}>✓ Accesible</button>
<div onClick={handleClick}>✗ No enfocable: SE REQUIERE FIX</div>
<div role="button" tabIndex={0}>✓ Pero prefiere <button></button></div>
```

### ✅ Implementación de Etiquetas ARIA
- Etiqueta los elementos interactivos que no tienen texto visible: `<button aria-label="Cerrar diálogo">`
- Etiqueta los inputs de formulario con asociaciones apropiadas: `<label htmlFor="email">Email</label><input id="email">`
- Usa `aria-label` cuando no existe una etiqueta visible

### ✅ Estrategia de Gestión de Foco
```tsx
// Mueve el foco cuando cambia el contenido
function Dialog({ isOpen, onClose }) {
  const closeRef = useRef(null);
  
  useEffect(() => {
    if (isOpen) closeRef.current?.focus(); // Atrapa el foco dentro del diálogo
  }, [isOpen]);
  
  return <dialog open={isOpen} aria-labelledby="dialog-title">...</dialog>;
}
```

### ✅ Workflow de Pruebas con Lector de Pantalla
1. Usa un lector de pantalla (VoiceOver, NVDA, JAWS) para navegar el componente
2. Verifica que el orden de navegación sea lógico y significativo
3. Confirma que los skip links funcionen y anuncien el contenido correctamente
4. Asegura que los estados de error se anuncien con mensajes claros
5. Prueba la gestión del foco en las actualizaciones de contenido dinámico

### ✅ Estados Vacíos y de Error (Sin Pantallas en Blanco)
```tsx
// ✗ MAL: pantalla en blanco
if (tasks.length === 0) return null;

// ✓ BIEN: estado vacío significativo
if (tasks.length === 0) {
  return (
    <div role="status" aria-label="No tasks">
      <EmptyStateIcon className="mx-auto h-12 w-12 text-muted"/>
      <h3>No tasks yet</h3>
      <p>Get started by creating your first task</p>
      <Button onClick={onCreateTask}>Create Task</Button>
    </div>
  );
}
```

---

## 📱 Fase 3: Diseño Responsivo (Mobile-First)

### Estrategia de Breakpoints
Prueba en estos breakpoints críticos:
- **320px** - Ancho móvil mínimo
- **768px** - Tablet vertical
- **1024px** - Tablet horizontal
- **1440px** - Punto de entrada para desktop
- **1920px+** - Monitores desktop grandes

### Implementación Mobile-First
```tsx
// Tailwind: responsive mobile-first
<div className="
  grid grid-cols-1       /* Móvil: una sola columna */
  sm:grid-cols-2         /* Small: 2 columnas */
  md:grid-cols-3         /* Medium: 3 columnas */
  lg:grid-cols-4         /* Large: 4 columnas */
  gap-4
">
```

---

## ⚡ Fase 4: Carga y Transiciones

### Skeleton Loading (No Spinners)
```tsx
function TaskListSkeleton() {
  return (
    <div className="space-y-3" aria-busy="true" aria-label="Loading tasks">
      {Array.from({ length: 3 }).map((_, i) => (
        <div key={i} className="h-12 bg-muted animate-pulse rounded"/>
      ))}
    </div>
  );
}
```

### Actualizaciones Optimistas
Usa actualizaciones optimistas de UI con fallbacks apropiados al implementar mutaciones.

---

## 🔒 Fase 5: Patrones de Arquitectura de Componentes

### Composición sobre Configuración
```tsx
// ✓ BIEN: Componible
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
</Card>

// ✗ MAL: Sobre-configurado (pesadilla de prop drilling)
<Card title="Title" variant="large" bodyPadding="md">...</Card>
```

### Jerarquía de Manejo de Estado
```
Estado local (useState)          → Estado de UI específico del componente
Estado elevado                   → Compartido entre 2-3 componentes hermanos
Context                          → Tema, auth, locale (muchas lecturas, pocas escrituras)
Estado de URL (searchParams)     → Filtros, paginación, estado de UI compartible
Estado de servidor (React Query, SWR) → Datos remotos con caché
Store global (Zustand, Redux)    → Estado complejo de cliente en toda la app
```

### Evita el Prop Drilling de más de 3 Niveles
Si estás pasando props a través de componentes que no las usan, introduce un context o reestructura el árbol de componentes.

---

## 🚫 Anti-Patrones Comunes a Evitar

| Anti-Patrón | Por Qué Es Malo | Fix de Producción |
|--------------|--------------|----------------|
| Gradientes excesivos | Agregan ruido visual, chocan con los design systems | Colores planos que coinciden con los design tokens |
| Todo redondeado (rounded-2xl) | Ignora la jerarquía de radios de esquina en diseños reales | Radio de borde consistente del design system |
| Morado/índigo por todos lados | Hace que toda app se vea idéntica a las apps generadas por IA | Usa la paleta de colores real del proyecto |
| Secciones hero genéricas | Impulsadas por plantillas, sin conexión con el contenido real | Layouts de contenido primero a partir de copy real |
| Texto placeholder Lorem ipsum | Oculta problemas de layout que el contenido real revela | Contenido placeholder realista (longitudes aproximadas) |
| Padding sobredimensionado por todos lados | Destruye la jerarquía visual y desperdicia espacio | Escala de espaciado consistente |
| Grillas de cards genéricas | Atajo de layout que ignora la prioridad de la información | Layouts impulsados por el propósito |
| Diseño con muchas sombras | Las sombras en capas ralentizan el render en dispositivos de gama baja | Sombras sutiles o ausentes salvo que el design system las especifique |

---

## 🔍 Checklist de Verificación

Después de construir la UI, verifica todo lo siguiente:

- [ ] El componente renderiza sin errores de consola
- [ ] Todos los elementos interactivos son accesibles por teclado (Tabulación por la página)
- [ ] El lector de pantalla puede transmitir el contenido y la estructura de la página
- [ ] Responsivo: funciona a 320px, 768px, 1024px, 1440px, 1920px+
- [ ] Los estados de carga, error y vacío están todos manejados
- [ ] Sigue el design system del proyecto (espaciado, colores, tipografía)
- [ ] Sin advertencias de accesibilidad en dev tools ni axe-core
- [ ] Sin estilos inline ni valores de píxeles arbitrarios
- [ ] La gestión del foco funciona correctamente en el contenido dinámico
- [ ] El color no es el único indicador de estado (usa también íconos/texto/patrones)

---

## Racionalizaciones Comunes y Verificación de Realidad

| Racionalización | Realidad |
|-----------------|---------|
| "La accesibilidad es un nice-to-have" | Es un requisito legal en muchas jurisdicciones y un estándar de calidad de ingeniería. |
| "Lo haremos responsivo después" | Reacondicionar el diseño responsivo es 3x más difícil que construirlo desde el inicio. |
| "El diseño no está final, así que me salto el estilo" | Usa los defaults del design system. La UI sin estilo crea una mala primera impresión para los revisores. |
| "Esto es solo un prototipo" | Los prototipos se convierten en código de producción. Construye la base bien. |
| "La estética IA está bien por ahora" | Señala baja calidad y requerirá retrabajo después. Usa el design system real del proyecto desde el inicio. |
| "Agregaré las etiquetas ARIA después de que la feature funcione" | La accesibilidad va primero. Implementa HTML semántico y ARIA desde el día uno. |

---

## Red Flags (Acción Inmediata Requerida)

- Componentes con más de 200 líneas: divídelos
- Estilos inline o valores de píxeles arbitrarios: extráelos a variables CSS o design tokens
- Faltan estados de error, de carga o vacíos: agrega los tres
- Sin pruebas de navegación por teclado: prueba de inmediato
- Color como único indicador de estado: agrega íconos/texto/patrones
- "Look IA" genérico (gradientes morados, cards sobredimensionadas, layouts genéricos): refactoriza para que coincida con el design system

---

## Prompts de Generación de IA para Componentes

Cuando uses IA para generar componentes, usa estos prompts:

```markdown
Generate a React component that is:
1. Accessible by default (keyboard navigable, ARIA labels where needed)
2. Responsive by default (mobile-first approach)
3. Semantic HTML (use proper tags: button not div for clicks)
4. Using design tokens from the project (spacing, colors, typography)
5. No inline styles (CSS modules or styled-components)
6. Testing included (unit + E2E)

Avoid:
- Arbitrary pixel values
- Gradient backgrounds unless specified
- Color-only state indicators
- Prop drilling beyond 3 levels
```

---

## Recursos

Para requisitos de accesibilidad detallados y herramientas de prueba, ver `references/accessibility-checklist.md`.
