---
name: "knowledge-management"
metadata:
  category: "Governance"
  tags:
    - conocimiento
    - documentacion
    - memoria
description: "Workflow de Knowledge Management: gobernanza, sincronización y evolución de la base de conocimiento del proyecto. Mantiene una única fuente de verdad."
user-invocable: false
---

# Workflow: Knowledge Management

## Propósito

Gestionar el conocimiento persistente del proyecto durante todo su ciclo de vida.

No desarrolla features.

No modifica código de negocio.

Su responsabilidad es mantener la documentación consistente, actualizada y útil para humanos y agentes.

---

# Filosofía

> Every decision deserves a home.

La documentación no es un entregable.

Es una memoria compartida.

Todo conocimiento importante debe existir una sola vez y ser fácilmente descubrible.

---

# Cuándo usarlo

- al finalizar un workflow
- antes de iniciar una nueva sesión
- antes de crear un PR
- después de cerrar un epic
- después de una retrospectiva
- cuando cambian decisiones arquitectónicas
- cuando aparecen inconsistencias

---

# Artefactos conocidos

Ver [catálogo de artefactos](./references/artifacts.md).

---

# Principios

Single Source of Truth.

No duplicar conocimiento.

Documentar decisiones, no conversaciones.

Preferir actualizar antes que crear nuevos archivos.

Eliminar conocimiento obsoleto.

Mantener trazabilidad.

---

# Fases

## 1. Discovery

Detectar:

- qué documentos existen
- cuáles faltan
- cuáles están vacíos
- cuáles parecen abandonados

Construir un mapa de conocimiento.

---

## 2. Ownership

Determinar el dueño de cada información.

Ejemplos:

Arquitectura

↓

ARCHITECTURE.md

Decisión técnica

↓

ADR

Estado actual

↓

STATUS.md

Historial

↓

CHANGELOG.md

Nunca duplicar.

---

## 3. Consistency Audit

Buscar contradicciones. Ver [checklist de conocimiento](./references/checklist.md).

Generar reporte.

Nunca modificar automáticamente.

---

## 4. Freshness

Detectar conocimiento viejo.

Preguntas:

¿Hace cuánto no se actualiza?

¿Sigue siendo válido?

¿Hace referencia a archivos eliminados?

¿Habla de features que ya no existen?

Clasificar:

🟢 Vigente

🟡 Revisar

🔴 Obsoleto

---

## 5. Knowledge Graph

Relacionar información.

Ejemplo:

Feature

↓

Epic

↓

ADR

↓

PR

↓

CHANGELOG

↓

HANDOFF

↓

STATUS

Construir referencias cruzadas.

---

## 6. Compression

Reducir redundancia.

Buscar:

- texto repetido
- tablas repetidas
- ejemplos repetidos
- decisiones duplicadas

Proponer consolidación.

Nunca eliminar automáticamente.

---

## 7. Evolution

Detectar:

- documentos que deberían dividirse
- documentos demasiado pequeños
- nuevos documentos necesarios
- documentos innecesarios

Proponer mejoras.

---

## 8. Publishing

Actualizar índice.

Verificar enlaces.

Verificar referencias.

Actualizar fechas.

**Sincronizar CONTRIBUTING.md:** si hay cambios en PRs abiertos, repos objetivo, o cadenas de contribución, actualizar el PR registry en CONTRIBUTING.md con el formato de cadena completa (issue → PR tercero → nuestro aporte → nuestro PR → contexto).

Generar reporte final.

---

# Outputs

KNOWLEDGE_REPORT.md

Knowledge Map

Inconsistencias encontradas

Documentos obsoletos

Documentos faltantes

Propuestas de consolidación

Knowledge Graph

---

## Helper Scripts

Scripts en `skills/knowledge-management/scripts/`:

| Script | Uso |
|---|---|
| `check-refs.sh` | Verifica que los links internos de la documentación existan y no estén rotos. Usar en Fase 1 (Discovery) y antes de mergear docs. |
| `knowledge-audit.sh` | Audita archivos de conocimiento vacíos, duplicados, sin owner, o sin actualizaciones recientes. Genera reporte. Usar en Fase 1 y Fase 5 (Maintenance). |
| `knowledge-graph.py` | Construye un grafo de relaciones entre documentos. Usar en Fase 1 para entender dependencias. |

