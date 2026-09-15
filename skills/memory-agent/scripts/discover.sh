#!/bin/bash
# discover.sh - Scans the workspace and builds a knowledge map
# Usage: ./discover.sh <workspace-path>
# Output: JSON with the knowledge map

WORKSPACE="$1"

if [ -z "$WORKSPACE" ]; then
  echo '{"status":"error","error":"WORKSPACE path required"}'
  exit 1
fi

if [ ! -d "$WORKSPACE" ]; then
  echo "{\"status\":\"error\",\"error\":\"WORKSPACE not found: $WORKSPACE\"}"
  exit 1
fi

# Memory files
MEMORY_FILES=$(find "$WORKSPACE/memory" -name "*.md" -maxdepth 2 2>/dev/null | sort | python3 -c "
import sys, json
files = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(files))
")

# Knowledge files in projects
PROJECT_KNOWLEDGE=$(find "$WORKSPACE/projects" -path "*/.knowledge/*.md" 2>/dev/null | sort | python3 -c "
import sys, json
files = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(files))
")

# Docs
DOCS=$(find "$WORKSPACE/docs" -name "*.md" -maxdepth 2 2>/dev/null | sort | python3 -c "
import sys, json
files = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(files))
")

# Root markdown files
ROOT_DOCS=$(find "$WORKSPACE" -maxdepth 1 -name "*.md" 2>/dev/null | sort | python3 -c "
import sys, json
files = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(files))
")

# Skills
SKILLS=$(find "$WORKSPACE/skills" -name "SKILL.md" -maxdepth 2 2>/dev/null | sort | python3 -c "
import sys, json
files = [l.strip() for l in sys.stdin if l.strip()]
print(json.dumps(files))
")

# Stats
MEM_COUNT=$(echo "$MEMORY_FILES" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")
PROJ_COUNT=$(echo "$PROJECT_KNOWLEDGE" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")
DOC_COUNT=$(echo "$DOCS" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")
SKILL_COUNT=$(echo "$SKILLS" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")

cat <<EOF
{
  "status": "done",
  "workspace": "$WORKSPACE",
  "stats": {
    "memoryFiles": $MEM_COUNT,
    "projectKnowledgeFiles": $PROJ_COUNT,
    "docs": $DOC_COUNT,
    "skills": $SKILL_COUNT,
    "rootDocs": $(echo "$ROOT_DOCS" | python3 -c "import sys,json; print(len(json.loads(sys.stdin.read())))")
  },
  "memoryFiles": $MEMORY_FILES,
  "projectKnowledgeFiles": $PROJECT_KNOWLEDGE,
  "docs": $DOCS,
  "rootDocs": $ROOT_DOCS,
  "skills": $SKILLS
}
EOF
