# System Design Guide — Mock Interview Drill

Guía para entrevistas de system design. Cómo estructurar la respuesta, qué preguntar, trade-offs comunes.

## Estructura de la respuesta

Usá este framework para cualquier pregunta de system design:

### 1. Clarify Requirements (2-3 min)

No arranques a diseñar. Primero entendé qué te piden:

**Functional requirements:**
- ¿Qué features necesita el sistema?
- ¿Quiénes son los usuarios?
- ¿Qué acciones pueden hacer?

**Non-functional requirements:**
- ¿Cuántos usuarios? (DAU, MAU, concurrentes)
- ¿Latencia esperada?
- ¿Disponibilidad? (99.9%, 99.99%)
- ¿Consistencia o disponibilidad? (CP vs AP)

**Ejemplo:**
> "Before I start, let me clarify: is this a real-time chat or async messaging? How many DAU are we targeting? Do we need message persistence?"

### 2. High-Level Design (5 min)

Dibujá la arquitectura general:

- **Client** → **Load Balancer** → **API Gateway** → **Services** → **Database**
- Explicá cada componente a alto nivel
- No entres en detalles todavía

### 3. Deep Dive (10-15 min)

Elegí 1-2 componentes y profundizá:

- **Database schema** — tablas, índices, particionamiento
- **API design** — endpoints, métodos, payloads
- **Data flow** — cómo viajan los datos entre componentes
- **Caching** — qué cacheás, dónde, por cuánto tiempo

### 4. Trade-offs & Edge Cases (5 min)

- **Trade-offs:** ¿Por qué elegiste X sobre Y?
- **Edge cases:** ¿Qué pasa si un servicio cae? ¿Y si hay pico de tráfico?
- **Monitoring:** ¿Cómo sabés que funciona?

---

## Preguntas por seniority

### Junior (< 3 years)
- "Design a URL shortener" (tinyurl)
- "Design a rate limiter"
- "Design a chat system for 2 users"

**Qué evaluar:** Entendimiento básico de client-server, APIs, databases.

### Mid (3-6 years)
- "Design a real-time chat system" (WhatsApp)
- "Design a news feed" (Facebook, Twitter)
- "Design a ride-sharing system" (Uber)

**Qué evaluar:** Capacidad de escalar, caching, particionamiento, trade-offs.

### Senior (6+ years)
- "Design YouTube/Netflix" (video streaming)
- "Design a distributed key-value store"
- "Design a payment system"

**Qué evaluar:** Consistencia distribuida, fault tolerance, CAP theorem, cost optimization.

---

## Trade-offs comunes

| Decisión | Pro | Contra |
|---|---|---|
| **SQL vs NoSQL** | SQL: consistencia, joins, transacciones | NoSQL: escalabilidad horizontal, schemaless |
| **Monolith vs Microservices** | Monolith: simple, rápido de desarrollar | Microservices: escalado independiente, desacople |
| **Sync vs Async** | Sync: simple, consistente | Async: resiliente, scalable |
| **Cache (Redis) vs DB** | Cache: rápido, baja latencia | DB: durable, consistente |
| **Read replicas vs Sharding** | Replicas: simple, buena para read-heavy | Sharding: escala writes, complejo |
| **Strong vs Eventual consistency** | Strong: predecible, simple | Eventual: disponible, scalable |

---

## Database design patterns

### Normalization vs Denormalization
- **Normalized:** Menos redundancia, más joins
- **Denormalized:** Más rápido de leer, más storage

### Indexing
- **Primary key:** Unique, clustered
- **Secondary index:** For common queries
- **Composite index:** For multi-column queries
- **Covering index:** Includes all queried columns

### Partitioning
- **Horizontal (sharding):** Split by key (user_id, region)
- **Vertical:** Split by column group
- **Directory-based:** Lookup table for shard location

---

## Caching strategies

| Strategy | Cómo funciona | Cuándo usarlo |
|---|---|---|
| **Cache Aside** | App checkea cache primero, miss → DB → populate cache | Lecturas frecuentes, writes ocasionales |
| **Write Through** | Escribe en cache y DB simultáneamente | Datos que siempre deben estar en cache |
| **Write Behind** | Escribe en cache, después asíncrono a DB | Alta throughput de writes |
| **Refresh Ahead** | Cache se refresca antes de expirar | Datos predecibles, latencia crítica |

---

## Monitoring & Observability

- **Latency:** p50, p95, p99 response times
- **Error rate:** 5xx, 4xx, timeouts
- **Throughput:** Requests per second
- **Saturation:** CPU, memory, connection pools
- **Health checks:** /health, /ready endpoints

---

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
- [Behavioral Questions](./behavioral-questions.md) — Banco de preguntas behavioral
- [Case Frameworks](./case-frameworks.md) — Para case interviews
- [Preparation Guide](./preparation-guide.md) — Qué estudiar antes
