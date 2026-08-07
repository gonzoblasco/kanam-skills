# Checklist de Accesibilidad

Referencia rapida para el cumplimiento de WCAG 2.1 AA. Usala junto con la skill `frontend-ui-engineering`.

## Tabla de Contenidos

- [Chequeos Esenciales](#chequeos-esenciales)
- [Patrones HTML Comunes](#patrones-html-comunes)
- [Herramientas de Prueba](#herramientas-de-prueba)
- [Referencia Rapida: Regiones ARIA Live](#referencia-rapida-regiones-aria-live)
- [Anti-Patrones Comunes](#anti-patrones-comunes)

## Chequeos Esenciales

### Navegacion por Teclado
- [ ] Todos los elementos interactivos son enfocables con la tecla Tab
- [ ] El orden del foco sigue el orden visual/logico
- [ ] El foco es visible (outline/anillo en los elementos enfocados)
- [ ] Los widgets personalizados tienen soporte de teclado (Enter para activar, Escape para cerrar)
- [ ] No hay trampas de teclado (el usuario siempre puede salir de un componente con Tab)
- [ ] Enlace "saltar al contenido" en la parte superior de la pagina: visible (al menos) al recibir el foco del teclado
- [ ] Los modales atrapan el foco mientras estan abiertos y lo devuelven al cerrarse

### Lectores de Pantalla
- [ ] Todas las imagenes tienen texto `alt` (o `alt=""` para imagenes decorativas)
- [ ] Todos los inputs de formulario tienen labels asociados (`<label>` o `aria-label`)
- [ ] Los botones y enlaces tienen texto descriptivo (no "Hace clic aca")
- [ ] Los botones de solo icono tienen `aria-label`
- [ ] La pagina tiene un solo `<h1>` y los encabezados no saltan niveles
- [ ] Los cambios de contenido dinamico se anuncian (regiones `aria-live`)
- [ ] Las tablas tienen headers `<th>` con scope

### Visual
- [ ] Contraste del texto >= 4.5:1 (texto normal) o >= 3:1 (texto grande, 18px+)
- [ ] Contraste de los componentes de UI >= 3:1 contra el fondo
- [ ] El color no es la unica forma de transmitir informacion
- [ ] El texto es redimensionable al 200% sin romper el layout
- [ ] No hay contenido que parpadee mas de 3 veces por segundo

### Formularios
- [ ] Cada input tiene un label visible
- [ ] Los campos obligatorios estan indicados (no solo por color)
- [ ] Los mensajes de error son especificos y estan asociados con el campo
- [ ] El estado de error es visible por mas que solo el color (icono, texto, borde)
- [ ] Los errores de envio del formulario se resumen y son enfocables
- [ ] Los campos conocidos usan autocomplete (por ejemplo `type="email" autocomplete="email"`)

### Contenido
- [ ] Idioma declarado (`<html lang="en">`)
- [ ] La pagina tiene un `<title>` descriptivo
- [ ] Los enlaces se distinguen del texto circundante (no solo por color)
- [ ] Los objetivos táctiles son >= 44x44px en movil
- [ ] Estados vacios significativos (no pantallas en blanco)

## Patrones HTML Comunes

### Botones vs. Enlaces

```html
<!-- Usa <button> para acciones -->
<button onClick={handleDelete}>Delete Task</button>

<!-- Usa <a> para navegacion -->
<a href="/tasks/123">View Task</a>

<!-- NUNCA uses div/span como botones -->
<div onClick={handleDelete}>Delete</div>  <!-- MAL -->
```

### Labels de Formulario

```html
<!-- Asociacion explicita del label -->
<label htmlFor="email">Email address</label>
<input id="email" type="email" required />

<!-- Envolver implicitamente -->
<label>
  Email address
  <input type="email" required />
</label>

<!-- Label oculto (se prefiere el label visible) -->
<input type="search" aria-label="Search tasks" />
```

### Roles ARIA

```html
<!-- Navegacion -->
<nav aria-label="Main navigation">...</nav>
<nav aria-label="Footer links">...</nav>

<!-- Mensajes de estado -->
<div role="status" aria-live="polite">Task saved</div>

<!-- Mensajes de alerta -->
<div role="alert">Error: Title is required</div>

<!-- Dialogos modales -->
<dialog aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Confirm Delete</h2>
  ...
</dialog>

<!-- Estados de carga -->
<div aria-busy="true" aria-label="Loading tasks">
  <Spinner />
</div>
```

### Listas Accesibles

```html
<ul role="list" aria-label="Tasks">
  <li>
    <input type="checkbox" id="task-1" aria-label="Complete: Buy groceries" />
    <label htmlFor="task-1">Buy groceries</label>
  </li>
</ul>
```

## Herramientas de Prueba

```bash
# Auditoria automatizada
npx axe-core          # Pruebas de accesibilidad programaticas
npx pa11y             # Chequeador de accesibilidad CLI

# En el navegador
# Chrome DevTools -> Lighthouse -> Accessibility
# Chrome DevTools -> Elements -> Accessibility tree

# Pruebas con lector de pantalla
# macOS: VoiceOver (Cmd + F5)
# Windows: NVDA (gratis) o JAWS
# Linux: Orca
```

## Referencia Rapida: Regiones ARIA Live

| Valor | Comportamiento | Usar Para |
|-------|----------------|-----------|
| `aria-live="polite"` | Se anuncia en la proxima pausa | Actualizaciones de estado, confirmaciones de guardado |
| `aria-live="assertive"` | Se anuncia inmediatamente | Errores, alertas sensibles al tiempo |
| `role="status"` | Igual que `polite` | Mensajes de estado |
| `role="alert"` | Igual que `assertive` | Mensajes de error |

## Anti-Patrones Comunes

| Anti-Patron | Problema | Solucion |
|---|---|---|
| `div` como boton | No es enfocable, sin soporte de teclado | Usa `<button>` |
| Falta de texto `alt` | Las imagenes son invisibles para los lectores de pantalla | Agrega `alt` descriptivo |
| Estados solo por color | Invisibles para usuarios con daltonismo | Agrega iconos, texto o patrones |
| Media con autoplay | Desorienta, no se puede detener | Agrega controles, no uses autoplay |
| Dropdown personalizado sin ARIA | Inutilizable por teclado/lector de pantalla | Usa `<select>` nativo o un listbox ARIA apropiado |
| Eliminar los outlines de foco | Los usuarios no pueden ver donde estan | Estiliza los outlines, no los elimines |
| Enlaces/botones vacios | "Enlace" anunciado sin descripcion | Agrega texto o `aria-label` |
| `tabindex > 0` | Rompe el orden natural del tab | Usa solo `tabindex="0"` o `-1` |
