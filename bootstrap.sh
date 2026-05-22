#!/usr/bin/env bash
# Setup Kit — bootstrap one-liner (macOS / Linux)
# Telecharge le kit depuis GitHub, puis lance le guide (dev serveur + navigateur).
# Usage (une seule commande) :
#   curl -fsSL https://raw.githubusercontent.com/<USER>/<REPO>/main/bootstrap.sh | bash

set -e

REPO="Dimka06000/freelaunch-setup-kit"   # <-- a adapter au repo public reel
BRANCH="main"
DEST="$HOME/setup-kit"

echo ""
echo "  Telechargement du Setup Kit ($REPO)..."
TMP="$(mktemp -d)"
curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar xz -C "$TMP"

rm -rf "$DEST"
mv "$TMP"/*-"$BRANCH" "$DEST"
cd "$DEST"

echo "  Kit installe dans : $DEST"
if command -v node >/dev/null 2>&1; then
  node "$DEST/serve.js"
else
  echo "  Node pas encore installe -> ouverture du guide (mode fichier)."
  if command -v open >/dev/null 2>&1; then open "$DEST/index.html"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$DEST/index.html"
  fi
fi
