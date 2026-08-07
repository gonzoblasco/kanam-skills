# Engineering Governance

Evolución continua del AI Engineering OS.

## ¿Para qué sirve?

Para **mantener y mejorar el sistema de workflows, principios y estándares de ingeniería**. Es el meta-workflow: su cliente es el propio AI Engineering OS, no un proyecto en particular. No desarrolla features, no escribe código de producto.

## ¿Cuándo usarlo?

- Después de cerrar un milestone importante
- Cuando aparecen bugs repetitivos
- Cuando varios workflows empiezan a duplicar responsabilidades
- Cuando cambian las mejores prácticas de la industria
- Periódicamente, para mantener la salud del sistema

## ¿Cómo se usa?

### Workflow completo

1. **System Health Check** - ¿qué workflows no se usan? ¿qué genera fricción?
2. **Pattern Mining** - buscar patrones repetitivos para extraer
3. **Workflow Audit** - auditar cada workflow con checklist
4. **Knowledge Consistency** - buscar contradicciones entre documentos
5. **Industry Review** - comparar contra el estado del arte
6. **Governance Review** - detectar workflows obsoletos, muy grandes, o mezclados
7. **Engineering Principles** - auditar principios vigentes
8. **Improvement Proposal** - generar RFCs

### Scripts útiles

```bash
# Auditar todas las skills
./scripts/workflow-audit.sh

# Detectar contenido duplicado entre skills
./scripts/detect-duplicates.sh

# Generar governance report
python3 scripts/generate-governance-report.py

# Analizar hotspots en git history
./scripts/hotfiles.sh --top 10

# Code ownership por contributor
./scripts/ownership.sh

# Escanear historial git por secrets
./scripts/secret-scan.sh
```

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/audit-checklist.md` | Checklist para auditar cada workflow |
| `references/rfc-template.md` | Template para proponer mejoras |
| `references/metrics-definitions.md` | Métricas: workflow health, knowledge, deps, code quality |
| `references/industry-sources.md` | Fuentes a monitorear: blogs, newsletters, papers |

## Skills relacionadas

- [Knowledge Management](../knowledge-management) - Para mantener la base de conocimiento
- [Observability](../observability) - Para medir la salud del sistema
