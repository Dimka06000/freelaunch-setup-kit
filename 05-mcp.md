# 5 — Brancher les serveurs MCP sur Claude Code

**MCP** (Model Context Protocol) = la façon standard de donner à Claude Code des **super-pouvoirs
connectés** : interroger ta base Supabase, déployer sur Vercel, lire tes repos GitHub, piloter un
navigateur Playwright, récupérer la doc à jour d'une lib… au lieu de bricoler des appels API à la main.

Un serveur MCP expose des **outils** que Claude peut appeler tout seul pendant qu'il code.

---

## a) Les 3 façons d'ajouter un serveur MCP

### 1. Serveur **local** (stdio) — un programme lancé sur ta machine
```bash
claude mcp add <nom> -s user -- <commande> [args...]
# exemple : navigateur Playwright
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
```
Variables d'env pour le serveur : `-e CLE=valeur` (répétable) :
```bash
claude mcp add supabase -s user -e SUPABASE_ACCESS_TOKEN=sbp_xxx -- npx -y @supabase/mcp-server-supabase@latest --read-only
```

### 2. Serveur **distant** (HTTP / SSE) — hébergé par le fournisseur
```bash
claude mcp add --transport http <nom> <url>
# exemple Vercel :
claude mcp add --transport http vercel https://mcp.vercel.com
```
Avec un header d'auth (si pas d'OAuth) :
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer ghp_ton_token"
```
> Pour les serveurs distants en OAuth (Vercel, Stripe…), ajoute-les **sans header**, puis tape
> `/mcp` dans Claude → choisis le serveur → **Authenticate** → le navigateur s'ouvre pour valider.

### 3. Via **JSON** (config complète d'un coup)
```bash
claude mcp add-json mon-serveur '{"command":"npx","args":["-y","@some/mcp"],"env":{"API_KEY":"xxx"}}'
```

### Les scopes (`-s`)
| Scope | Stocké dans | Visible par |
|-------|-------------|-------------|
| `local` | config interne du projet | toi, ce projet |
| `project` | **`.mcp.json`** à la racine (commit) | toute l'équipe |
| `user` | `~/.claude.json` | toi, **tous** tes projets |

> Recommandation : les outils perso (Playwright, Context7) en `user` ; les serveurs liés au projet
> (Supabase de ce projet) en `project` pour que l'équipe les ait aussi.

---

## b) Le fichier projet `.mcp.json`

Pour partager les serveurs avec l'équipe (et toi sur une autre machine), pose un **`.mcp.json`**
à la racine du repo. Schéma :

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase@latest", "--read-only"],
      "env": { "SUPABASE_ACCESS_TOKEN": "${SUPABASE_ACCESS_TOKEN}" }
    },
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com"
    }
  }
}
```

- **stdio** : `command` + `args` (+ `env`).
- **distant** : `type: "http"` (ou `"sse"`) + `url` (+ `headers`).
- **Variables d'env** : `${VAR}` lit ta variable d'env (erreur si absente), `${VAR:-defaut}` met une
  valeur par défaut. → Tu ne commits jamais le token en clair, juste `${SUPABASE_ACCESS_TOKEN}`.
- À la première ouverture d'un repo avec `.mcp.json`, Claude **demande si tu fais confiance** au projet
  avant d'activer ses serveurs.

→ Template prêt : [templates/mcp.json.example](./templates/mcp.json.example) (copie-le en `.mcp.json`).

---

## c) Gérer les serveurs

```bash
claude mcp list            # liste + état de connexion de tous les serveurs
claude mcp get vercel      # détail d'un serveur
claude mcp remove vercel   # le retirer
```
Dans la session : **`/mcp`** → vue interactive (connecter, authentifier OAuth, voir les outils).

---

## d) 🟥 Les MCP utiles pour construire une plateforme

Copie-colle ces commandes (scope `user` = dispo partout) :

```bash
# Déploiement — Vercel (OAuth via /mcp ensuite)
claude mcp add --transport http vercel https://mcp.vercel.com

# Base de données — Supabase (mets ton access token ; --read-only = plus safe)
claude mcp add supabase -s user -e SUPABASE_ACCESS_TOKEN=sbp_xxx -- npx -y @supabase/mcp-server-supabase@latest --read-only

# Repos & PR — GitHub (token avec scope repo, ou OAuth via /mcp)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ --header "Authorization: Bearer ghp_xxx"

# Navigateur — Playwright (tester l'UI, screenshots, e2e)
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest

# Doc à jour des libs — Context7 (évite que Claude invente des API obsolètes)
claude mcp add --transport http context7 https://mcp.context7.com/mcp
```

### 🟦 Bonus créatif
```bash
# Paiements — Stripe (OAuth via /mcp)
claude mcp add --transport http stripe https://mcp.stripe.com

# UI components — Magic (21st.dev)
claude mcp add magic -s user -- npx -y @21st-dev/magic@latest

# Vidéo cinématique — Higgsfield
claude mcp add --transport http higgsfield https://mcp.higgsfield.ai/mcp
```

---

## e) Vérifier que ça marche

```bash
claude mcp list
# Tu dois voir : ✓ Connected (ou « Needs authentication » → fais /mcp → Authenticate)
```

> 💡 Dans VS Code/Cursor avec l'extension Claude Code : après avoir ajouté un MCP,
> fais **Reload Window** pour qu'il soit pris en compte dans la session de l'éditeur.

➡️ Tout est prêt. On construit la plateforme → [06-creer-la-plateforme.md](./06-creer-la-plateforme.md)
