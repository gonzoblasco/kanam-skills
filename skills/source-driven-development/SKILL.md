---
name: source-driven-development
description: Fundamenta toda decisión de implementación en la documentación oficial. Úsala cuando quieras código con autoridad, citado de fuentes y libre de patrones obsoletos. Úsala al construir con cualquier framework o librería donde la corrección importe.
---

# Desarrollo Impulsado por Fuentes

## Resumen

Toda decisión de código específica de un framework debe estar respaldada por documentación oficial. No implementes de memoria: verifica, cita y deja que el usuario vea tus fuentes. Los datos de entrenamiento se vuelven obsoletos, las APIs se deprecan, las mejores prácticas evolucionan. Esta skill garantiza que el usuario reciba código en el que pueda confiar porque cada patrón se remonta a una fuente autoritativa que puede verificar.

## Cuándo Usarla

- El usuario quiere código que siga las mejores prácticas actuales para un framework dado
- Construir boilerplate, código de arranque o patrones que se copiarán en todo un proyecto
- El usuario pide explícitamente una implementación documentada, verificada o "correcta"
- Implementar features donde el enfoque recomendado del framework importa (formularios, routing, fetching de datos, manejo de estado, auth)
- Revisar o mejorar código que usa patrones específicos de un framework
- Cada vez que estés a punto de escribir código específico de un framework desde la memoria

**Cuándo NO usarla:**

- La corrección no depende de una versión específica (renombrar variables, corregir typos, mover archivos)
- Lógica pura que funciona igual en todas las versiones (loops, condicionales, estructuras de datos)
- El usuario quiere explícitamente velocidad sobre verificación ("hazlo rápido nomás")

## El Proceso

```
DETECTAR ──→ OBTENER ──→ IMPLEMENTAR ──→ CITAR
  │          │           │            │
  ▼          ▼           ▼            ▼
 Qué        Conseguir   Seguir los   Mostrar tus
 stack?     la doc      patrones      fuentes
            relevante   documentados
```

### Paso 1: Detectar Stack y Versiones

Lee el archivo de dependencias del proyecto para identificar las versiones exactas:

```
package.json    → Node/React/Vue/Angular/Svelte
composer.json   → PHP/Symfony/Laravel
requirements.txt / pyproject.toml → Python/Django/Flask
go.mod          → Go
Cargo.toml      → Rust
Gemfile         → Ruby/Rails
```

Declara explícitamente lo que encontraste:

```
STACK DETECTADO:
- React 19.1.0 (de package.json)
- Vite 6.2.0
- Tailwind CSS 4.0.3
→ Obteniendo la documentación oficial de los patrones relevantes.
```

Si faltan versiones o son ambiguas, **pregunta al usuario**. No adivines: la versión determina qué patrones son correctos.

### Paso 2: Obtener Documentación Oficial

Obtén la página de documentación específica de la feature que estás implementando. No la homepage, no la doc completa: la página relevante.

**Jerarquía de fuentes (en orden de autoridad):**

| Prioridad | Fuente | Ejemplo |
|----------|--------|---------|
| 1 | Documentación oficial | react.dev, docs.djangoproject.com, symfony.com/doc |
| 2 | Blog / changelog oficial | react.dev/blog, nextjs.org/blog |
| 3 | Referencias de estándares web | MDN, web.dev, html.spec.whatwg.org |
| 4 | Compatibilidad de navegador/runtime | caniuse.com, node.green |

**No autoritativas: nunca citar como fuentes primarias:**

- Respuestas de Stack Overflow
- Posts de blog o tutoriales (incluso populares)
- Documentación o resúmenes generados por IA
- Tus propios datos de entrenamiento (ese es el punto: verifícalo)

**Sé preciso con lo que obtienes:**

```
MAL:  Obtener la homepage de React
BIEN: Obtener react.dev/reference/react/useActionState

MAL:  Buscar "django authentication best practices"
BIEN: Obtener docs.djangoproject.com/en/6.0/topics/auth/
```

Después de obtener, extrae los patrones clave y anota cualquier advertencia de deprecación o guía de migración.

Cuando las fuentes oficiales se contradicen entre sí (ej: una guía de migración contradice la referencia de la API), superficial la discrepancia al usuario y verifica qué patrón realmente funciona contra la versión detectada.

### Paso 3: Implementar Siguiendo los Patrones Documentados

Escribe código que coincida con lo que muestra la documentación:

