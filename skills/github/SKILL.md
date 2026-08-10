---
name: "github"
description: "Agrega un wrapper del GitHub MCP server oficial para herramientas avanzadas: alertas de seguridad, notificaciones, discusiones, project boards, analisis de codigo."
metadata:
  category: "Development"
  tags:
    - github
    - prs
    - issues
    - ci
    - reviews
    - security
    - mcp
    - notifications
    - discussions
---

# GitHub

Usa `gh` para las operaciones comunes de GitHub y el GitHub MCP Server oficial para las herramientas avanzadas que no estan disponibles en `gh`.

## Dos interfaces

### 1. CLI `gh` (default)

Usalo para:
- Listar/ver PRs e issues
- Crear PRs/issues/comentarios
- Chequear corridas de CI
- Consultas basicas de API
- Mergear PRs

### 2. GitHub MCP Server (avanzado)

Usa el wrapper `~/.openclaw/workspace/skills/github/scripts/github-mcp.py` para:
- Alertas de seguridad / Dependabot
- Code scanning
- Notificaciones
- Discusiones
- Project boards
- Operaciones avanzadas de PR/issue
- Herramientas de analisis de codigo

## Requisitos

- CLI `gh` autenticado (`gh auth status`)
- GitHub Personal Access Token guardado en `~/.openclaw/secrets/github-token`
- Binario oficial de GitHub MCP en `~/.openclaw/bin/github-mcp`

## Reglas de Escritura

- **Usa siempre guion comun (-), nunca guion largo (-).** El guion largo no esta en un teclado estandar y hace evidente que el texto no fue escrito por un desarrollador. Esto aplica a descripciones de PR, comentarios, issues y cualquier texto orientado a GitHub.

## Auth

```bash
gh auth status
gh auth login
```

El wrapper de MCP lee `~/.openclaw/secrets/github-token` automaticamente.

## CLI gh: PRs

```bash
gh pr list --repo owner/repo --json number,title,state,author,url
gh pr view 55 --repo owner/repo --json title,body,author,files,commits,reviews,reviewDecision
gh pr checks 55 --repo owner/repo
gh pr diff 55 --repo owner/repo
gh pr create --repo owner/repo --title "feat: title" --body-file /tmp/pr.md
gh pr merge 55 --repo owner/repo --squash
```

Las URLs funcionan directamente: `gh pr view https://github.com/owner/repo/pull/55`.

## CLI gh: Issues

```bash
gh issue list --repo owner/repo --state open --json number,title,labels,url
gh issue view 42 --repo owner/repo --json title,body,comments,labels,state
gh issue create --repo owner/repo --title "Bug: ..." --body-file /tmp/issue.md
gh issue comment 42 --repo owner/repo --body-file /tmp/comment.md
gh issue close 42 --repo owner/repo --comment "Fixed in ..."
```

## CLI gh: CI / Runs

```bash
gh run list --repo owner/repo --limit 10
gh run view <run-id> --repo owner/repo --json status,conclusion,headSha,url
gh run view <run-id> --repo owner/repo --log-failed
gh run rerun <run-id> --repo owner/repo --failed
```

## Wrapper del GitHub MCP Server

```bash
# Lista las herramientas disponibles
~/.openclaw/workspace/skills/github/scripts/github-mcp.py list

# Llama a una herramienta
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_pull_requests '{"owner": "facebook", "repo": "astryx", "state": "open", "limit": 5}'

# Usa toolsets adicionales (security, notifications, discussions, etc.)
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_security_alerts '{"owner": "facebook", "repo": "astryx"}' --toolsets=default,code_security,notifications
```

Toolsets disponibles: `actions`, `code_quality`, `code_security`, `copilot`, `copilot_issue_intents`, `dependabot`, `discussions`, `gists`, `git`, `issues`, `labels`, `notifications`, `orgs`, `projects`, `pull_requests`, `repos`, `secret_protection`, `security_advisories`, `stargazers`, `users`.

Default: `context`, `copilot`, `issues`, `pull_requests`, `repos`, `users`.

## Flujo de trabajo de alertas de seguridad

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_code_scanning_alerts '{"owner": "facebook", "repo": "astryx"}' --toolsets=code_security
```

## Flujo de trabajo de notificaciones

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_notifications '{"limit": 10}' --toolsets=notifications
```

## Project boards

```bash
~/.openclaw/workspace/skills/github/scripts/github-mcp.py call list_projects '{"owner": "facebook"}' --toolsets=projects
```

## CLI gh: API

```bash
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'
gh api repos/owner/repo/labels --jq '.[].name'
gh api --cache 1h repos/owner/repo --jq '{stars: .stargazers_count, forks: .forks_count}'
```

Usa `--json` + `--jq` para una salida estructurada. Usa `--body-file` para comentarios/cuerpos que contengan backticks, fragmentos de shell, nombres de env o texto de usuario.

## CLI gh: Comentarios y Reviews

```bash
# Publica un comentario
gh api repos/owner/repo/issues/42/comments -f body="Your comment here"

# Obtiene todos los comentarios de un issue/PR
gh api repos/owner/repo/issues/42/comments --paginate

# Obtiene un comentario especifico por ID
gh api repos/owner/repo/issues/comments/<comment-id>

# Responde a un review
gh api repos/owner/repo/pulls/55/comments -f body="Thanks, fixed!" -f in_reply_to=<review-comment-id>
```

## Cuando usar gh vs MCP

| Tarea | Usa |
|---|---|
| Operaciones comunes de PR/issue | `gh` |
| Corridas de CI | `gh` |
| Comentarios/reviews | `gh` |
| Alertas de seguridad | MCP |
| Notificaciones | MCP |
| Discusiones | MCP |
| Project boards | MCP |
| Code scanning | MCP |
| Dependabot | MCP |
| Consultas de API complejas | MCP o `gh api` |

## Seguridad

- Mantene `~/.openclaw/secrets/github-token` con `chmod 600`.
- Nunca commitees el token.
- El MCP server puede realizar operaciones de escritura (create/update/delete). Para seguridad de solo lectura, ejecutalo con `--toolsets=default` o usa el flag `--read-only` en el binario si es necesario.
- Prefiere `gh` para operaciones destructivas donde quieras confirmacion explicita.

## Scripts de Ayuda

Scripts en `skills/github/scripts/`:

| Script | Uso |
|---|---|
| `pr-batch-check.sh [--json] [--mine-only]` | Lista PRs abiertos en repos trackeados. Con `--mine-only` filtra por el autor del gh autenticado. Usar para monitorear estado de contribuciones OSS. |
| `github-mcp.py` | Wrapper del GitHub MCP server para operaciones avanzadas (security alerts, notifications, project boards). |

Para triage de issues de un repo especifico, ver [oss-contribution/scripts/triage-issues.sh](../oss-contribution/scripts/triage-issues.sh).

## Relacionados

- `gh-issue-planner`: Para planificar proyectos en GitHub Issues (epics -> stories -> subtasks). SOLO para repos personales.
- `code-review-agent`: Para revision de codigo detallada usando subagentes.
