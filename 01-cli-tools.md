# 1 — Installer tous les CLI

Philosophie : **CLI/SDK-first**. On pilote tout (déploiement, base de données, paiements)
en ligne de commande plutôt que dans des dashboards. Voici la liste complète et comment l'installer.

---

## 🟢 Option rapide : le script auto

### Windows (PowerShell)
```powershell
cd setup-kit
./scripts/install-windows.ps1
```

### macOS / Linux
```bash
cd setup-kit
bash ./scripts/install-mac.sh
```

Le script installe : **git, GitHub CLI, Vercel CLI, Supabase CLI, Stripe CLI, Claude Code**
(+ vérifie Node). Ensuite, vérifie tout :

```powershell
./scripts/verify.ps1     # Windows
```
```bash
bash ./scripts/verify.sh # macOS / Linux
```

---

## 📦 La liste des CLI (et à quoi ils servent)

| CLI | Rôle | Vérifier |
|-----|------|----------|
| **node / npm** | Runtime + paquets | `node -v` |
| **git** | Versioning | `git --version` |
| **gh** (GitHub CLI) | Repos, PR, auth GitHub | `gh --version` |
| **vercel** | Déploiement + env vars | `vercel --version` |
| **supabase** | DB, migrations, types | `supabase --version` |
| **stripe** | Paiements + webhooks en local | `stripe --version` |
| **claude** (Claude Code) | Le copilote qui code | `claude --version` |

---

## 🔧 Installation manuelle (si tu ne veux pas le script)

### git
```powershell
winget install Git.Git          # Windows
```
```bash
brew install git                # macOS
sudo apt install git            # Linux
```

### GitHub CLI (`gh`)
```powershell
winget install GitHub.cli       # Windows
```
```bash
brew install gh                 # macOS
```

### Vercel CLI
```bash
npm install -g vercel
```
> ⚠️ Sur Windows, si tu vois une erreur de certificat (`FetchError ... certificate`),
> préfixe tes commandes Vercel : `$env:NODE_OPTIONS="--use-system-ca"; vercel ...`

### Supabase CLI
> ⚠️ Le `npm install -g supabase` **n'est plus supporté**. Utilise scoop/brew :
```powershell
scoop install supabase          # Windows (via scoop, voir 00-prerequis)
```
```bash
brew install supabase/tap/supabase   # macOS
```
> Fallback universel sans installer : `npx supabase <commande>`

### Stripe CLI
```powershell
scoop install stripe            # Windows
```
```bash
brew install stripe/stripe-cli/stripe   # macOS
```

### Claude Code
```powershell
irm https://claude.ai/install.ps1 | iex      # Windows (installeur natif, auto-update)
```
```bash
curl -fsSL https://claude.ai/install.sh | bash   # macOS / Linux
```
> Fallback npm (toutes plateformes) : `npm install -g @anthropic-ai/claude-code`
> Détails de prise en main → [04-claude-code.md](./04-claude-code.md)

---

## ✅ Vérification finale

```bash
node -v && git --version && gh --version && vercel --version && supabase --version && stripe --version && claude --version
```

Toutes les lignes répondent ? ✅ Passe à [02-github.md](./02-github.md).
