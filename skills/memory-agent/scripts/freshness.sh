#!/bin/bash
# freshness.sh - Classifies documents by age
# Usage: ./freshness.sh <file1> [file2] ...
# Output: JSON with 🟢🟡🔴 classification

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
    LABEL="Current"
  elif [ "$AGE_DAYS" -le 90 ]; then
    STATUS="yellow"
    LABEL="Review"
  else
    STATUS="red"
    LABEL="Outdated"
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
