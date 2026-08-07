---
name: "mcp-orchestrator"
description: "Re-propuesta del skill mcp-orchestrator (la anterior quedo stale)"
metadata:
  version: 1.0.0
  author: Kanam
  tags: [mcp, integration, orchestration, evaluation]
  user-invocable: true
---

# MCP Orchestrator

Skill central para gestionar servidores MCP como infraestructura descubrible. Decide si instalar un MCP externo, absorber su idea en una skill nativa de OpenClaw, o descartarlo.

## Cuándo usar

- Alguien comparte un servidor MCP, una awesome list o un plugin de MCPMarket.
- Necesitás comparar múltiples servidores MCP para la misma tarea.
- Querés envolver un servidor MCP en un script helper local (stdio, SSE, Streamable HTTP).
- Necesitás combinar múltiples servidores MCP en un solo workflow.
- Estás evaluando si una herramienta externa debería convertirse en una skill nativa.

## Principios

1. Preferir skills nativas de OpenClaw por sobre servidores MCP frágiles/de pago/redundantes.
2. Absorber buenas ideas de herramientas externas en skills nativas en vez de instalar dependencias.
3. Guardar todas las API keys y tokens fuera del workspace en `~/.openclaw/secrets/`.
4. Nunca instalar un servidor que requiera riesgo de cuenta personal (WhatsApp, Instagram, email personal) sin aprobación explícita.
5. Favorecer servidores que sean: open source, mantenidos activamente, con free tier que funciona de verdad, local-first, sin laberinto de OAuth.

## Workflow: evaluar un servidor MCP

1. Obtener el README y la info del paquete. Usar `web_fetch` o `web_search`.
2. Puntuar contra el checklist:
   - ¿OpenClaw ya tiene cobertura nativa? (browser, web_search, db_query, etc.)
   - ¿Es open source y está mantenido? (último commit, issues, estrellas)
   - ¿El free tier funciona de verdad? (probar si hace falta)
   - ¿Requiere credenciales personales o un servicio de pago?
   - ¿Es lo bastante estable como para depender de él? (stdio/SSE/HTTP, manejo de errores)
   - ¿Es redundante con una skill existente?
3. Decidir:
   - **Instalar**: correr el servidor, envolverlo en `scripts/<server>-mcp.py` o `.sh`, verificar `tools/list`.
   - **Absorber**: capturar la idea útil en una propuesta de skill existente o nueva vía `skill_workshop`.
   - **Descartar**: documentar el motivo en las daily notes y seguir adelante.
4. Si se instala, guardar el wrapper bajo `skills/<skill>/scripts/`, nunca guardar secrets en el código.
5. Si se absorbe, crear o actualizar una propuesta de `skill_workshop` de inmediato.
6. Registrar la decisión en `memory/YYYY-MM-DD.md`.

## Workflow: evaluar una awesome list o colección de MCPMarket

1. Obtener la lista completa. Guardarla como artefacto markdown si es grande.
2. Categorizar las entradas (DB, web, social, dev tools, multimedia, cloud, etc.).
3. Para cada entrada, correr rápido el checklist de servidor único.
4. Producir una tabla de triage: install / absorb / discard / standby.
5. Destacar los mejores candidatos e ideas a absorber.
6. Registrar los items de backlog en la tabla SQLite `backlog` para skills de seguimiento.

## Workflow: envolver un servidor MCP

1. Identificar el transporte: stdio, SSE o Streamable HTTP.
2. Para servidores stdio (la mayoría de los MCP de Node/Python):
   - Crear un wrapper Python `scripts/<server>-mcp.py` que haga el handshake completo de initialize de MCP.
   - Soportar subcomandos `list` y `call <tool> [args]`.
   - Leer el token de `~/.openclaw/secrets/<name>` si hace falta.
   - Patrón de ejemplo: `skills/github/scripts/github-mcp.py`.
3. Para servidores HTTP:
   - Crear `scripts/<server>-mcp.sh` o un helper Python que gestione la sesión y envíe JSON-RPC.
   - Patrón de ejemplo: `/tmp/godot-mcp.sh`.
4. Probar con `tools/list` y una llamada a tool antes de considerarlo funcionando.

## Workflow: orquestar múltiples MCPs

1. Definir la tarea y los MCPs involucrados.
2. Usar los scripts wrapper como límites deterministas de pasos.
3. Encadenar salidas: el resultado de un MCP se vuelve la entrada del siguiente.
4. Mantener las salidas intermedias en artefactos de `/tmp/` o `memory/` para inspección.
5. Agregar manejo de errores: si falla una llamada MCP, detenerse y reportar.
6. Documentar la receta de orquestación en el `.knowledge/` del proyecto relevante o en `references/` de la skill.

## Helpers

- `scripts/discover-mcp.py`: Buscar en awesome lists y MCPMarket servidores MCP que coincidan con una query.
- `scripts/evaluate-mcp.py`: Puntuar un candidato contra el checklist y devolver install/absorb/discard/standby.
- `scripts/wrap-stdio-mcp.py`: Generar un wrapper stdio MCP a partir del comando del servidor y un nombre de secret opcional.
- `scripts/wrap-http-mcp.py`: Generar un wrapper HTTP MCP para endpoints SSE/Streamable.

Si modificás alguno de estos scripts, corré `npm test` desde la raíz del workspace antes de commitear.

## Reglas de seguridad

- No ejecutar comandos de instalación arbitrarios de READMEs externos sin inspeccionarlos.
- Preferir `npx -y <package>` o `pip install --user` por sobre instalaciones globales al probar.
- Nunca pegar API keys en el chat, archivos del workspace o commits de Git.
- Si un servidor pide OAuth, login por browser o escaneo de QR, pausar y preguntar al usuario.
- Si un servidor envía mensajes, publica contenido público o accede a cuentas personales, preguntar primero.

## Decisiones comunes

- Búsqueda web / fetch / automatización de browser → usar las tools nativas de OpenClaw, descartar MCPs externos.
- Acceso a bases de datos → preferir `db_query`/`db_execute` y skills específicas de proyecto como `supabase-assistant`.
- Generación de imágenes → usar la skill nativa `image-generation` (OpenAI/Gemini).
- Componentes UI / shadcn → usar la skill nativa `ui-generation`.
- Investigación de diseño / revisión visual → usar la skill nativa `design-orchestrator`.
- Agent workflow / multi-agente → usar la skill nativa `agent-workflow`.
- Desarrollo de juegos Godot → usar la skill nativa `godot-mcp` con `yanhuifair/godot-mcp`.
- GitHub → usar la skill nativa `github` con el wrapper opcional `github-mcp.py`.

## Integración con backlog

Después de evaluar, registrar las ideas de seguimiento en la tabla SQLite `backlog`:

```sql
INSERT INTO backlog (title, priority, status) VALUES
('Evaluar browsermcp/mcp como complemento de browser nativo', 'low', 'pending'),
('Crear skill docker-assistant con docker-mcp', 'low', 'pending');
```

## Referencias

- `references/mcp-transports.md` - detalles de handshake de stdio, SSE, Streamable HTTP.
- `references/wrapper-template.py` - plantilla para wrapper stdio MCP.
- `references/evaluation-criteria.md` - checklist completo con ejemplos.