---

# Decisiones

Puede:

✔ detectar inconsistencias

✔ recomendar consolidaciones

✔ construir mapa de conocimiento

✔ generar reportes

✔ actualizar índices

Nunca:

✖ inventar decisiones

✖ sobrescribir ADRs

✖ eliminar documentación

✖ cambiar STATUS automáticamente

✖ modificar conocimiento sin aprobación

---

# Checklist

¿Existe una única fuente para cada decisión?

¿Hay contradicciones?

¿Hay documentos abandonados?

¿Hay referencias rotas?

¿Hay duplicación?

¿Hay conocimiento sin documentar?

¿El proyecto puede entenderse sin leer el historial del chat?

## Learning Signals - Cuándo Loggear Automáticamente

No esperes a que Gonzo te diga "anotá esto". Estas señales disparan logging automático a `docs/LEARNINGS.md` o `memory/YYYY-MM-DD.md`:

**Correcciones explícitas:**
- "No, eso no es así..." / "En realidad debería ser..."
- "Te equivocaste en..." / "Eso está mal"
- "Te dije antes que..." / "Siempre hago X, no Y"
- "Dejá de hacer X" / "Por qué seguís haciendo..."

**Preferencias explícitas:**
- "Me gusta cuando..." / "Siempre haceme X"
- "Nunca hagas Y" / "Mi estilo es..."
- "Para [proyecto], usá..."

**Patrones recurrentes:**
- Misma instrucción 3+ veces
- Workflow que funciona bien repetidamente
- Gonzo elogia un approach específico

**No loggear:**
- Instrucciones de una sola vez ("hacé X ahora")
- Contexto específico de un archivo ("en este archivo...")
- Hipótesis ("qué pasaría si...")

## Conflict Resolution - Lecciones Contradictorias

Cuando dos lecciones en `docs/LEARNINGS.md` se contradicen:

1. **Más específico gana** - proyecto > dominio > global
2. **Más reciente gana** - mismo nivel de especificidad
3. **Si ambiguo** - preguntar a Gonzo

## Common Traps - Errores Típicos al Aprender

- **Aprender del silencio** - no inferir preferencias porque Gonzo no dijo nada. Esperar corrección explícita o evidencia repetida.
- **Promover muy rápido** - una ocurrencia no es un patrón. Esperar 3+ repeticiones antes de promover a SOUL/TOOLS/AGENTS.
- **Leer todo siempre** - no cargar archivos enteros si no hacen falta. Cargar solo lo que el contexto necesita.
- **Compactar borrando** - no borrar lecciones viejas. Fusionar, resumir o archivar, pero no perder historia.

## DREAMS.md - Consolidación Programada de Memoria

Los daily logs (`memory/YYYY-MM-DD.md`) son raw data. Periódicamente, consolidar lo importante en `MEMORY.md` y archivar lo viejo.

**Cuándo:** cada ~7 días o cuando MEMORY.md se acerque a su límite, o cuando `memory/` supere los 30 archivos.

**Proceso:**
1. Leer daily logs recientes (últimos 7 días)
2. Identificar patrones, decisiones, preferencias que merezcan permanencia
3. Actualizar MEMORY.md con lo nuevo
4. **Consolidar memory/:** archivar sesiones individuales (`YYYY-MM-DD-HHMM.md`) y dejar solo 1 archivo por día consolidado (`YYYY-MM-DD.md`). Si el archivo consolidado ya existe, mover los individuales a `memory/archive/`.
5. Archivar daily logs viejos (>90 días) a `memory/archive/`
6. Dejar nota en el daily log del día: "Consolidación ejecutada. X entradas promovidas a MEMORY.md. memory/: N archivos → M archivos."

**Lección:** la memoria no se mantiene sola. La consolidación programada evita que MEMORY.md se llene de ruido o que insights valiosos se pierdan en daily logs olvidados.

## Related Skills

- [Engineering Governance](../engineering-governance): Para auditar la calidad del conocimiento
- [Technical Documentation](../tech-docs): Para crear y mantener documentación técnica