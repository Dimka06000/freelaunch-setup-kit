#!/usr/bin/env bash
# Setup Kit — bootstrap one-liner (macOS / Linux)
# UNE commande qui : telecharge le kit -> INSTALLE TOUS LES CLI -> ouvre le guide pour la suite.
# Usage :
#   curl -fsSL https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/bootstrap.sh | bash

set -e

REPO="Dimka06000/freelaunch-setup-kit"
BRANCH="main"
DEST="$HOME/setup-kit"

echo ""
echo "  [1/3] Telechargement du Setup Kit ($REPO)..."
TMP="$(mktemp -d)"
curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar xz -C "$TMP"
rm -rf "$DEST"
mv "$TMP"/*-"$BRANCH" "$DEST"
cd "$DEST"

echo ""
echo "  [2/3] Installation de tous les outils (quelques minutes)..."
bash "$DEST/scripts/install-mac.sh"

# Rafraichit l'env brew pour que node soit dispo
for b in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.linuxbrew/bin/brew" /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$b" ] && eval "$("$b" shellenv)"
done

echo ""
echo "  [3/3] Ouverture du guide (connexions + cles API)..."
if command -v node >/dev/null 2>&1; then node "$DEST/serve.js"
else
  if command -v open >/dev/null 2>&1; then open "$DEST/index.html"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$DEST/index.html"
  fi
fi
