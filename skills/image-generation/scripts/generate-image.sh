#!/usr/bin/env bash
# generate-image.sh - helper for the image-generation skill
# Usage: generate-image.sh <provider> <prompt> <output-path> [size]
# Providers: openai, gemini

set -euo pipefail

PROVIDER=${1:-openai}
PROMPT=${2:-}
OUT=${3:-/tmp/generated_image.png}
SIZE=${4:-1024x1024}

if [[ -z "$PROMPT" ]]; then
  echo "Usage: generate-image.sh <provider> <prompt> <output-path> [size]" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"

# Escape prompt as JSON string using Python
JSON_PROMPT=$(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$PROMPT")

case "$PROVIDER" in
  openai)
    KEY=$(cat ~/.openclaw/secrets/openai-api-key 2>/dev/null || true)
    if [[ -z "$KEY" ]]; then
      echo "Missing OPENAI_API_KEY in ~/.openclaw/secrets/openai-api-key" >&2
      exit 1
    fi
    RESP=$(curl -s -X POST https://api.openai.com/v1/images/generations \
      -H "Authorization: Bearer $KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"model\": \"gpt-image-1\",
        \"prompt\": $JSON_PROMPT,
        \"size\": \"$SIZE\"
      }")
    echo "$RESP" | OUT_PATH="$OUT" python3 -c "
import sys, json, base64, os
out = os.environ.get('OUT_PATH', '/tmp/generated_image.png')
d = json.load(sys.stdin)
if 'error' in d:
    print('API error:', d['error'].get('message', 'unknown'), file=sys.stderr)
    sys.exit(1)
data = d['data'][0]['b64_json']
with open(out, 'wb') as f:
    f.write(base64.b64decode(data))
print(out)
"
    ;;

  gemini)
    KEY=$(cat ~/.openclaw/secrets/gemini-api-key 2>/dev/null || true)
    if [[ -z "$KEY" ]]; then
      echo "Missing GEMINI_API_KEY in ~/.openclaw/secrets/gemini-api-key" >&2
      exit 1
    fi
    MODEL="gemini-3.1-flash-image-preview"
    RESP=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent?key=$KEY" \
      -H "Content-Type: application/json" \
      -d "{
        \"contents\": [{\"parts\": [{\"text\": $JSON_PROMPT}]}],
        \"generationConfig\": {\"responseModalities\": [\"TEXT\", \"IMAGE\"]}
      }")
    echo "$RESP" | OUT_PATH="$OUT" python3 -c "
import sys, json, base64, os
out = os.environ.get('OUT_PATH', '/tmp/generated_image.png')
d = json.load(sys.stdin)
if 'error' in d:
    print('API error:', d['error'].get('message', 'unknown'), file=sys.stderr)
    sys.exit(1)
parts = d['candidates'][0]['content']['parts']
for p in parts:
    if 'inlineData' in p:
        ext = p['inlineData']['mimeType'].split('/')[-1]
        with open(out, 'wb') as f:
            f.write(base64.b64decode(p['inlineData']['data']))
        print(out)
"
    ;;

  *)
    echo "Unknown provider: $PROVIDER. Use 'openai' or 'gemini'." >&2
    exit 1
    ;;
esac
