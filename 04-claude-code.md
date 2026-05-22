# 4 — Claude Code : installer, paramétrer, prendre en main

Claude Code est le copilote qui **lit, écrit, exécute et déploie** ton code depuis le terminal
(et dans VS Code / Cursor via l'extension). C'est lui qui va construire la plateforme.

---

## a) Installer

```powershell
irm https://claude.ai/install.ps1 | iex        # Windows (installeur natif, auto-update)
```
```bash
curl -fsSL https://claude.ai/install.sh | bash  # macOS / Linux
```
> Fallback npm : `npm install -g @anthropic-ai/claude-code`
> Mettre à jour : `claude update` (l'installeur natif se met à jour tout seul).

### Extension IDE (recommandé)
Dans **VS Code** / **Cursor** : installe l'extension « Claude Code ». Tu gardes le diff visuel,
les fichiers cliquables, et la sélection de code partagée avec Claude.

---

## b) Se connecter

```bash
claude            # lance Claude Code ; au 1er run, il ouvre le navigateur pour le login
```
Deux options de connexion :
- **Abonnement Claude** (Pro / Max) → pas de clé API à gérer, facturation incluse. ✅ recommandé pour démarrer.
- **Anthropic Console** (clé API, paiement à l'usage) → `claude` puis choisis « API key », ou
  `claude setup-token` pour un token longue durée (CI/scripts).

Vérifie : `claude --version`.

---

## c) Prendre en main — les commandes de base

### Lancer / reprendre une session
| Commande | Effet |
|----------|-------|
| `claude` | Session interactive dans le dossier courant |
| `claude "construis un formulaire de login"` | Démarre avec un prompt |
| `claude -p "résume ce repo"` | **One-shot** : répond et quitte (parfait pour les scripts) |
| `claude -c` | **Continue** la dernière session de ce dossier |
| `claude --resume` | Choisis une session passée à reprendre |
| `claude --model sonnet` | Force un modèle pour la session |

### Les slash-commands à connaître (dans la session)
| Commande | Effet |
|----------|-------|
| `/init` | Génère un `CLAUDE.md` de départ (analyse le repo) |
| `/clear` | Repart d'une conversation vide (garde la mémoire projet) |
| `/compact` | Résume la conversation pour libérer du contexte |
| `/context` | Visualise l'usage du contexte |
| `/model` | Change de modèle (Opus / Sonnet / Haiku) |
| `/mcp` | Gère les serveurs MCP + lance les auth OAuth |
| `/agents` | Liste/configure les sous-agents |
| `/permissions` | Règle les autorisations d'outils |
| `/config` | Réglages (thème, modèle, etc.) |
| `/help` | Toutes les commandes |

### `CLAUDE.md` = la mémoire du projet
À la racine du repo, c'est le fichier que Claude lit **à chaque session**. Mets-y :
conventions de code, stack, règles métier, « ne fais pas X ». Lance `/init` pour le créer,
puis enrichis-le. Un bon `CLAUDE.md` = un Claude qui code dans ton style.
→ Template prêt : [templates/CLAUDE.md.example](./templates/CLAUDE.md.example)

---

## d) ⚙️ Paramétrage — `settings.json` et permissions

Claude demande une **autorisation avant les actions sensibles** (exécuter une commande, écrire
un fichier…). Tu contrôles ça finement via des fichiers de réglages :

| Fichier | Portée |
|---------|--------|
| `~/.claude/settings.json` | **Global** (tous tes projets) |
| `.claude/settings.json` | **Projet** (partagé avec l'équipe, commit) |
| `.claude/settings.local.json` | **Projet, perso** (gitignored) |

### Les modes de permission

| Mode | Comportement |
|------|--------------|
| `default` | Demande confirmation pour chaque action sensible |
| `acceptEdits` | Auto-accepte les **éditions de fichiers**, demande pour le reste |
| `plan` | **Plan mode** : Claude propose un plan, ne touche à rien tant que tu ne valides pas |
| `bypassPermissions` | ⚠️ **Ne demande plus rien** (voir section bypass ci-dessous) |

> 🔁 **Astuce** : dans la session, **Shift+Tab** fait défiler les modes (default → acceptEdits → plan).
> Tu vois le mode courant en bas de l'écran.

### Exemple de `settings.json` (permissions allow/deny)

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Bash(npm run *)",
      "Bash(git status)",
      "Bash(git add :*)",
      "Bash(git commit :*)",
      "Bash(vercel *)",
      "Read(./**)",
      "Edit(./src/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.local)",
      "Bash(rm -rf :*)"
    ]
  }
}
```
- `allow` : actions auto-approuvées (plus de pop-up).
- `deny` : actions **toujours bloquées** — mets-y la lecture des `.env` pour que tes secrets ne fuitent jamais dans le contexte, et les commandes destructrices.
- Format : `Outil(motif)` — `:*` = « tout ce qui commence par ».

→ Template prêt à copier : [templates/settings.json.example](./templates/settings.json.example)
(à placer dans `.claude/settings.json` à la racine du projet).

---

## e) 🟥 Bypass / « dangerous mode » — le mode sans confirmations

Quand tu fais confiance à Claude pour enchaîner du travail sans t'arrêter à chaque étape
(typiquement une longue session de build), tu peux désactiver les confirmations :

### En ligne de commande (le « YOLO mode »)
```bash
claude --dangerously-skip-permissions
```
Claude n'attend plus aucune validation : il lit, écrit, exécute, déploie en autonomie.

### En réglage permanent (équivalent)
```json
{ "permissions": { "defaultMode": "bypassPermissions" } }
```

### ⚠️ À lire avant d'activer le bypass
- N'utilise ça **que dans un dossier de projet que tu contrôles** (idéalement un repo git, pour
  pouvoir tout annuler avec `git`), **jamais** sur ton home ou un système.
- Garde un **`deny` sur `.env*` et `rm -rf`** dans `settings.json` même en bypass : ça reste un
  garde-fou utile contre les accidents et les fuites de secrets.
- Sur du code que tu ne maîtrises pas (repo cloné inconnu), **n'active pas** le bypass : un fichier
  piégé pourrait pousser Claude à exécuter une commande hostile (prompt injection).
- Tu peux toujours **annuler** : `git` (revert), ou `/rewind` dans la session pour revenir en arrière.

> 💡 Bon compromis au quotidien : `defaultMode: "acceptEdits"` + un `allow` généreux sur les
> commandes safe (npm, git, vercel) + `deny` sur le destructeur. Tu gardes la fluidité sans le
> risque du bypass total.

---

## f) Aller plus loin (quand tu seras à l'aise)

- **Slash-commands custom** : crée `.claude/commands/ma-commande.md` (markdown) → dispo en `/ma-commande`.
- **Sous-agents** : `.claude/agents/<nom>.md` (frontmatter YAML + instructions) → Claude délègue des
  tâches (review, exploration…) à des agents spécialisés. Liste-les avec `/agents`.
- **Hooks** : exécute un script auto avant/après une action (formatter, lint, notif).

➡️ Ensuite : brancher les serveurs MCP → [05-mcp.md](./05-mcp.md)
