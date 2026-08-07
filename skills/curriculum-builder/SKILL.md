---
name: "curriculum-builder"
description: "Scaffold para tutores adaptativos con IA. Markdown + grafo → ruta + lecciones LLM (BYOK) + frontend. Inspirado en roadmap.sh."
---

# Curriculum Builder - Skill de OpenClaw

## Descripción

Scaffold completo para crear **tutores adaptativos con IA** para cualquier tema. Toma contenido markdown estructurado + grafo de prerrequisitos y genera:

- Motor de ruta de aprendizaje (determinístico)
- Capa pedagógica LLM (BYOK - traé tu propia clave)
- Frontend con búsqueda, filtros y lecciones
- Feedback loop post-lección
- Cache SQLite con TTL

**Inspirado en:** roadmap.sh (pero open source + IA generativa)  
**Caso de uso piloto:** EnSuLugar - tutor de cocina (15 recetas, 28 técnicas)

---

## 1. Arquitectura General

```
Contenido curado (markdown estructurado)
   ↓
Parser → SQLite/JSON (artefacto derivado)
   ↓
Grafo de prerrequisitos (determinístico, sin IA)
   ↓
Motor de ruta (algoritmo topológico)
   ↓
Capa pedagógica LLM (BYOK: Ollama / OpenAI / Anthropic)
   ├── Genera lección adaptada al perfil
   ├── Genera evaluación (MCQs)
   └── Genera variaciones progresivas
   ↓
Frontend (React + Vite)
   ├── Search bar unificada (nivel + búsqueda + técnica)
   ├── Página de lección dedicada
   ├── Quiz interactivo
   └── Feedback modal post-lección
```

## 2. Estructura de Proyecto

```
proyecto/
├── content/                  # Contenido curado (markdown)
│   ├── tema-1.md
│   ├── tema-2.md
│   └── ...
├── src/
│   ├── build/                # Build pipeline
│   │   ├── build.ts          # Orquestador
│   │   └── parser.ts         # Parseo de markdown
│   ├── engine/               # Motor determinístico
│   │   ├── graph.ts          # Grafo de prerrequisitos
│   │   └── path.ts           # Algoritmo de ruta
│   ├── pedagogy/             # Capa pedagógica (IA)
│   │   ├── tutor.ts          # Generación de lecciones
│   │   ├── cache.ts          # Cache SQLite (7-day TTL)
│   │   ├── feedback.ts       # Feedback post-lección
│   │   └── llm.ts            # Cliente LLM (BYOK)
│   ├── server.ts             # HTTP server
│   └── types.ts              # Tipos compartidos
├── app/                      # Frontend (Vite + React)
│   └── src/
│       ├── App.tsx           # Componente principal
│       ├── index.css         # Estilos
│       └── storage.ts        # Perfil en localStorage
├── tests/
│   ├── unit/                 # Tests unitarios
│   ├── integration/          # Tests de integración
│   └── e2e/                  # Tests E2E (Playwright)
├── .env.example              # Config BYOK
└── package.json
```

## 3. Patrón de Contenido (Markdown)

Cada ficha markdown sigue esta estructura:

```markdown
---
id: 1
titulo: "Nombre del Tema"
categoria: "Categoría"
dificultad: 3
tiempo: 45
tecnicas: ["tecnica-1", "tecnica-2"]
---

## Descripción

Breve descripción del tema.

## Ingredientes / Materiales

- Item 1
- Item 2

## Pasos

1. **Paso 1** - Descripción con detalle técnico.
   Nota: explicación del porqué.

2. **Paso 2** - Siguiente paso.
```

## 4. Grafo de Prerrequisitos

El grafo es un DAG (Directed Acyclic Graph) donde cada nodo es una técnica y las aristas son prerrequisitos.

```typescript
interface Tecnica {
  id: string;
  nombre: string;
  descripcion: string;
  nivelBase: Dificultad;  // 1-5
  prerrequisitos: string[];  // IDs de técnicas requeridas
}

// Ejemplo:
const TECNICAS: Tecnica[] = [
  { id: "cortar", nombre: "Cortes básicos", nivelBase: 1, prerrequisitos: [] },
  { id: "saltear", nombre: "Salteado", nivelBase: 2, prerrequisitos: ["cortar"] },
  { id: "emulsion", nombre: "Emulsión", nivelBase: 3, prerrequisitos: ["saltear"] },
];
```

## 5. Motor de Ruta (Determinístico)

Algoritmo que arma la ruta de aprendizaje óptima:

