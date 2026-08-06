---
name: "image-generation"
description: "Generate images for games, web, mockups, placeholders, and creative projects via LLM image APIs."
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

# Image Generation

Generate images for any project: game sprites, web assets, UI mockups, placeholders, marketing art, or creative concepts.

## When to use

- User asks for an image, sprite, icon, texture, thumbnail, or mockup.
- Building a game, website, app, slide deck, or document that needs visuals.
- Need a placeholder while waiting for final art.
- Want to iterate on art direction before involving a human designer.

## Providers

Prefer the provider with confirmed working credentials and quota:

1. **OpenAI Images API** — `gpt-image-1` / `dall-e-3`. Requires `OPENAI_API_KEY`.
2. **Google Gemini / Imagen** — native image generation via `generateContent`. Requires `GEMINI_API_KEY` with billing/cuota.
3. **MCP servers** — optional if user already has a compatible MCP configured (e.g. `@ideepakrajput/gemini-image-generator-mcp`).

Default to **OpenAI Images API** because it has the most reliable image generation quota and output quality.

## API Keys

Store keys outside the workspace in `~/.openclaw/secrets/` with restrictive permissions:

- `~/.openclaw/secrets/openai-api-key`
- `~/.openclaw/secrets/gemini-api-key`

Read them with `cat` inside `exec` calls; never paste keys into chat, skill code, or project files.

## Workflow

1. **Clarify intent** — size/aspect ratio, style, transparency, how it will be used.
2. **Pick provider** — default OpenAI unless user asks for Gemini or an MCP.
3. **Generate** — call the provider API and save image beside the project or in `/tmp`.
4. **Deliver** — show the result as `MEDIA:<path>` or move it into the project assets folder.
5. **Log** — record prompt, path, provider, and usage/cost when relevant.

## Helper script

Use `scripts/generate-image.sh` for one-off generations from inside `exec`:

```bash
# Generate via OpenAI (default)
~/.openclaw/workspace/skills/image-generation/scripts/generate-image.sh openai \
  "A flat vector hero image for a fintech website, minimal, no text" \
  /tmp/fintech_hero.png \
  1792x1024
```

If you modify this skill's script, run `npm test` from the workspace root before committing.

## Best practices

- Add style keywords to every prompt: `pixel art`, `flat vector illustration`, `3D render`, `photorealistic`, `UI mockup`, `transparent background`, etc.
- Request transparent backgrounds only when the provider supports it.
- Prefer square sizes (`1024x1024`) unless the use case needs another aspect ratio.
- For game sprites: include `sprite sheet`, `white background`, `consistent art style`, and `isolated object`.
- For web placeholders: include `abstract`, `minimal`, `neutral colors`, and safe dimensions.
- For mockups: describe the device, layout, and content in text; avoid real brands unless asked.
- Save generated images under `projects/<slug>/assets/generated/` or `~/openclaw-media/generated/` for cross-project reuse.
- Always verify the API call succeeded and the image file has bytes before returning it.

## Prompt templates

- **Game sprite**: `"A 64x64 pixel art {object}, {color}, isolated on transparent background, game sprite asset"`
- **Web hero image**: `"A wide flat vector illustration for a {topic} website hero section, minimal, modern, muted colors, no text"`
- **UI mockup**: `"A clean UI mockup of a {app type} dashboard, light mode, minimal design, no real logos, desktop browser frame"`
- **Placeholder**: `"Abstract soft gradient placeholder image, {color palette}, subtle texture, no text, {aspect ratio}"`

## Tool commands

### OpenAI direct curl

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

### Gemini direct curl (when quota available)

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

## Error handling

- `RESOURCE_EXHAUSTED` / quota error → inform user, suggest checking billing or switching provider.
- `INVALID_ARGUMENT` / bad prompt → simplify and retry.
- `b64_json` missing → inspect raw response and report the API error.
- Empty image file → retry once; if persists, switch provider.

## MCP integration

If the user has a compatible MCP server running, prefer its tools when already configured. Otherwise use the helper script or direct API calls above; they are more reliable than wrapping stdio MCP servers manually.

## Notes

- Keep generated art in a `generated/` subfolder so it is easy to distinguish from final/human-made assets.
- Do not claim copyright or ownership of generated images when discussing licensing with the user.
- For publication, remind the user to review provider terms (OpenAI / Google) for their use case.
