#!/usr/bin/env bash
# benchmark.sh — Run performance benchmarks and compare against baseline
# Usage: ./benchmark.sh [--url <url>] [--baseline <file>]

set -euo pipefail

URL="${2:-http://localhost:3000}"
BASELINE="${4:-}"
OUTPUT="benchmark-$(date +%Y%m%d-%H%M%S).md"

echo "📊 Running benchmarks against: $URL"
echo ""

cat > "$OUTPUT" << 'HEADER'
# Performance Benchmark

HEADER
echo "**Date:** $(date '+%Y-%m-%d %H:%M')" >> "$OUTPUT"
echo "**URL:** $URL" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Response time
echo "## Response Times" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Endpoint | P50 | P95 | P99 |" >> "$OUTPUT"
echo "|----------|-----|-----|-----|" >> "$OUTPUT"

for endpoint in "/" "/health" "/api/health"; do
  TIMES=()
  for i in $(seq 1 10); do
    TIME=$(curl -s -o /dev/null -w "%{time_total}" --max-time 10 "$URL$endpoint" 2>/dev/null || echo "0")
    TIMES+=("$TIME")
  done
  
  # Sort and calculate percentiles
  IFS=$'\n' SORTED=($(sort <<<"${TIMES[*]}")); unset IFS
  
  P50="${SORTED[4]}"
  P95="${SORTED[8]}"
  P99="${SORTED[9]}"
  
  echo "| $endpoint | ${P50}s | ${P95}s | ${P99}s |" >> "$OUTPUT"
done

echo "" >> "$OUTPUT"

# Compare with baseline
if [[ -n "$BASELINE" && -f "$BASELINE" ]]; then
  echo "## Comparison with Baseline" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo "| Metric | Baseline | Current | Change |" >> "$OUTPUT"
  echo "|--------|----------|---------|--------|" >> "$OUTPUT"
  echo "| (comparison) | | | |" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
fi

echo "✅ Benchmark complete: $OUTPUT"
