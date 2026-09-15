#!/usr/bin/env bash
# pr-batch-check.sh - Check open PRs across all tracked OSS repos
# Usage: ./pr-batch-check.sh [--json] [--mine-only]
#
# --json       Output as JSON array
# --mine-only  Only show PRs authored by the current gh user

set -euo pipefail

# ── Config ──────────────────────────────────────────────────
# Authenticated gh username (override with --author <user>)
AUTHOR="${GH_AUTHOR:-$(gh api user --jq '.login' 2>/dev/null || echo "$USER")}"
OUTPUT_JSON=false
MINE_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --json) OUTPUT_JSON=true ;;
    --mine-only) MINE_ONLY=true ;;
    --author) AUTHOR="$2"; shift 2 ;;
  esac
done

# ── Repos to check ──────────────────────────────────────────
# Format: "owner/repo"
REPOS=(
  "facebook/astryx"
  "radix-ui/primitives"
  "TanStack/router"
  "vercel/ai"
  "shadcn-ui/ui"
  "t3-oss/create-t3-app"
  "shuding/nextra"
  "payloadcms/payload"
  "google/skills"
  "swiftlang/swift-testing"
)

# ── Check gh CLI ────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  echo "❌ gh CLI not found. Install: brew install gh" >&2
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "❌ Not authenticated. Run: gh auth login" >&2
  exit 1
fi

# ── Fetch PRs ───────────────────────────────────────────────
RESULTS=()

for repo in "${REPOS[@]}"; do
  if [ "$MINE_ONLY" = true ]; then
    prs=$(gh pr list --repo "$repo" --author "$AUTHOR" --state open \
      --json number,title,url,updatedAt,reviewDecision,createdAt,author \
      --jq '.[] | {repo: "'"$repo"'", number, title, url, updatedAt, reviewDecision, createdAt, author: (.author.login // "unknown")}' 2>/dev/null || true)
  else
    prs=$(gh pr list --repo "$repo" --state open \
      --json number,title,url,updatedAt,reviewDecision,createdAt,author \
      --jq '.[] | {repo: "'"$repo"'", number, title, url, updatedAt, reviewDecision, createdAt, author: (.author.login // "unknown")}' 2>/dev/null || true)
  fi

  if [ -n "$prs" ]; then
    while IFS= read -r pr; do
      RESULTS+=("$pr")
    done <<< "$prs"
  fi
done

# ── Output ──────────────────────────────────────────────────
if [ ${#RESULTS[@]} -eq 0 ]; then
  if [ "$OUTPUT_JSON" = true ]; then
    echo "[]"
  else
    echo "✅ No open PRs found across tracked repos."
  fi
  exit 0
fi

if [ "$OUTPUT_JSON" = true ]; then
  echo "["
  first=true
  for pr in "${RESULTS[@]}"; do
    if [ "$first" = true ]; then
      first=false
    else
      echo ","
    fi
    echo "$pr"
  done
  echo "]"
else
  echo "🔍 Open PRs across tracked repos:"
  echo "=================================="
  echo ""
  for pr in "${RESULTS[@]}"; do
    repo=$(echo "$pr" | jq -r '.repo')
    number=$(echo "$pr" | jq -r '.number')
    title=$(echo "$pr" | jq -r '.title')
    url=$(echo "$pr" | jq -r '.url')
    updated=$(echo "$pr" | jq -r '.updatedAt')
    review=$(echo "$pr" | jq -r '.reviewDecision // "NONE"')
    author=$(echo "$pr" | jq -r '.author // "unknown"')

    # Color-code review decision
    case "$review" in
      APPROVED) status="✅ APPROVED" ;;
      CHANGES_REQUESTED) status="🔴 CHANGES REQUESTED" ;;
      REVIEW_REQUIRED) status="🟡 REVIEW REQUIRED" ;;
      *) status="⏳ $review" ;;
    esac

    echo "  $repo#$number - $title"
    echo "  $status | Author: $author | Updated: $updated"
    echo "  $url"
    echo ""
  done
fi
