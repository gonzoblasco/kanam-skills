# Knowledge Management

Gestión de la base de conocimiento del proyecto.

## ¿Para qué sirve?

Para **mantener la documentación consistente, actualizada y útil** para humanos y agentes. Una única fuente de verdad. No desarrolla features, no modifica código de negocio.

**Filosofía:** Every decision deserves a home. La documentación no es un entregable, es una memoria compartida.

## ¿Cuándo usarlo?

- Al finalizar un workflow
- Antes de iniciar una nueva sesión
- Después de cerrar un epic
- Cuando cambian decisiones arquitectónicas
- Cuando aparecen inconsistencias entre documentos

## ¿Cómo se usa?

### Workflow completo

1. **Discovery** — detectar qué docs existen, cuáles faltan, cuáles están abandonados
2. **Ownership** — determinar dueño de cada información
3. **Consistency Audit** — buscar contradicciones entre documentos
4. **Freshness** — detectar conocimiento viejo (🟢 Vigente / 🟡 Revisar / 🔴 Obsoleto)
5. **Knowledge Graph** — relacionar información (Feature → ADR → PR → CHANGELOG)
6. **Compression** — reducir redundancia, proponer consolidación
7. **Evolution** — detectar docs que deberían dividirse o fusionarse
8. **Publishing** — actualizar índice, verificar enlaces

### Scripts útiles

```bash
# Auditar la base de conocimiento
./scripts/knowledge-audit.sh

# Verificar referencias cruzadas
./scripts/check-refs.sh

# Generar grafo de conocimiento
python3 scripts/knowledge-graph.py
```

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/artifacts.md` | Catálogo completo de artefactos de conocimiento |
| `references/checklist.md` | Checklist: discovery, consistency, freshness, graph, compression |
| `references/knowledge-graph.md` | Cómo construir el grafo de conocimiento |
| `references/freshness-policy.md` | Política de actualización y archivado |

## Skills relacionadas

- [Engineering Governance](../engineering-governance) — Para auditar la calidad del conocimiento
- [Technical Documentation](../tech-docs) — Para crear y mantener documentación técnica
