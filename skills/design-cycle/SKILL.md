# Design Cycle Skill

## Propósito

Formalizar el proceso de **generar → iterar → justificar** que utilizamos en los entrenamientos de diseño UI/UX (kanam‑lab). La skill permite reproducir el flujo de forma consistente y registrar evidencia de cada paso.

## Paso a paso

1. **Generar** – crear al menos una propuesta de diseño (mockup, storyboard o composición visual). Documentar la hipótesis de usabilidad y los criterios de accesibilidad (WCAG 2.2 A/AA).
2. **Iterar** – aplicar feedback interno o de usuarios mediante pruebas rápidas (Axe, Lighthouse, usuarios reales). Actualizar la propuesta incorporando cambios y registrar los resultados en un `design‑iteration.md` dentro de la carpeta de la skill.
3. **Justificar** – redactar un breve informe (`justification.md`) que explique por qué la versión final satisface los criterios de accesibilidad, branding y negocio. Incluir métricas de contraste, estados de `data‑state` y cualquier validación de lector de pantalla.

## Artefactos generados (ejemplo)

```
design-cycle/
│   SKILL.md                # <-- esta skill
│   design-iteration.md      # iteraciones y notas
│   justification.md        # argumento final + métricas
└── mockup.png              # arte visual (opcional)
```

## Integración en el workflow

* **CLI** – `kanam skill run design-cycle` crea la estructura y abre el editor de `design-iteration.md`.
* **Automatización** – al marcar la skill como *completed* en `progress_card`, `publish-skills.sh` la incluye automáticamente en el repositorio público.

## Criterios de aceptación

- Al menos una iteración registrada.
- Justificación que cite métricas de contraste (`≥ 4.5:1` para texto normal) y pruebas de accesibilidad (`axe` sin errores críticos).
- Artefactos guardados bajo `workspace/skills/design-cycle/`.

---

**Nota**: la marca `Kanam` se preserva; no se incluyen datos personales ni de proyectos internos. No hay guiones largos en el texto (solo guiones normales).
