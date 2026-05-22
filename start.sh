#!/usr/bin/env bash
# Setup Kit — lance le guide interactif (macOS / Linux).
# Usage : bash ./start.sh   (ou ./start.sh apres chmod +x)
DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v node >/dev/null 2>&1; then
  node "$DIR/serve.js"
else
  echo ""
  echo "Node.js n'est pas encore installe."
  echo "Ouverture du guide en mode fichier (les boutons Copier marchent mieux avec le serveur)."
  echo "Installe Node (chapitre 0) puis relance ce script pour le dev serveur."
  echo ""
  if command -v open >/dev/null 2>&1; then open "$DIR/index.html"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$DIR/index.html"
  fi
fi
