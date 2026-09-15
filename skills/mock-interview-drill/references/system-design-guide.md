# System Design Guide - Mock Interview Drill

Guide for system design interviews. How to structure the answer, what to ask, common trade-offs.

## Answer structure

Use this framework for any system design question:

### 1. Clarify Requirements (2-3 min)

Don't start designing. First understand what they're asking:

**Functional requirements:**
- What features does the system need?
- Who are the users?
- What actions can they take?

**Non-functional requirements:**
- How many users? (DAU, MAU, concurrent)
- Expected latency?
- Availability? (99.9%, 99.99%)
- Consistency or availability? (CP vs AP)

**Example:**
> "Before I start, let me clarify: is this a real-time chat or async messaging? How many DAU are we targeting? Do we need message persistence?"

### 2. High-Level Design (5 min)

Sketch the general architecture:

- **Client** → **Load Balancer** → **API Gateway** → **Services** → **Database**
- Explain each component at a high level
- Don't go into details yet

### 3. Deep Dive (10-15 min)

Choose 1-2 components and go deeper:

- **Database schema** - tables, indexes, partitioning
- **API design** - endpoints, methods, payloads
- **Data flow** - how data travels between components
- **Caching** - what you cache, where, for how long

### 4. Trade-offs & Edge Cases (5 min)

- **Trade-offs:** Why did you choose X over Y?
- **Edge cases:** What happens if a service goes down? What about a traffic spike?
- **Monitoring:** How do you know it works?

---

## Questions by seniority

### Junior (< 3 years)
- "Design a URL shortener" (tinyurl)
- "Design a rate limiter"
- "Design a chat system for 2 users"

**What to evaluate:** Basic understanding of client-server, APIs, databases.

### Mid (3-6 years)
- "Design a real-time chat system" (WhatsApp)
- "Design a news feed" (Facebook, Twitter)
- "Design a ride-sharing system" (Uber)

**What to evaluate:** Ability to scale, caching, partitioning, trade-offs.

### Senior (6+ years)
- "Design YouTube/Netflix" (video streaming)
- "Design a distributed key-value store"
- "Design a payment system"

**What to evaluate:** Distributed consistency, fault tolerance, CAP theorem, cost optimization.

---

## Common trade-offs

| Decision | Pro | Against |
|---|---|---|
| **SQL vs NoSQL** | SQL: consistency, joins, transactions | NoSQL: horizontal scalability, schemaless |
| **Monolith vs Microservices** | Monolith: simple, fast to develop | Microservices: independent scaling, decoupling |
| **Sync vs Async** | Sync: simple, consistent | Async: resilient, scalable |
| **Cache (Redis) vs DB** | Cache: fast, low latency | DB: durable, consistent |
| **Read replicas vs Sharding** | Replicas: simple, good for read-heavy | Sharding: scales writes, complex |
| **Strong vs Eventual consistency** | Strong: predictable, simple | Eventual: available, scalable |

---

## Database design patterns

### Normalization vs Denormalization
- **Normalized:** Less redundancy, more joins
- **Denormalized:** Faster reads, more storage

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

| Strategy | How it works | When to use it |
|---|---|---|
| **Cache Aside** | App checks cache first, miss → DB → populate cache | Frequent reads, occasional writes |
| **Write Through** | Writes to cache and DB simultaneously | Data that must always be in cache |
| **Write Behind** | Writes to cache, then asynchronously to DB | High write throughput |
| **Refresh Ahead** | Cache refreshes before expiring | Predictable data, critical latency |

---

## Monitoring & Observability

- **Latency:** p50, p95, p99 response times
- **Error rate:** 5xx, 4xx, timeouts
- **Throughput:** Requests per second
- **Saturation:** CPU, memory, connection pools
- **Health checks:** /health, /ready endpoints

---

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Behavioral Questions](./behavioral-questions.md) - Behavioral question bank
- [Case Frameworks](./case-frameworks.md) - For case interviews
- [Preparation Guide](./preparation-guide.md) - What to study before
