---
name: "curriculum-builder"
description: "Scaffold for adaptive AI tutors. Markdown + graph -> path + LLM lessons (BYOK) + frontend. Inspired by roadmap.sh."
---

# Curriculum Builder - OpenClaw Skill

## Description

Complete scaffold to build **adaptive AI tutors** for any topic. Takes structured markdown content + prerequisite graph and generates:

- Learning path engine (deterministic)
- LLM pedagogical layer (BYOK - bring your own key)
- Frontend with search, filters and lessons
- Post-lesson feedback loop
- SQLite cache with TTL

**Inspired by:** roadmap.sh (but open source + generative AI)
**Pilot use case:** EnSuLugar - cooking tutor (15 recipes, 28 techniques)

---

## 1. General Architecture

```
Curated content (structured markdown)
   ↓
Parser → SQLite/JSON (derived artifact)
   ↓
Prerequisite graph (deterministic, no AI)
   ↓
Path engine (topological algorithm)
   ↓
LLM pedagogical layer (BYOK: Ollama / OpenAI / Anthropic)
   ├── Generates lesson adapted to profile
   ├── Generates assessment (MCQs)
   └── Generates progressive variations
   ↓
Frontend (React + Vite)
   ├── Unified search bar (level + search + technique)
   ├── Dedicated lesson page
   ├── Interactive quiz
   └── Post-lesson feedback modal
```

## 2. Project Structure

```
proyecto/
├── content/                  # Curated content (markdown)
│   ├── tema-1.md
│   ├── tema-2.md
│   └── ...
├── src/
│   ├── build/                # Build pipeline
│   │   ├── build.ts          # Orchestrator
│   │   └── parser.ts         # Markdown parsing
│   ├── engine/               # Deterministic engine
│   │   ├── graph.ts          # Prerequisite graph
│   │   └── path.ts           # Path algorithm
│   ├── pedagogy/             # Pedagogical layer (AI)
│   │   ├── tutor.ts          # Lesson generation
│   │   ├── cache.ts          # SQLite cache (7-day TTL)
│   │   ├── feedback.ts       # Post-lesson feedback
│   │   └── llm.ts            # LLM client (BYOK)
│   ├── server.ts             # HTTP server
│   └── types.ts              # Shared types
├── app/                      # Frontend (Vite + React)
│   └── src/
│       ├── App.tsx           # Main component
│       ├── index.css         # Styles
│       └── storage.ts        # Profile in localStorage
├── tests/
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│   └── e2e/                  # E2E tests (Playwright)
├── .env.example              # BYOK config
└── package.json
```

## 3. Content Pattern (Markdown)

Each markdown card follows this structure:

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

## 4. Prerequisite Graph

The graph is a DAG (Directed Acyclic Graph) where each node is a technique and the edges are prerequisites.

```typescript
interface Tecnica {
  id: string;
  nombre: string;
  descripcion: string;
  nivelBase: Dificultad;  // 1-5
  prerrequisitos: string[];  // IDs of required techniques
}

// Example:
const TECNICAS: Tecnica[] = [
  { id: "cortar", nombre: "Cortes básicos", nivelBase: 1, prerrequisitos: [] },
  { id: "saltear", nombre: "Salteado", nivelBase: 2, prerrequisitos: ["cortar"] },
  { id: "emulsion", nombre: "Emulsión", nivelBase: 3, prerrequisitos: ["saltear"] },
];
```

## 5. Path Engine (Deterministic)

Algorithm that builds the optimal learning path:

```typescript
function armarRuta(perfil: PerfilUsuario, recetas: Receta[]): PasoRuta[] {
  // 1. Filter techniques already mastered
  // 2. Sort by base level
  // 3. Respect prerequisites (topological)
  // 4. Prioritize techniques with more recipes available
  // 5. Return ordered path
}
```

## 6. Pedagogical Layer (LLM)

### Lesson Prompt

```typescript
const PROMPT_LECCION = `
You are an expert tutor in {tema}. 
The user is at level {nivel} and already masters: {tecnicas_dominadas}.
They have completed {recetas_completadas} lessons.

Generate a lesson about {tecnica} using {receta} as a practical example.

The lesson must include:
1. **What {tecnica} is** - clear definition and why it is important
2. **The mechanism** - how it works, what happens at the technical level
3. **Step by step** - using the recipe as the vehicle, explaining the why of each step
4. **Common mistakes** - what usually goes wrong and how to avoid it
5. **Expert tips** - to take the technique to the next level

Tone: {nivel <= 2 ? "sencillo y alentador" : "técnico pero accesible"}
`;
```

### Cache Strategy

```typescript
// SQLite with 7-day TTL
// Hash of (recetaId + nivel + técnicas) to identify unique lessons
// In parallel: generate lesson + evaluation + variations (Promise.all)
```

## 7. Frontend (React + Vite)

### Key Components

| Component | Purpose |
|---|---|
| `SearchBar` | Level + search + technique in one row |
| `RecipeCard` | Card with info, expand, complete, generate lesson |
| `LeccionPage` | Dedicated page with content + quiz + variations |
| `QuizQuestion` | Interactive MCQ with visual feedback |
| `FeedbackModal` | Post-completion modal with 4 result options |
| `OnboardingScreen` | Initial profile with mastered techniques |

### UI States

- **Loading:** animated spinner
- **Error:** message with detail + suggestion
- **Empty:** message when there are no filter results
- **Cached:** ⚡ badge when the lesson comes from cache

## 8. BYOK (Bring Your Own Key)

```env
# .env.example
LLM_PROVIDER=ollama  # or: openai | anthropic
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=deepseek-v4-flash
# OPENAI_API_KEY=sk-...
# ANTHROPIC_API_KEY=sk-ant-...
```

## 9. Testing

### Test Pyramid

```
         ╱  E2E  ╲          ← Playwright (critical flows)
        ╱─────────╲
       ╱ Integration  ╲       ← Components + API
      ╱───────────────╲
     ╱   Unit tests     ╲    ← Engine + pure logic
    ╱─────────────────────╲
```

### Targets

| Layer | Tests | Tool |
|---|---|---|
| Engine (graph.ts, path.ts) | 6+ | Vitest |
| Cache (hash, TTL) | 6+ | Vitest |
| React components | 5+ | Vitest + Testing Library |
| API endpoints | 5+ | Vitest + fetch |
| E2E (complete flow) | 5+ | Playwright |
| Accessibility | axe-core audit | Playwright + axe-core |

## 10. Accessibility (WCAG AAA)

- Contrast ≥ 7:1 for normal text
- Visible focus on all interactive elements
- Borders ≥ 2px for clickable elements
- Hover states with tactile feedback (transform)
- Labels and aria-labels on all controls
- role="dialog" + aria-modal on modals

## 11. Next Steps / Improvements

- [ ] Dark mode (CSS variables + prefers-color-scheme)
- [ ] PWA (service worker + offline)
- [ ] Clickable variations (navigate to suggested recipe)
- [ ] Feedback modal with backend suggestions
- [ ] CI pipeline (GitHub Actions)
- [ ] Deploy (Vercel + Railway/Render)
- [ ] Forced web search for updatable content
- [ ] Multi-language
- [ ] Premium cloud version (managed hosting)

## 12. References

- **Use case:** EnSuLugar - github.com/user/a project
- **Inspiration:** roadmap.sh
- **Stack:** Vite 6 + React 19 + TypeScript + Node.js + SQLite + Ollama
- **Related pattern:** pipeline-detector (local detectors + cross-validation / contextual AI)
