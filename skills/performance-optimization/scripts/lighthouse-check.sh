#!/usr/bin/env bash
# lighthouse-check.sh — Run Lighthouse and check scores
# Usage: ./lighthouse-check.sh <url> [--min-score <n>]

set -euo pipefail

URL="${1:?Usage: $0 <url> [--min-score <n>]}"
MIN_SCORE="${3:-90}"

echo "🏗️ Running Lighthouse audit on: $URL"
echo ""

# Run Lighthouse
npx lighthouse "$URL" --output json --output-path /tmp/lighthouse-report.json --quiet --chrome-flags="--headless" 2>/dev/null || {
  echo "❌ Lighthouse failed to run"
  exit 1
}

# Parse scores
node -e "
const report = require('/tmp/lighthouse-report.json');
const categories = report.categories;
const scores = {
  performance: Math.round(categories.performance.score * 100),
  accessibility: Math.round(categories.accessibility.score * 100),
  seo: Math.round(categories.seo.score * 100),
  'best-practices': Math.round(categories['best-practices'].score * 100),
};

console.log('📊 Lighthouse Scores:');
console.log('');

let allPass = true;
Object.entries(scores).forEach(([category, score]) => {
  const status = score >= $MIN_SCORE ? '✅' : '❌';
  console.log('  ' + status + ' ' + category + ': ' + score);
  if (score < $MIN_SCORE) allPass = false;
});

console.log('');
if (allPass) {
  console.log('✅ All scores above $MIN_SCORE');
} else {
  console.log('❌ Some scores below $MIN_SCORE threshold');
  process.exit(1);
}
"
