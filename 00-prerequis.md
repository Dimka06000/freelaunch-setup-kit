# 0 — Prérequis

Avant d'installer les CLI, on prépare la base : un **terminal**, un **gestionnaire de paquets**,
et **Node.js**.

---

## 🪟 Windows

### a) Terminal
Utilise **Windows Terminal** + **PowerShell** (déjà installés sur Windows 11).
Ouvre-le via `Win` → tape « Terminal ».

### b) Gestionnaire de paquets
Windows a `winget` en natif (rien à installer). On ajoute aussi **Scoop** pour les CLI
qui ne sont pas sur winget (Supabase, Stripe) :

```powershell
# Scoop (installe des CLI sans droits admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

### c) Node.js (LTS)
```powershell
winget install OpenJS.NodeJS.LTS
```
> Ferme/rouvre le terminal après, puis vérifie : `node -v` (≥ 20) et `npm -v`.

---

## 🍎 macOS

### a) Terminal
Le **Terminal** macOS suffit. (Optionnel : [iTerm2](https://iterm2.com/).)

### b) Homebrew (gestionnaire de paquets)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Suis l'instruction finale pour ajouter `brew` au PATH (`eval "$(/opt/homebrew/bin/brew shellenv)"`).

### c) Node.js (LTS)
```bash
brew install node
```
> Vérifie : `node -v` (≥ 20) et `npm -v`.

---

## 🐧 Linux (Ubuntu/Debian)

```bash
# Node via nvm (recommandé, évite les conflits de version)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# rouvre le terminal puis :
nvm install --lts
```

---

## ✅ Pourquoi Node.js d'abord ?

Beaucoup de CLI s'installent via `npm` (Vercel, Claude Code en fallback, etc.) et le projet
lui-même tourne sur Node. C'est le socle.

**Versions cibles :**
- Node.js **≥ 20** (idéalement la LTS courante)
- npm **≥ 10**

Une fois Node OK → passe à [01-cli-tools.md](./01-cli-tools.md).
