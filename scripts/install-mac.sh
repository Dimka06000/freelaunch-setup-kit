#!/usr/bin/env bash
# Setup Kit — Installation AUTOMATIQUE de tous les CLI (macOS / Linux)
# Tout via Homebrew : node, git, gh, supabase, stripe, vercel, Claude Code.
# Idempotent. Rafraichit l'environnement brew en live.

set -e
have(){ command -v "$1" >/dev/null 2>&1; }
step(){ printf "\n=== %s ===\n" "$1"; }
brew_env(){ for b in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.linuxbrew/bin/brew" /home/linuxbrew/.linuxbrew/bin/brew; do [ -x "$b" ] && eval "$("$b" shellenv)"; done; }

step "Homebrew"
if have brew; then echo "brew OK"; else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew_env

step "Node.js + git + GitHub CLI"
have node || brew install node
have git  || brew install git
have gh   || brew install gh

step "Supabase CLI"
have supabase || brew install supabase/tap/supabase

step "Stripe CLI"
have stripe || brew install stripe/stripe-cli/stripe

step "Vercel CLI"
have vercel || npm install -g vercel

step "Claude Code"
have claude || { curl -fsSL https://claude.ai/install.sh | bash; }

step "Verification"
for t in node git gh vercel supabase stripe claude; do
  if have "$t"; then echo "[OK]   $t"; else echo "[A REVOIR] $t (rouvre le terminal puis relance si besoin)"; fi
done
echo ""
echo "Outils installes. Il reste les etapes qui demandent TES comptes :"
echo "  - connexions : gh auth login / vercel login / supabase login / stripe login / claude"
echo "  - cles API : voir le guide (chapitre 03)."
