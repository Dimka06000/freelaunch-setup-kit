# 2 — Mettre GitHub en place

GitHub = ton coffre-fort de code + le déclencheur des déploiements Vercel.
On le configure proprement une bonne fois : **identité git, clé SSH, `gh` authentifié, premier repo.**

---

## a) Identité git (obligatoire avant le premier commit)

```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton-email@github.com"

# Confort
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input   # (Windows : true)
```

> Utilise **l'email de ton compte GitHub** (ou l'email no-reply GitHub) pour que les commits
> te soient bien attribués.

---

## b) Authentifier le GitHub CLI (`gh`)

C'est la façon la plus simple — `gh` configure **aussi le git credential helper** pour toi (HTTPS).

```bash
gh auth login
```

Réponds :
- **GitHub.com**
- **HTTPS** (le plus simple) ou SSH (voir ci-dessous)
- **Login with a web browser** → copie le code, valide dans le navigateur

Vérifie :
```bash
gh auth status
```

---

## c) Clé SSH (recommandé pour `git push` sans retaper de token)

### Générer la clé
```bash
ssh-keygen -t ed25519 -C "ton-email@github.com"
# Entrée pour le chemin par défaut, mets une passphrase si tu veux
```

### Démarrer l'agent + ajouter la clé

**macOS / Linux :**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**Windows (PowerShell admin une fois) :**
```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

### Ajouter la clé publique à GitHub (via `gh`, zéro copier-coller)
```bash
gh ssh-key add ~/.ssh/id_ed25519.pub --title "Mon PC"
```

### Tester
```bash
ssh -T git@github.com
# → "Hi <pseudo>! You've successfully authenticated…"
```

---

## d) Créer ton premier repo

Dans le dossier de ton projet :

```bash
# Repo privé créé sur GitHub + lié au dossier local + premier push
gh repo create mon-projet --private --source=. --remote=origin --push
```

Ou, si le repo local existe déjà :
```bash
git init
git add .
git commit -m "chore: initial commit"
gh repo create mon-projet --private --source=. --remote=origin --push
```

---

## e) Protéger les secrets : `.gitignore`

**Avant le premier commit**, assure-toi que les secrets ne partent JAMAIS sur GitHub :

```gitignore
# .gitignore — minimum vital
.env
.env.local
.env*.local
node_modules/
.next/
.vercel/
.DS_Store
```

> Next.js fournit déjà un bon `.gitignore` par défaut. Vérifie juste que `.env.local` y est.
> Si tu as commit un secret par erreur : **considère-le compromis**, révoque-le et régénère-le.

---

## f) Workflow de branches (bonne hygiène)

```bash
# Ne jamais bosser directement sur main pour une grosse feature
git checkout -b feature/ma-feature
# … commits …
git push -u origin feature/ma-feature
# Ouvrir la Pull Request
gh pr create --fill
```

> Tu peux aussi laisser Claude Code créer la branche, commit et la PR pour toi
> (voir [04-claude-code.md](./04-claude-code.md)).

---

## g) Connexion GitHub ↔ Vercel (déploiement auto)

Quand tu lieras le projet à Vercel (chapitre 6), Vercel se branche sur ton repo GitHub :
**chaque `git push` déclenche un déploiement**, et chaque branche obtient une **URL de preview**.
Rien à faire ici, juste savoir que GitHub est le déclencheur.

---

## ✅ Checklist GitHub

- [ ] `git config user.name` / `user.email` posés
- [ ] `gh auth status` → connecté
- [ ] Clé SSH générée + ajoutée (`ssh -T git@github.com` OK)
- [ ] `.gitignore` protège `.env.local`
- [ ] Premier repo créé et pushé

➡️ Ensuite : [03-api-keys.md](./03-api-keys.md)
