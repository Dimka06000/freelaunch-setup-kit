#!/usr/bin/env bash
# Setup Kit — Installation des CLI (macOS / Linux)
# Usage : bash ./scripts/install-mac.sh
# Idempotent : ne reinstalle pas ce qui est deja present.

set -e
have() { command -v "$1" >/dev/null 2>&1; }
step() { printf "\n=== %s ===\n" "$1"; }

# --- Homebrew ---
step "Homebrew"
if have brew; then
  echo "brew OK"
else
  echo "Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo ">> Ajoute brew au PATH si demande, puis relance ce script."
fi

# --- Node ---
step "Node.js"
if have node; then echo "Node: $(node -v)"; else brew install node; fi

# --- Git ---
step "Git"
if have git; then echo "git: $(git --version)"; else brew install git; fi

# --- GitHub CLI ---
step "GitHub CLI (gh)"
if have gh; then echo "gh OK"; else brew install gh; fi

# --- Supabase CLI ---
step "Supabase CLI"
if have supabase; then echo "supabase: $(supabase --version)"; else brew install supabase/tap/supabase; fi

# --- Stripe CLI ---
step "Stripe CLI"
if have stripe; then echo "stripe: $(stripe --version)"; else brew install stripe/stripe-cli/stripe; fi

# --- Vercel CLI ---
step "Vercel CLI"
if have vercel; then echo "vercel: $(vercel --version)"; else npm install -g vercel; fi

# --- Claude Code ---
step "Claude Code"
if have claude; then echo "claude OK"; else curl -fsSL https://claude.ai/install.sh | bash; fi

printf "\nTermine. Lance: bash ./scripts/verify.sh\n"
echo "Prochaines etapes :"
echo "  1) gh auth login          (chapitre 02-github)"
echo "  2) vercel login / supabase login / stripe login"
echo "  3) claude                 (chapitre 04-claude-code)"
