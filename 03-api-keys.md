# 3 — Récupérer les clés API

Toutes les clés vont dans un fichier **`.env.local`** à la racine du projet (gitignored, jamais commit).
Copie le template puis remplis au fur et à mesure :

```bash
cp setup-kit/templates/env.local.example .env.local
```

> 🔒 **Règle d'or** : `.env.local` ne part JAMAIS sur GitHub. En prod, ces variables sont
> stockées dans Vercel (chapitre 6), pas dans le repo.

Légende : 🟥 = indispensable pour une plateforme · 🟦 = optionnel / créatif.

---

## 🟥 Supabase — base de données + auth (le cœur)

1. Crée un compte → [supabase.com](https://supabase.com) → **New project**.
2. Note le mot de passe DB que tu choisis → `SUPABASE_DB_PASSWORD`.
3. **Project Settings → API** :
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` → `NEXT_PUBLIC_SUPABASE_ANON_KEY` (ou la nouvelle `publishable` → `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`)
   - `service_role` (secret !) → `SUPABASE_SERVICE_ROLE_KEY` (ou `secret` → `SUPABASE_SECRET_KEY`)
4. Le **ref** du projet (dans l'URL `https://<ref>.supabase.co`) → `SUPABASE_PROJECT_REF`.
5. **Account → Access Tokens** → [supabase.com/dashboard/account/tokens](https://supabase.com/dashboard/account/tokens)
   → génère un token → `SUPABASE_ACCESS_TOKEN` (utilisé par le CLI **et** le MCP Supabase).

> ⚠️ La `service_role` / `secret` bypasse la Row-Level Security. **Serveur uniquement**, jamais côté client.

---

## 🟥 Stripe — paiements

1. [dashboard.stripe.com](https://dashboard.stripe.com) → reste en **mode Test** (toggle en haut).
2. **Developers → API keys** :
   - `Publishable key` (`pk_test_…`) → `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
   - `Secret key` (`sk_test_…`) → `STRIPE_SECRET_KEY`
3. **Webhook** (pour confirmer les paiements) : en local, le CLI te donne le secret :
   ```bash
   stripe login
   stripe listen --forward-to localhost:3000/api/stripe/webhook
   # → affiche whsec_… → STRIPE_WEBHOOK_SECRET
   ```

> Passe en clés `live` seulement le jour du lancement réel.

---

## 🟥 Resend — emails transactionnels

1. [resend.com](https://resend.com) → **API Keys** → **Create** → `re_…` → `RESEND_API_KEY`.
2. **Domains** → ajoute ton domaine → pose les enregistrements DNS (SPF/DKIM) → vérifie.
   (En dev tu peux envoyer depuis `onboarding@resend.dev` sans domaine.)

---

## 🟥 Google Cloud — OAuth + Maps

Un seul projet Google Cloud sert pour le **login Google** et l'**API Maps**.

1. [console.cloud.google.com](https://console.cloud.google.com) → crée un projet.
2. **APIs & Services → Credentials → Create credentials → OAuth client ID** (type *Web*) :
   - Authorized redirect URI : `https://<ref>.supabase.co/auth/v1/callback` (l'URL **Supabase**, pas ton app)
   - → `GOOGLE_CLIENT_ID` + `GOOGLE_CLIENT_SECRET`
   - Colle ces deux valeurs aussi dans **Supabase → Authentication → Providers → Google**.
3. **Maps** : active *Maps JavaScript API* + *Places* → crée une **API key** → `GOOGLE_MAPS_API_KEY`
   (et `NEXT_PUBLIC_GOOGLE_MAPS_EMBED_KEY` si tu utilises l'embed). Restreins la clé par domaine.

---

## 🟥 GitHub OAuth — login « Se connecter avec GitHub »

1. GitHub → **Settings → Developer settings → OAuth Apps → New OAuth App**.
2. Authorization callback URL : `https://<ref>.supabase.co/auth/v1/callback`.
3. → `GITHUB_CLIENT_ID` + `GITHUB_CLIENT_SECRET`, à coller aussi dans Supabase → Providers → GitHub.

> ⚠️ Ne pas confondre avec ton **`gh auth login`** du chapitre 2 (ça, c'est ton accès dev à GitHub).
> Ici c'est l'app OAuth qui permet à **tes utilisateurs** de se connecter.

---

## 🟥 Anthropic — clé API (features IA + Claude Code par API)

1. [console.anthropic.com](https://console.anthropic.com) → **API Keys** → `sk-ant-…` → `ANTHROPIC_API_KEY`.

> Pour **Claude Code lui-même**, tu peux te connecter avec ton abonnement Claude
> (Pro/Max) sans clé API — voir [04-claude-code.md](./04-claude-code.md). La clé `ANTHROPIC_API_KEY`
> sert surtout aux **features IA de ton app** (SDK `@anthropic-ai/sdk`).

---

## 🟥 Secrets que tu génères toi-même

Pas de service externe — ce sont des secrets aléatoires pour ton app :

```bash
# CRON_SECRET (protège les routes cron) + CALENDAR_TOKEN_ENCRYPTION_KEY (chiffre les tokens OAuth)
openssl rand -hex 32
```
(Windows sans openssl : `[guid]::NewGuid().ToString("N") + [guid]::NewGuid().ToString("N")` dans PowerShell.)

→ `CRON_SECRET`, `CALENDAR_TOKEN_ENCRYPTION_KEY`

---

## 🟥 Vercel — déploiement (pas de clé à copier)

Vercel s'authentifie via le CLI (`vercel login`). En local, `vercel env pull` injecte
automatiquement les variables (dont `VERCEL_OIDC_TOKEN`). Détails au chapitre 6.

---

## 🟦 Optionnel — IA générative & data (selon ton produit)

| Service | Variable | Où | Pour quoi |
|---------|----------|-----|-----------|
| OpenAI | `OPENAI_API_KEY` | [platform.openai.com](https://platform.openai.com) | LLM alternatif, embeddings |
| ElevenLabs | `ELEVENLABS_API_KEY` | [elevenlabs.io](https://elevenlabs.io) | Voix / TTS |
| Runway | `RUNWAY_API_KEY` | [dev.runwayml.com](https://dev.runwayml.com) | Vidéo générative |
| Luma Labs | `LUMALABS_API_KEY` | [lumalabs.ai](https://lumalabs.ai) | Image (Photon) + vidéo (Ray) |
| Perplexity | `PERPLEXITY_API_KEY` | [perplexity.ai](https://www.perplexity.ai) | Recherche sourcée |
| xAI (Grok) | `XAI_API_KEY` | [console.x.ai](https://console.x.ai) | LLM Grok |
| Twitter/X | `TWITTER_BEARER_TOKEN` | [developer.x.com](https://developer.x.com) | Lecture de posts |
| Adzuna | `ADZUNA_APP_ID` / `ADZUNA_APP_KEY` | [developer.adzuna.com](https://developer.adzuna.com) | Offres d'emploi |

---

## ✅ Checklist clés

- [ ] Supabase : URL + anon + service_role + ref + access token + db password
- [ ] Stripe : publishable + secret (+ webhook secret en local)
- [ ] Resend : API key (+ domaine vérifié)
- [ ] Google : OAuth client + Maps key (collés dans Supabase)
- [ ] GitHub OAuth : client id/secret (collés dans Supabase)
- [ ] Anthropic : API key
- [ ] Secrets générés : CRON_SECRET, CALENDAR_TOKEN_ENCRYPTION_KEY
- [ ] `.env.local` rempli, **pas commit**

➡️ Ensuite : [04-claude-code.md](./04-claude-code.md)
