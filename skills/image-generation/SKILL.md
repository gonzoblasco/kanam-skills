---
name: "image-generation"
description: "Genera imágenes para juegos, web, mockups, placeholders y proyectos creativos mediante APIs de imágenes por LLM."
metadata:
  version: 1.0.0
  author: Kanam
  tags: ["images", "assets", "openai", "gemini", "mcp", "game-dev", "web", "mockups"]
allowed-tools:
  - exec
  - read
  - write
  - file_write
  - image
  - web_fetch
  - web_search
  - db_execute
  - db_query
  - skill_workshop
---

# Generación de Imágenes

Genera imágenes para cualquier proyecto: sprites de juegos, assets web, mockups de UI, placeholders, arte de marketing o conceptos creativos.

## Cuándo usarla

- El usuario pide una imagen, sprite, ícono, textura, thumbnail o mockup.
- Construir un juego, sitio web, app, presentación o documento que necesita visuales.
- Necesitas un placeholder mientras esperas el arte final.
- Quieres iterar sobre la dirección del arte antes de involucrar a un diseñador humano.

## Proveedores

Prefiere el proveedor con credenciales confirmadas y cuota disponible:

1. **OpenAI Images API** - `gpt-image-1` / `dall-e-3`. Requiere `OPENAI_API_KEY`.
2. **Google Gemini / Imagen** - generación nativa de imágenes vía `generateContent`. Requiere `GEMINI_API_KEY` con billing/cuota.
3. **Servidores MCP** - opcional si el usuario ya tiene un MCP compatible configurado (ej: `@ideepakrajput/gemini-image-generator-mcp`).

Por defecto, usa **OpenAI Images API** porque tiene la cuota de generación de imágenes y la calidad de salida más confiables.

## API Keys

Guarda las claves fuera del workspace en `~/.openclaw/secrets/` con permisos restrictivos:

- `~/.openclaw/secrets/openai-api-key`
- `~/.openclaw/secrets/gemini-api-key`

Léelas con `cat` dentro de llamadas `exec`; nunca pegues claves en el chat, en el código de la skill o en archivos del proyecto.

## Workflow

1. **Aclarar la intención** - tamaño/proporción, estilo, transparencia, cómo se usará.
2. **Elegir proveedor** - por defecto OpenAI salvo que el usuario pida Gemini o un MCP.
3. **Generar** - llama a la API del proveedor y guarda la imagen junto al proyecto o en `/tmp`.
4. **Entregar** - muestra el resultado como `MEDIA:<path>` o muévelo a la carpeta de assets del proyecto.
5. **Registrar** - anota el prompt, la ruta, el proveedor y el uso/costo cuando sea relevante.

## Script de ayuda

Usa `scripts/generate-image.sh` para generaciones puntuales desde `exec`:

```bash
# Generar vía OpenAI (default)
~/.openclaw/workspace/skills/image-generation/scripts/generate-image.sh openai \
  "A flat vector hero image for a fintech website, minimal, no text" \
  /tmp/fintech_hero.png \
  1792x1024
```

Si modificas el script de esta skill, ejecuta `npm test` desde la raíz del workspace antes de commitear.

## Mejores prácticas

- Agrega keywords de estilo a todo prompt: `pixel art`, `flat vector illustration`, `3D render`, `photorealistic`, `UI mockup`, `transparent background`, etc.
- Solicita fondos transparentes solo cuando el proveedor lo soporte.
- Prefiere tamaños cuadrados (`1024x1024`) salvo que el caso de uso necesite otra proporción.
- Para sprites de juegos: incluye `sprite sheet`, `white background`, `consistent art style` e `isolated object`.
- Para placeholders web: incluye `abstract`, `minimal`, `neutral colors` y dimensiones seguras.
- Para mockups: describe el dispositivo, el layout y el contenido en texto; evita marcas reales salvo que se pidan.
- Guarda las imágenes generadas en `projects/<slug>/assets/generated/` o `~/openclaw-media/generated/` para reutilizarlas entre proyectos.
- Verifica siempre que la llamada a la API haya tenido éxito y que el archivo de imagen tenga bytes antes de devolverlo.

## Plantillas de prompts

- **Sprite de juego**: `"A 64x64 pixel art {object}, {color}, isolated on transparent background, game sprite asset"`
- **Imagen hero web**: `"A wide flat vector illustration for a {topic} website hero section, minimal, modern, muted colors, no text"`
- **Mockup de UI**: `"A clean UI mockup of a {app type} dashboard, light mode, minimal design, no real logos, desktop browser frame"`
- **Placeholder**: `"Abstract soft gradient placeholder image, {color palette}, subtle texture, no text, {aspect ratio}"`

## Comandos de herramientas

### OpenAI curl directo

```bash
KEY=$(cat ~/.openclaw/secrets/openai-api-key)
OUT="/tmp/openai_$(date +%s).png"
JSON=$(curl -s -X POST https://api.openai.com/v1/images/generations \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-1",
    "prompt": "{prompt}",
    "size": "1024x1024"
  }')
echo "$JSON" | python3 -c "import sys,json,base64; d=json.load(sys.stdin); data=d['data'][0]['b64_json']; open('$OUT','wb').write(base64.b64decode(data))"
echo "$OUT"
```

### Gemini curl directo (cuando haya cuota disponible)

```bash
KEY=$(cat ~/.openclaw/secrets/gemini-api-key)
MODEL="gemini-3.1-flash-image-preview"
OUT="/tmp/gemini_$(date +%s).png"
RESP=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{"parts": [{"text": "{prompt}"}]}],
    "generationConfig": {"responseModalities": ["TEXT", "IMAGE"]}
  }')
echo "$RESP" | python3 -c "import sys,json,base64; d=json.load(sys.stdin); parts=d['candidates'][0]['content']['parts']; [open('$OUT','wb').write(base64.b64decode(p['inlineData']['data'])) for p in parts if 'inlineData' in p]"
echo "$OUT"
```

## Manejo de errores

- `RESOURCE_EXHAUSTED` / error de cuota: informa al usuario, sugiere revisar el billing o cambiar de proveedor.
- `INVALID_ARGUMENT` / mal prompt: simplifica y reintenta.
- Falta `b64_json`: inspecciona la respuesta cruda y reporta el error de la API.
- Archivo de imagen vacío: reintenta una vez; si persiste, cambia de proveedor.

## Integración MCP

Si el usuario tiene un servidor MCP compatible corriendo, prefiere sus herramientas cuando ya estén configuradas. De lo contrario, usa el script de ayuda o las llamadas directas a la API de arriba; son más confiables que envolver servidores MCP de stdio manualmente.

## Notas

- Mantén el arte generado en una subcarpeta `generated/` para que sea fácil distinguirlo de los assets finales/hechos por humanos.
- No reclames copyright ni propiedad de las imágenes generadas cuando hables de licencias con el usuario.
- Para publicación, recuérdale al usuario revisar los términos del proveedor (OpenAI / Google) para su caso de uso.
