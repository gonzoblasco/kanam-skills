#!/usr/bin/env bash
# setup-fork.sh — Fork + clone + upstream setup for OSS contribution
# Usage: ./setup-fork.sh <owner/repo>

set -euo pipefail

REPO="${1:?Usage: $0 <owner/repo>}"
FORK_DIR=$(basename "$REPO")
# Username del gh autenticado (el fork se crea bajo la cuenta logueada)
GH_USER=$(gh api user --jq '.login' 2>/dev/null || echo "$USER")

echo "🔧 Setting up fork for: $REPO"
echo ""

# Fork via gh
echo "📌 Forking repository..."
gh repo fork "$REPO" --clone --remote=false 2>&1 || {
  echo "⚠️  Fork may already exist, trying to clone..."
}

# Clone the fork
echo "📌 Cloning fork..."
gh repo clone "$GH_USER/$FORK_DIR" 2>/dev/null || {
  echo "⚠️  Fork not found, cloning original..."
  gh repo clone "$REPO"
}

cd "$FORK_DIR"

# Add upstream
echo "📌 Adding upstream remote..."
git remote add upstream "https://github.com/$REPO.git" 2>/dev/null || {
  echo "⚠️  Upstream already configured"
}

# Verify
echo ""
echo "✅ Fork setup complete!"
echo "   Directory: $(pwd)"
echo "   Remotes:"
git remote -v
echo ""
echo "   Workflow:"
echo "   1. git checkout -b fix/issue-123"
echo "   2. make changes"
echo "   3. git commit -S -m \"fix: description\""
echo "   4. git push origin fix/issue-123"
echo "   5. gh pr create --repo $REPO"
