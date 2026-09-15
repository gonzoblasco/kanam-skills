#!/usr/bin/env bash
# triage-issues.sh - Find open issues without PRs in target repos
# Usage: ./triage-issues.sh <repo> [--label <label>] [--limit <n>]

set -euo pipefail

REPO="${1:?Usage: $0 <repo> [--label <label>] [--limit <n>]}"
LABEL=""
LIMIT=10

while [[ $# -gt 0 ]]; do
  case "$1" in
    --label) LABEL="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo "🔎 Triaging issues in: $REPO"
echo ""

# Build gh command
CMD="gh issue list --repo $REPO --state open --json number,title,labels,comments,updatedAt,url --limit $LIMIT"
if [[ -n "$LABEL" ]]; then
  CMD="$CMD --label \"$LABEL\""
fi

ISSUES=$(eval "$CMD" 2>/dev/null || echo "[]")

node -e "
const issues = $ISSUES;

if (issues.length === 0) {
  console.log('📭 No open issues found');
  process.exit(0);
}

console.log('| # | Title | Labels | Comments | Updated |');
console.log('|---|-------|--------|----------|---------|');

issues.forEach(issue => {
  const labels = (issue.labels || []).map(l => l.name).join(', ');
  const updated = new Date(issue.updatedAt).toLocaleDateString();
  console.log('| ' + issue.number + ' | ' + issue.title.substring(0, 50) + ' | ' + labels.substring(0, 30) + ' | ' + (issue.comments?.totalCount || 0) + ' | ' + updated + ' |');
});

console.log('');
console.log('🔗 Links:');
issues.forEach(issue => {
  console.log('  #' + issue.number + ': ' + issue.url);
});
"