```typescript
function armarRuta(perfil: PerfilUsuario, recetas: Receta[]): PasoRuta[] {
  // 1. Filtrar técnicas ya dominadas
  // 2. Ordenar por nivel base
  // 3. Respetar prerrequisitos (topológico)
  // 4. Priorizar técnicas con más recetas disponibles
  // 5. Retornar ruta ordenada
}
```

## 6. Capa Pedagógica (LLM)

### Prompt de Lección

```typescript
const PROMPT_LECCION = `
Eres un tutor experto en {tema}. 
El usuario tiene nivel {nivel} y ya domina: {tecnicas_dominadas}.
Ha completado {recetas_completadas} lecciones.

Generá una lección sobre {tecnica} usando {receta} como ejemplo práctico.

La lección debe incluir:
1. **Qué es {tecnica}** - definición clara y por qué es importante
2. **El mecanismo** - cómo funciona, qué pasa a nivel técnico
3. **Paso a paso** - usando la receta como vehículo, explicando el porqué de cada paso
4. **Errores comunes** - qué suele salir mal y cómo evitarlo
5. **Tips de experto** - para llevar la técnica al siguiente nivel

Tono: {nivel <= 2 ? "sencillo y alentador" : "técnico pero accesible"}
`;
```

### Cache Estrategia

```typescript
// SQLite con 7-day TTL
// Hash de (recetaId + nivel + técnicas) para identificar lecciones únicas
// En paralelo: genera lección + evaluación + variaciones (Promise.all)
```

## 7. Frontend (React + Vite)

### Componentes Clave

| Componente | Propósito |
|---|---|
| `SearchBar` | Nivel + búsqueda + técnica en una fila |
| `RecipeCard` | Card con info, expandir, completar, generar lección |
| `LeccionPage` | Página dedicada con contenido + quiz + variaciones |
| `QuizQuestion` | MCQ interactivo con feedback visual |
| `FeedbackModal` | Modal post-completar con 4 opciones de resultado |
| `OnboardingScreen` | Perfil inicial con técnicas dominadas |

### Estados UI

- **Loading:** spinner animado
- **Error:** mensaje con detalle + sugerencia
- **Empty:** mensaje cuando no hay resultados de filtros
- **Cacheado:** badge ⚡ cuando la lección viene de cache

## 8. BYOK (Bring Your Own Key)

```env
# .env.example
LLM_PROVIDER=ollama  # o: openai | anthropic
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=deepseek-v4-flash
# OPENAI_API_KEY=sk-...
# ANTHROPIC_API_KEY=sk-ant-...
```

## 9. Testing

### Pirámide de Tests

```
         ╱  E2E  ╲          ← Playwright (flujos críticos)
        ╱─────────╲
       ╱ Integración ╲       ← Componentes + API
      ╱───────────────╲
     ╱   Unitarios      ╲    ← Engine + lógica pura
    ╱─────────────────────╲
```

### Targets

| Capa | Tests | Herramienta |
|---|---|---|
| Engine (graph.ts, path.ts) | 6+ | Vitest |
| Cache (hash, TTL) | 6+ | Vitest |
| Componentes React | 5+ | Vitest + Testing Library |
| API endpoints | 5+ | Vitest + fetch |
| E2E (flujo completo) | 5+ | Playwright |
| Accesibilidad | axe-core audit | Playwright + axe-core |

## 10. Accesibilidad (WCAG AAA)

- Contraste ≥ 7:1 para texto normal
- Focus visible en todos los elementos interactivos
- Bordes ≥ 2px para elementos clickeables
- Estados hover con feedback táctil (transform)
- Labels y aria-labels en todos los controles
- role="dialog" + aria-modal en modales

## 11. Próximos Pasos / Mejoras

- [ ] Modo oscuro (CSS variables + prefers-color-scheme)
- [ ] PWA (service worker + offline)
- [ ] Variaciones clickeables (navegar a receta sugerida)
- [ ] Feedback modal con sugerencias del backend
- [ ] CI pipeline (GitHub Actions)
- [ ] Deploy (Vercel + Railway/Render)
- [ ] Búsqueda web forzada para contenido actualizable
- [ ] Multi-idioma
- [ ] Versión cloud premium (hosting gestionado)

## 12. Referencias

- **Caso de uso:** EnSuLugar - github.com/gonzoblasco/ensulugar
- **Inspiración:** roadmap.sh
- **Stack:** Vite 6 + React 19 + TypeScript + Node.js + SQLite + Ollama
- **Patrón relacionado:** pipeline-detector (detectores locales + validación cruzada / IA contextual)