- Usa las firmas de API de la doc, no de memoria
- Si la doc muestra una forma nueva de hacer algo, usa la forma nueva
- Si la doc depreca un patrón, no uses la versión deprecada
- Si la doc no cubre algo, márcalo como no verificado

**Cuando la doc conflictúa con el código existente del proyecto:**

```
CONFLICTO DETECTADO:
La base de código existente usa useState para el estado de carga del formulario,
pero la doc de React 19 recomienda useActionState para este patrón.
(Fuente: react.dev/reference/react/useActionState)

Opciones:
A) Usar el patrón moderno (useActionState): consistente con la doc actual
B) Coincidir con el código existente (useState): consistente con la base de código
→ ¿Qué enfoque prefieres?
```

Superficia el conflicto. No elijas uno en silencio.

### Paso 4: Citar Tus Fuentes

Todo patrón específico de framework recibe una cita. El usuario debe poder verificar cada decisión.

**En comentarios de código:**

```typescript
// Manejo de formularios React 19 con useActionState
// Fuente: https://react.dev/reference/react/useActionState#usage
const [state, formAction, isPending] = useActionState(submitOrder, initialState);
```

**En la conversación:**

```
Estoy usando useActionState en lugar de useState manual para el
estado de envío del formulario. React 19 reemplazó el patrón manual
isPending/setIsPending con este hook.

Fuente: https://react.dev/blog/2024/12/05/react-19#actions
"useTransition now supports async functions [...] to handle
pending states automatically"
```

**Reglas de citación:**

- URLs completas, no acortadas
- Prefiere enlaces profundos con anclas cuando sea posible (ej: `/useActionState#usage` sobre `/useActionState`): las anclas sobreviven mejor a la reestructuración de la doc que las páginas de nivel superior
- Cita el pasaje relevante cuando respalda una decisión no obvia
- Incluye datos de soporte de navegador/runtime al recomendar features de plataforma
- Si no puedes encontrar documentación para un patrón, dilo explícitamente:

```
SIN VERIFICAR: No pude encontrar documentación oficial para este
patrón. Se basa en datos de entrenamiento y puede estar desactualizado.
Verifica antes de usarlo en producción.
```

La honestidad sobre lo que no pudiste verificar vale más que la falsa confianza.

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "Estoy seguro sobre esta API" | La confianza no es evidencia. Los datos de entrenamiento contienen patrones obsoletos que parecen correctos pero se rompen contra versiones actuales. Verifica. |
| "Obtener la doc gasta tokens" | Alucinar una API gasta más. El usuario depura durante una hora y luego descubre que la firma de la función cambió. Una sola fetch previene horas de retrabajo. |
| "La doc no tendrá lo que necesito" | Si la doc no lo cubre, esa es información valiosa: el patrón puede no estar recomendado oficialmente. |
| "Solo lo mencionaré como posiblemente desactualizado" | Un disclaimer no ayuda. O verifica y cita, o márcalo claramente como sin verificar. El subterfugio es la peor opción. |
| "Esto es una tarea simple, no hace falta verificar" | Las tareas simples con patrones incorrectos se vuelven plantillas. El usuario copia tu handler de formulario deprecado a diez componentes antes de descubrir que existe el enfoque moderno. |

## Red Flags

- Escribir código específico de un framework sin revisar la doc de esa versión
- Usar "creo" o "me parece" sobre una API en lugar de citar la fuente
- Implementar un patrón sin saber a qué versión aplica
- Citar Stack Overflow o posts de blog en lugar de documentación oficial
- Usar APIs deprecadas porque aparecen en los datos de entrenamiento
- No leer `package.json` / archivos de dependencias antes de implementar
- Entregar código sin citas de fuente para decisiones específicas de framework
- Obtener un sitio de doc completo cuando solo una página es relevante

## Verificación

Después de implementar con desarrollo impulsado por fuentes:

- [ ] Las versiones de framework y librerías se identificaron desde el archivo de dependencias
- [ ] Se obtuvo documentación oficial para los patrones específicos del framework
- [ ] Todas las fuentes son documentación oficial, no posts de blog ni datos de entrenamiento
- [ ] El código sigue los patrones que muestra la documentación de la versión actual
- [ ] Las decisiones no triviales incluyen citas de fuente con URLs completas
- [ ] No se usan APIs deprecadas (verificado contra guías de migración)
- [ ] Los conflictos entre la doc y el código existente se superficial al usuario
- [ ] Cualquier cosa que no se pudo verificar está marcada explícitamente como sin verificar
