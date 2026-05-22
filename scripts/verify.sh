#!/usr/bin/env bash
# Setup Kit — Verification (macOS / Linux)
# Usage : bash ./scripts/verify.sh

check() {
  if command -v "$2" >/dev/null 2>&1; then
    ver=$("$2" --version 2>/dev/null | head -n1)
    printf "[OK]   %-12s %s\n" "$1" "$ver"
  else
    printf "[MANQ] %-12s introuvable\n" "$1"
  fi
}

echo ""
echo "--- Verification de l'environnement ---"
echo ""
check "node"     node
check "npm"      npm
check "git"      git
check "gh"       gh
check "vercel"   vercel
check "supabase" supabase
check "stripe"   stripe
check "claude"   claude
echo ""
echo "Tout en [OK] ? Passe a 02-github.md"
echo ""
