# 7 — Architecture des fichiers Claude Code & bonne centralisation

Claude Code lit plusieurs fichiers à des **niveaux différents** (global = toi partout, projet =
ce repo, local = toi sur ce repo). Bien les ranger = un Claude cohérent sans copier-coller partout.

---

## a) La carte complète des fichiers

### 🌍 Niveau GLOBAL — `~/.claude/` (vaut pour TOUS tes projets)

```
~/.claude/
├── CLAUDE.md            # Tes instructions perso valables partout (qui tu es, ton style de travail)
├── settings.json        # Réglages globaux (modèle, permissions par défaut, hooks)
├── commands/            # Slash-commands perso (/ma-commande) dispo dans tous les projets
├── agents/              # Sous-agents réutilisables
└── skills/              # Skills perso
~/.claude.json           # État + serveurs MCP scope "user" + sessions (géré par Claude, n'édite pas à la main)
```

### 📦 Niveau PROJET — racine du repo (partagé avec l'équipe, **commit**)

```
mon-projet/
├── CLAUDE.md                    # Mémoire du projet : stack, conventions, règles métier
├── .mcp.json                    # Serveurs MCP du projet (Supabase de ce projet…)
└── .claude/
    ├── settings.json            # Réglages partagés équipe (permissions, hooks)
    ├── commands/                # Slash-commands spécifiques au projet
    └── agents/                  # Sous-agents spécifiques au projet
```

### 🔒 Niveau LOCAL — perso sur ce repo (**gitignored**, jamais commit)

```
mon-projet/.claude/
└── settings.local.json          # Tes overrides perso (clés, perms) non partagés
```

---

## b) Ordre de priorité (qui gagne quand ça se chevauche)

Du plus fort au plus faible :

```
1. Politique entreprise (managed)        ← imposé, non contournable
2. Arguments CLI (--model, --permission-mode…)
3. .claude/settings.local.json           ← perso projet
4. .claude/settings.json                 ← partagé projet
5. ~/.claude/settings.json               ← global perso
```

Pour la **mémoire** (`CLAUDE.md`), c'est **cumulatif** : Claude charge `~/.claude/CLAUDE.md`
(global) **+** le `CLAUDE.md` du projet **+** ceux des dossiers parents jusqu'à la racine git.
Tout est concaténé dans le contexte.

---

## c) La bonne centralisation — qui va où

> **Règle d'or** : écris chaque chose **une seule fois**, au bon niveau. Si une règle vaut pour
> tous tes projets → global. Si elle est propre à ce repo → projet. Sinon tu dupliques et ça drifte.

| Tu veux… | Mets-le dans | Pourquoi |
|----------|--------------|----------|
| Ton style de travail, ta langue, tes préférences | `~/.claude/CLAUDE.md` | Vrai pour tous tes projets |
| Tes outils MCP perso (Playwright, Context7) | scope `user` (`~/.claude.json`) | Tu les veux partout |
| Un slash-command que tu réutilises (`/commit`, `/review`) | `~/.claude/commands/` | Réutilisable partout |
| Stack, conventions, règles métier **de ce projet** | `CLAUDE.md` (racine repo) | Spécifique + partagé équipe |
| Le MCP Supabase **de ce projet** | `.mcp.json` (commit) | L'équipe doit l'avoir |
| Permissions partagées (allow npm/git) | `.claude/settings.json` | Tout le monde en profite |
| Une clé/perm perso ou un override temporaire | `.claude/settings.local.json` | Perso, pas commit |

### ❌ À éviter
- Copier les mêmes règles dans chaque `CLAUDE.md` de projet → mets-les en **global**.
- Mettre des secrets dans un fichier **commit** (`CLAUDE.md`, `.claude/settings.json`, `.mcp.json`)
  → secrets toujours via `.env` + `${VAR}` dans `.mcp.json`.
- Éditer `~/.claude.json` à la main → passe par `claude mcp add` / `/mcp`.

---

## d) Éviter la duplication : les imports `@`

Dans n'importe quel `CLAUDE.md`, tu peux **importer** un autre fichier avec `@chemin`. Ça garde
une seule source de vérité :

```markdown
# CLAUDE.md du projet
Voir l'architecture détaillée : @docs/architecture.md
Conventions de design : @docs/design-system.md
```

Tu peux aussi importer depuis ton home (`@~/.claude/regles-communes.md`) pour partager un bloc
entre plusieurs projets sans le recopier.

> 💡 Ajouter vite un souvenir : tape `#` au début d'un message dans Claude → il propose de l'écrire
> dans le bon `CLAUDE.md`. Édite la mémoire avec `/memory`.

---

## e) Le layout recommandé (à reproduire)

```
~/.claude/CLAUDE.md            → "Je suis X, je code en français, mobile-first, CLI-first…"
~/.claude/settings.json        → permissions par défaut + hooks globaux
~/.claude/commands/            → /commit, /review… (tes raccourcis)

mon-projet/
├── CLAUDE.md                  → stack + conventions + règles métier DU projet (importe @docs/…)
├── .mcp.json                  → MCP du projet (${SUPABASE_ACCESS_TOKEN})
├── .claude/settings.json      → allow npm/git/vercel, deny .env + rm -rf  (partagé)
├── .claude/settings.local.json→ overrides perso (gitignored)
└── .env.local                 → secrets (gitignored)
```

Templates fournis : [templates/CLAUDE.md.example](./templates/CLAUDE.md.example),
[templates/settings.json.example](./templates/settings.json.example),
[templates/mcp.json.example](./templates/mcp.json.example).

➡️ Retour au [README](./README.md) · ou la recette [06-creer-la-plateforme.md](./06-creer-la-plateforme.md)
