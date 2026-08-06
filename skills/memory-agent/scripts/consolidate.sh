#!/bin/bash
# consolidate.sh — Ejecuta DREAMS consolidation parcial
# Uso: ./consolidate.sh <workspace-path> [days-back]
# Output: JSON con resumen de consolidación

WORKSPACE="$1"
DAYS="${2:-7}"

if [ -z "$WORKSPACE" ]; then
  echo '{"status":"error","error":"WORKSPACE path required"}'
  exit 1
fi

MEMORY_DIR="$WORKSPACE/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"

if [ ! -d "$MEMORY_DIR" ]; then
  echo "{\"status\":\"error\",\"error\":\"memory/ not found in $WORKSPACE\"}"
  exit 1
fi

mkdir -p "$ARCHIVE_DIR"

# Encontrar daily logs de los últimos N días
RECENT_LOGS=$(find "$MEMORY_DIR" -name "*.md" -maxdepth 1 -mtime -"$DAYS" 2>/dev/null | sort)

# Contar
LOG_COUNT=$(echo "$RECENT_LOGS" | grep -c . 2>/dev/null || echo 0)

# Archivar logs individuales (formato YYYY-MM-DD-HHMM.md)
INDIVIDUAL_LOGS=$(find "$MEMORY_DIR" -name "????-??-??-????.md" -maxdepth 1 -mtime +"$DAYS" 2>/dev/null)
ARCHIVED=0

for LOG in $INDIVIDUAL_LOGS; do
  mv "$LOG" "$ARCHIVE_DIR/" 2>/dev/null && ARCHIVED=$((ARCHIVED + 1))
done

# Contar daily consolidados
DAILY_COUNT=$(find "$MEMORY_DIR" -name "????-??-??.md" -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')

cat <<EOF
{
  "status": "done",
  "recentLogs": $LOG_COUNT,
  "archivedIndividualLogs": $ARCHIVED,
  "consolidatedDailyFiles": $DAILY_COUNT,
  "note": "DREAMS partial consolidation executed. Review MEMORY.md for promotion candidates."
}
EOF
