# 🚀 Kit de setup — De zéro à une plateforme SaaS

Ce kit installe **tout l'environnement de dev** pour construire une plateforme moderne
(type Next.js + Supabase + Stripe + Vercel, comme Freelaunch) **de A à Z**, piloté par
**Claude Code** + des serveurs **MCP**.

Tu pars d'une machine vierge → tu finis avec :

- les bons **CLI** installés (Node, git, GitHub, Vercel, Supabase, Stripe, Claude Code…)
- **GitHub** configuré proprement (SSH, `gh`, premier repo)
- toutes les **clés API essentielles** récupérées et rangées dans `.env.local`
- **Claude Code** installé, paramétré (permissions, bypass mode) et pris en main
- les **serveurs MCP** branchés à Claude Code (Vercel, Supabase, GitHub, Playwright…)
- une **recette complète** pour scaffolder une plateforme et la déployer

---

## 📋 Suis les fichiers dans l'ordre

| # | Fichier | Ce que tu fais |
|---|---------|----------------|
| 0 | [00-prerequis.md](./00-prerequis.md) | Terminal, gestionnaire de paquets, Node.js |
| 1 | [01-cli-tools.md](./01-cli-tools.md) | Installer tous les CLI (auto via script ou à la main) |
| 2 | [02-github.md](./02-github.md) | Git + GitHub : identité, SSH, `gh`, premier repo |
| 3 | [03-api-keys.md](./03-api-keys.md) | Récupérer chaque clé API + remplir `.env.local` |
| 4 | [04-claude-code.md](./04-claude-code.md) | Installer, **paramétrer (permissions/bypass)** et prendre en main Claude Code |
| 5 | [05-mcp.md](./05-mcp.md) | Brancher les serveurs MCP sur Claude Code |
| 6 | [06-creer-la-plateforme.md](./06-creer-la-plateforme.md) | La recette A→Z : scaffold + Supabase + Stripe + déploiement |
| 7 | [07-claude-architecture.md](./07-claude-architecture.md) | Architecture des fichiers Claude (global vs projet) + bonne centralisation |

> 🟢 **Pressé ?** Lance le script d'installation auto (chapitre 1), fais GitHub (chapitre 2),
> puis saute directement au chapitre 4 (Claude Code) et 6 (créer la plateforme).

---

## 📁 Ce qu'il y a dans le kit

```
setup-kit/
├── README.md                    ← tu es ici
├── index.html                   ← guide interactif (s'ouvre dans le navigateur)
├── serve.js                     ← dev serveur Node (zéro dépendance)
├── start.cmd / start.sh         ← lance le guide en 1 double-clic / 1 commande
├── bootstrap.ps1 / bootstrap.sh ← one-liner : télécharge + lance (repo public)
├── CLAUDE.md                    ← guide pour Claude Code (s'il pilote l'install)
├── 00-prerequis.md
├── 01-cli-tools.md
├── 02-github.md
├── 03-api-keys.md
├── 04-claude-code.md
├── 05-mcp.md
├── 06-creer-la-plateforme.md
├── 07-claude-architecture.md
├── scripts/
│   ├── install-windows.ps1      ← installe tous les CLI (Windows)
│   ├── install-mac.sh           ← installe tous les CLI (macOS / Linux)
│   └── verify.ps1 / verify.sh   ← vérifie que tout est bien installé
└── templates/
    ├── env.local.example        ← toutes les variables d'env (vides, à remplir)
    ├── mcp.json.example         ← config MCP projet prête à copier
    ├── settings.json.example    ← paramètres Claude Code (permissions + bypass)
    └── CLAUDE.md.example         ← mémoire projet à adapter
```

---

## 🧱 La stack visée (et pourquoi)

| Brique | Outil | Rôle |
|--------|-------|------|
| Framework | **Next.js 15 + React 19 + TypeScript** | Front + back (API routes) dans un seul repo |
| Style | **Tailwind 4** | Design system rapide, mobile-first |
| Base de données + Auth | **Supabase** (Postgres) | DB, Auth (Google/GitHub OAuth), Row-Level Security, Storage |
| Paiements | **Stripe** | Abonnements + Connect (multi-vendeurs) |
| Emails | **Resend** | Emails transactionnels |
| Hébergement | **Vercel** | Deploy auto à chaque push, previews par branche |
| Versioning | **GitHub** | Code, branches, CI |
| Copilote | **Claude Code + MCP** | Construit, débugge, déploie pour toi |

> Tout est **CLI/SDK-first** : on évite les manips manuelles dans des dashboards quand un CLI existe.

---

## ⏱️ Temps estimé

- Installation des CLI : **~15 min** (script auto) ou ~30 min à la main
- GitHub + SSH : **~10 min**
- Récupération des clés API : **~30–45 min** (créer les comptes Supabase/Vercel/Stripe/Resend)
- Claude Code + MCP : **~15 min**
- **Total : ~1h30** pour un environnement complet, prêt à construire.

---

## ▶️ Démarrage — pour un débutant (le plus simple)

**Le principe : tu n'installes que Claude. Ensuite, c'est lui qui installe le reste et te guide.**

1. **Installe l'assistant Claude** (dans le terminal) :
   ```powershell
   irm https://claude.ai/install.ps1 | iex          # Windows
   ```
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash    # macOS / Linux
   ```
2. **Lance-le** (`claude`), connecte-toi, puis **colle-lui ce message** :
   > Lis `https://github.com/Dimka06000/freelaunch-setup-kit`, installe tous les outils dont j'ai
   > besoin, guide-moi pour mes comptes et mes clés, et aide-moi à créer ma plateforme. Je ne suis
   > pas développeur, parle-moi en français.
3. **Tu réponds juste à ses questions** (autoriser une page, coller une clé, dire oui). Il fait le reste.

La page guide [index.html](./index.html) présente ces 2 étapes joliment, avec boutons « Copier ».

### Voir la page guide
**Windows** : double-clique `start.cmd` · **Mac/Linux** : `bash ./start.sh` (ou `node serve.js`)
→ s'ouvre sur `http://localhost:4321`.

### Pour les devs / les pressés : tout installer d'un coup
Le one-liner [bootstrap](./bootstrap.ps1) télécharge le kit, **installe tous les CLI** puis ouvre le guide :
```powershell
irm https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/bootstrap.ps1 | iex     # Windows
```
```bash
curl -fsSL https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/bootstrap.sh | bash   # macOS / Linux
```

Bonne installe 🚀
