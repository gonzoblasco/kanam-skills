# kanam-skills

**Agent skills for the whole job — and the rest of your life.**

Production-grade skills for AI coding agents, packaged the same way as
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) and
[google/skills](https://github.com/google/skills) — but covering more than the
SDLC. Engineering workflows, personal productivity, creative writing, and
life admin, all in the open [Agent Skills](https://agentskills.io/specification.md)
format.

```bash
npx skills add gonzoblasco/kanam-skills
```

Works with 70+ agents: Claude Code, Codex, Cursor, Copilot, Windsurf, Cline,
OpenCode, Kiro, and more — plus a **proven OpenClaw port**.

---

## Why another skills repo?

The big collections cover the software lifecycle: Define → Plan → Build →
Verify → Review → Ship. That's the engineering half of an agent's job.

This repo covers the **other half too** — the skills your agent needs to run
*you*, not just your codebase: ADHD-friendly planning, photo libraries,
calorie tracking, CV tailoring, fiction writing, local speech-to-text, and
more. No other public collection ships these as first-class agent skills.

**The only skills set with a proven OpenClaw port.** The OpenClaw ecosystem
wasn't covered by the mainstream collections, so we adapted them — and
verified they work.

## Install

### Any agent (skills.sh)

```bash
# Everything
npx skills add gonzoblasco/kanam-skills

# A single skill
npx skills add gonzoblasco/kanam-skills@narrative-content

# From a subdirectory
npx skills add gonzoblasco/kanam-skills/skills/spec-driven-development
```

The CLI detects your agent (Claude Code, Cursor, Codex, Copilot, Windsurf,
Kiro, ...) and copies skills to the right directory automatically.

### OpenClaw

OpenClaw loads skills from `<workspace>/skills`. Clone this repo (or the
skills folder) into your workspace:

```bash
# From your OpenClaw workspace
git clone git@github.com:gonzoblasco/kanam-skills.git .kanam-skills
cp -R .kanam-skills/skills/* skills/
rm -rf .kanam-skills
```

Then restart your OpenClaw session. Skills are discovered automatically.

### Manual (any agent)

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
# Claude Code
cp -r skills/* ~/.claude/skills/
# Cursor
cp -r skills/* .cursor/skills/
# Codex
cp -r skills/* $CODEX_HOME/skills/
```

See [docs/](docs/) for per-agent guides.

---

## The catalog

### Engineering — the SDLC (25 skills)

| Phase | Skills |
|---|---|
| **Define** | interview-me, idea-refine, spec-driven-development |
| **Plan** | planning-and-task-breakdown |
| **Build** | incremental-implementation, test-driven-development, context-engineering, source-driven-development, doubt-driven-development, frontend-ui-engineering, api-and-interface-design |
| **Verify** | browser-testing-with-devtools, debugging-and-error-recovery |
| **Review** | code-review-and-quality, code-simplification, security-and-hardening, performance-optimization |
| **Ship** | git-workflow-and-versioning, ci-cd-and-automation, deprecation-and-migration, documentation-and-adrs, observability-and-instrumentation, shipping-and-launch |
| **Meta** | using-agent-skills, openspec |

### OpenClaw infrastructure (7 skills)

session-lifecycle, knowledge-management, memory-agent, background-execution,
engineering-governance, git-changelog, mcp-orchestrator

### Stack & tools (4 skills)

supabase-assistant, sql-insight, db-readonly, deepwiki

### Specialized dev (5 skills)

i18n-expert, shortcuts-generator, support-response-writer, tech-docs,
github

### Security & network (2 skills)

clawdstrike, network-scanner

### Career & growth (2 skills)

mock-interview-drill, cv-tailor

### Content & creativity (7 skills)

copy-editing, narrative-content, brand-name-forge, content-serializer,
deslop, image-generation, curriculum-builder

### Daily life & tools (7 skills)

adhd-assistant, adhd-daily-planner, apple-photos, calorie-counter, mlx-stt,
checkmate, godot-mcp

**Total: 59 skills.**

Browse the full catalog at [kanam-skills site](#) (GitHub Pages).

---

## Quality

Every bash script ships with a [bats](https://github.com/bats-core/bats-core)
test suite, run in CI on every push. Few skills repos do this.

```bash
npm ci
npx bats tests/bash/
```

## License

MIT — use them, fork them, ship them. See [LICENSE](LICENSE).
