#!/bin/bash
# freshness.sh — Clasifica documentos por antigüedad
# Uso: ./freshness.sh <file1> [file2] ...
# Output: JSON con clasificación 🟢🟡🔴

if [ $# -eq 0 ]; then
  echo '{"status":"error","error":"At least one file required"}'
  exit 1
fi

NOW=$(date +%s)
RESULTS="["
FIRST=true

for FILE in "$@"; do
  if [ ! -f "$FILE" ]; then
    continue
  fi

  MTIME=$(stat -f "%m" "$FILE" 2>/dev/null)
  AGE_DAYS=$(( (NOW - MTIME) / 86400 ))

  if [ "$AGE_DAYS" -le 30 ]; then
    STATUS="green"
    LABEL="Vigente"
  elif [ "$AGE_DAYS" -le 90 ]; then
    STATUS="yellow"
    LABEL="Revisar"
  else
    STATUS="red"
    LABEL="Obsoleto"
  fi

  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    RESULTS+=","
  fi

  RESULTS+="{\"file\":\"$FILE\",\"ageDays\":$AGE_DAYS,\"status\":\"$STATUS\",\"label\":\"$LABEL\"}"
done

RESULTS+="]"

cat <<EOF
{
  "status": "done",
  "files": $RESULTS
}
EOF
