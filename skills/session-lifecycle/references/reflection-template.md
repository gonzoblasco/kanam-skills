# Reflection Template - Session Lifecycle Reference

Post-session reflection template to identify learnings and patterns.

## When to use it

At the end of every significant session (not 5-minute sessions). As part of closing, before the HANDOFF.

## Guide questions

### What did we learn?
- Did anything surprise us?
- Did anything work better or worse than expected?
- Was there any mistake we do not want to repeat?

### What patterns did we identify?
- Did we repeat any process without thinking about it?
- Can we extract a "mega-pattern" that applies to other contexts?
- Is there anything that should be automatic and today is manual?

### Is it global or project-specific?
- 🌍 **Global** - applies to any project, domain or context
- 🏗️ **Project** - specific to the AI Engineering OS or the workspace
- 📦 **Context** - specific to a particular product project

### Where does it go?
| If it is... | It goes to... |
|---|---|
| 🌍 Global | `docs/LEARNINGS.md` + evaluate whether it deserves AGENTS.md/SOUL.md |
| 🏗️ Project | `docs/LEARNINGS.md` |
| 📦 Context | `projects/<slug>/.knowledge/LEARNINGS.md` |

## Entry format

```markdown
## YYYY-MM-DD - [Short title]

### N. [Lesson title]
[2-4 paragraph description]

**Lesson:** [one sentence that captures the essence]

**Classification:** 🌍 Global / 🏗️ Project / 📦 Context
```

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Session Templates](./session-templates.md) - Start and close templates
