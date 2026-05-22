# 6 — Créer la plateforme de A à Z

Tout est installé et connecté. Voici la **recette complète** pour passer d'un dossier vide à une
plateforme déployée — puis laisser Claude Code construire les features.

---

## Étape 1 — Scaffolder l'app Next.js

```bash
npx create-next-app@latest mon-projet --typescript --tailwind --app --eslint --src-dir
cd mon-projet
```

## Étape 2 — Repo GitHub (cf. chapitre 2)

```bash
git add -A && git commit -m "chore: initial Next.js scaffold"
gh repo create mon-projet --private --source=. --remote=origin --push
```

## Étape 3 — Supabase (base + auth)

```bash
# Lier le projet créé sur supabase.com
supabase login                       # ou exporte SUPABASE_ACCESS_TOKEN
supabase link --project-ref <ref>

# Démarrer une stack locale (optionnel, pour dev offline)
supabase init

# Installer le SDK
npm install @supabase/supabase-js @supabase/ssr
```

Crée tes tables via des **migrations** versionnées (jamais des clics dans le dashboard) :
```bash
supabase migration new create_profiles
# édite supabase/migrations/<timestamp>_create_profiles.sql (avec RLS dès le départ !)
supabase db push                      # applique en prod
```

> 🔒 **Active la Row-Level Security dès la première table.** Sur une plateforme multi-utilisateurs,
> RLS = la barrière qui empêche un user de lire les données d'un autre. Demande à Claude de l'écrire.

## Étape 4 — Brancher les providers d'auth

Dans **Supabase → Authentication → Providers** : active **Google** et **GitHub**, colle les
`CLIENT_ID`/`CLIENT_SECRET` récupérés au chapitre 3. Redirect URL = `https://<ref>.supabase.co/auth/v1/callback`.

## Étape 5 — Stripe

```bash
npm install stripe @stripe/stripe-js
# Crée tes produits/prix en CLI (ou dashboard) :
stripe products create --name "Pro"
stripe prices create --product <prod_id> --unit-amount 2500 --currency eur
# Webhook en local pendant le dev :
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

## Étape 6 — Resend (emails)

```bash
npm install resend
```
Vérifie ton domaine dans Resend (DNS), puis envoie depuis ton code via `RESEND_API_KEY`.

## Étape 7 — Variables d'environnement

```bash
cp setup-kit/templates/env.local.example .env.local   # remplis avec tes clés du chapitre 3
```

## Étape 8 — Vercel (déploiement)

```bash
vercel login
vercel link                          # lie le dossier au projet Vercel
# Pousser les variables d'env vers Vercel (Production + Preview + Development) :
vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add SUPABASE_SERVICE_ROLE_KEY
# … (ou importe-les en masse depuis le dashboard)
vercel env pull .env.local           # récupère les vars Vercel en local
```
> ⚠️ Windows + erreur de certificat : préfixe par `$env:NODE_OPTIONS="--use-system-ca";`
> ⚠️ Pour `vercel env add` avec valeur via pipe, utilise `printf` (pas `echo`, qui ajoute un `\n`).

À partir de là : **chaque `git push` déclenche un déploiement Vercel** ; chaque branche a une URL de preview.

## Étape 9 — Config Claude Code du projet

```bash
cp setup-kit/templates/CLAUDE.md.example   ./CLAUDE.md
cp setup-kit/templates/mcp.json.example    ./.mcp.json
mkdir -p .claude && cp setup-kit/templates/settings.json.example .claude/settings.json
```
Adapte `CLAUDE.md` (nom du projet, stack, règles), puis ouvre Claude Code dans le dossier.

---

## Étape 10 — Laisser Claude Code construire 🚀

C'est là que tout converge. Lance `claude` dans le projet et **décris la feature** — Claude lit ton
`CLAUDE.md`, interroge Supabase via MCP, teste l'UI via Playwright, et déploie via Vercel.

Exemples de prompts qui marchent bien :

```text
> Lis CLAUDE.md. On construit une plateforme SaaS multi-tenant. Commence par l'auth :
  login Google + GitHub via Supabase, page /login en français, design Tailwind mobile-first.
  Écris la migration SQL avec RLS, le code, et teste le flow avec Playwright avant de me dire que c'est fini.
```
```text
> Ajoute Stripe Checkout pour un abonnement à 25€. Crée la route API webhook, vérifie la signature,
  mets à jour la table subscriptions. Montre-moi le diff avant de commit.
```
```text
> Déploie sur Vercel et donne-moi l'URL de preview. Vérifie que la home répond en 200.
```

### Le bon réflexe de workflow
1. **Plan mode** (`Shift+Tab`) pour les grosses features : Claude propose, tu valides.
2. **`acceptEdits`** au quotidien pour la fluidité (cf. [04-claude-code.md](./04-claude-code.md)).
3. Branche dédiée → commits granulaires → `gh pr create` → merge.
4. Teste **sur mobile** après chaque changement d'UI (375px d'abord).
5. Si ça casse en prod : fix dans le commit suivant, ne reviens pas en arrière.

---

## 🎯 Récap du flux complet

```
Idée
  │
  ├─ Claude Code (plan mode) → propose l'archi
  ├─ MCP Supabase → migration + RLS
  ├─ MCP Context7 → API à jour des libs
  ├─ code + MCP Playwright → test e2e
  ├─ git push → MCP Vercel → preview URL
  └─ merge main → déploiement prod
```

Tu as maintenant un environnement complet pour sortir une plateforme **de A à Z**, vite et proprement. 🚀

➡️ Templates à copier : [templates/](./templates/) · Retour au [README](./README.md)
