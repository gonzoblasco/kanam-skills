---
name: "a11y-at-validation"
description: "Cuándo la validación manual de accesibilidad es obligatoria en OSS, y cómo ejecutarla."
---

# Skill: a11y-at-validation

## Objetivo

Saber **cuándo la validación manual de accesibilidad es obligatoria** (no solo recomendable) antes de considerar un PR de a11y terminado, y cómo ejecutarla y documentarla en un contexto de colaboración OSS.

## Regla central: cuándo es OBLIGATORIA la validación manual

La validación AT manual es **obligatoria** (no opcional) cuando el cambio altera **lo que un screen reader anuncia** (la frase hablada, no el atributo) y ese anuncio no es verificable por tests unitarios.

### Frontera: test unitario vs manual

| Verificable por test unitario | Solo verificable manualmente |
|---|---|
| Atributos ARIA en el DOM | Qué anuncia el screen reader (la frase) |
| Roles, `aria-labelledby`, `aria-selected` | Timing del anuncio (cuándo se dice, si se dice) |
| Estructura del árbol de accesibilidad | Interacción real (roving focus, `aria-activedescendant`) |

**Caso de oro (2026-08-12, radix-ui/primitives):** el PR #4109 agregó `aria-posinset`/`aria-setsize` calculados en `useLayoutEffect`. Los atributos estaban correctos en el DOM (51 tests verdes), pero la validación manual con VoiceOver+Chrome reveló que la primera opción sin preselección **no anunciaba nada** (#4110) por un race de timing entre el montaje del item y el anuncio del AT. Ningún test unitario podía atraparlo.

**Regla derivada:** si tu cambio toca `aria-*` que afecta anuncio, roles, roving focus o `aria-activedescendant`, la validación manual es obligatoria. Los tests verdes NO son suficientes.

## Cuándo aplicar

Aplicar este flujo en PRs de accesibilidad en repos de OSS (Radix, shadcn/ui, TanStack, astryx, etc.) cuando el cambio:

- Agrega/modifica atributos ARIA que afectan anuncio (posinset, setsize, live regions, labels dinámicos).
- Cambia roles o interacción (roving focus, activedescendant, combobox/listbox).
- Porta texto a nodos (ej. portaling de texto de opción al trigger).
- Maneja timing de montaje (useLayoutEffect, efectos que pintan atributos tras el primer paint).

## Pasos del flujo

### 1. Identificar si el cambio toca "anuncio" (no solo DOM)

Si el cambio cae en la columna "solo verificable manualmente" de la tabla, la validación AT es obligatoria. Documentar esto ANTES de dar el PR por terminado.

### 2. Ejecutar la validación manual

1. Levantar el storybook/playground local apuntando a la rama del PR (workspace build, no main).
2. Activar el AT del sistema:
   - macOS: VoiceOver con **Cmd + F5**.
   - Activar **captions/live captions** (Preferencias del sistema -> Accesibilidad -> VoiceOver -> Detallado -> Usar subtítulos) para confirmar visualmente la frase anunciada.
3. Probar los casos límite, no solo el feliz:
   - Sin valor preseleccionado (la primera opción suele ser el caso roto).
   - Con valor preseleccionado.
   - Con agrupación (Select.Group) si aplica.
   - Opción "clear"/placeholder (value vacío) - suele ser intencional, ver paso 3.
4. Registrar en una tabla qué se esperaba vs qué se anunció, y si los captions confirman.

### 3. Si se detecta un hallazgo: verificar si es intencional o bug

ANTES de proponer cambiar el componente, buscar en el código si el comportamiento es deliberado:

- Guardas y comentarios que documenten el patrón (ej. "consumer may render an item with empty value to act as a clear option").
- Funciones tipo `shouldShowPlaceholder`.
- Patrones de diseño documentados del primitive (ej. APG).

**Si es intencional** (por diseño): NO tocar el componente con un PR. Documentar el hallazgo en un issue con diagnóstico + opciones, y dejar la decisión de dirección a los maintainers.

**Si es bug real**: proceder con un PR, idealmente con el hallazgo documentado.

### 4. Documentar la validación en el PR/issue

Comentar en el PR la evidencia de validación manual (qué anunció cada caso, captions confirmados). Si hay un hallazgo separado, abrir un issue aparte y referenciarlo - no mezclar con el PR principal.

## Errores comunes

- **Dar un PR de a11y por terminado con solo tests unitarios verdes.** Los tests verifican atributos, no anuncios.
- **Proponer cambiar un componente antes de verificar si el comportamiento es intencional.** Riesgo de PR que rompe el contrato del primitive.
- **Abrir un comentario en un issue propio con "Thanks for opening this".** Esa frase es para agradecer a otro que reportó; absurda cuando uno mismo abrió el issue. Arrancar directo con el análisis.
- **Subir PR de diseño sin consenso.** Cambios de diseño de un primitive maduro requieren discusión previa con maintainers, no un PR unilateral.

## Checklist de cierre

- [ ] ¿El cambio toca anuncio/rol/interacción? -> validación manual obligatoria hecha.
- [ ] ¿Probé los casos límite (sin preselección, placeholder, grupos)?
- [ ] ¿Captions confirman la frase anunciada?
- [ ] ¿Verifiqué si un hallazgo es intencional (guardas/comentarios/patrones) antes de tocar el componente?
- [ ] ¿Documenté la evidencia en el PR y separé hallazgos en issues propios?
