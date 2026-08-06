# Architecture Diagrams — Technical Documentation Reference

Guía para crear diagramas de arquitectura con Mermaid.

## C4 Model

### Context Diagram (Level 1)

```mermaid
graph TD
    User([User]) --> WebApp[Web Application]
    WebApp --> API[API Service]
    API --> DB[(Database)]
    API --> External[External Service]
```

### Container Diagram (Level 2)

```mermaid
graph TD
    Browser[Browser] --> NextJS[Next.js App]
    NextJS --> Supabase[Supabase API]
    Supabase --> Postgres[(PostgreSQL)]
    Supabase --> Storage[(Storage)]
    NextJS --> Stripe[Stripe API]
```

### Component Diagram (Level 3)

```mermaid
graph TD
    Pages[Pages] --> Components[UI Components]
    Components --> Hooks[Custom Hooks]
    Hooks --> Services[API Services]
    Services --> Supabase[Supabase Client]
    Components --> Auth[Auth Provider]
```

## Common Diagrams

### Data Flow

```mermaid
sequenceDiagram
    User->>Frontend: Submit form
    Frontend->>API: POST /api/data
    API->>DB: INSERT
    DB-->>API: success
    API-->>Frontend: 200 OK
    Frontend-->>User: Show success
```

### Component Tree

```mermaid
graph TD
    App --> Layout
    Layout --> Header
    Layout --> Sidebar
    Layout --> Main
    Main --> DataTable
    Main --> Modal
```

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
- [ADR Patterns](./adr-patterns.md) — Patrones de ADRs
- [CHANGELOG Guide](./changelog-guide.md) — Guía de CHANGELOG
