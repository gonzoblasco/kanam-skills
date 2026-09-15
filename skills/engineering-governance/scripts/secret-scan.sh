#!/usr/bin/env bash
# secret-scan.sh - Scan git history for leaked secrets
# Usage: ./secret-scan.sh [--repo <path>] [--branch <branch>] [--severity low|medium|high]

set -euo pipefail

REPO="."
BRANCH="--all"
SEVERITY="low"
SINCE=""
FORMAT="table"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --severity) SEVERITY="$2"; shift 2 ;;
    --since) SINCE="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

cd "$REPO"

echo "🔒 Secret scan: $REPO"
echo ""

# Patterns to detect
PATTERNS=(
  'AKIA[0-9A-Z]{16}'                    # AWS Access Key
  '-----BEGIN RSA PRIVATE KEY-----'      # SSH Private Key
  '-----BEGIN OPENSSH PRIVATE KEY-----'  # OpenSSH Private Key
  'ghp_[0-9a-zA-Z]{36}'                 # GitHub Token
  'gho_[0-9a-zA-Z]{36}'                 # GitHub OAuth
  'xox[baprs]-[0-9a-zA-Z]{10,}'        # Slack Token
  'sk-[0-9a-zA-Z]{20,}'                 # OpenAI API Key
  'SG\.[0-9a-zA-Z]{22}\.[0-9a-zA-Z]{43}' # SendGrid Key
)

echo "| Pattern | Severity | Found |"
echo "|---------|----------|-------|"

TOTAL=0
for pattern in "${PATTERNS[@]}"; do
  COUNT=$(git log "$BRANCH" --diff-filter=A --format="" -p 2>/dev/null | grep -cE "$pattern" 2>/dev/null || true)
  COUNT=${COUNT:-0}
  if [[ "$COUNT" -gt 0 ]]; then
    echo "| \`$pattern\` | high | $COUNT |"
    TOTAL=$((TOTAL + COUNT))
  fi
done

if [[ "$TOTAL" -eq 0 ]]; then
  echo "✅ No secrets found in git history"
else
  echo ""
  echo "⚠️  $TOTAL potential secrets found. Review and revoke immediately."
fi
