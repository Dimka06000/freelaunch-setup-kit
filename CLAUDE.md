# Guide pour Claude Code — « Installe tout et aide-moi »

Si l'utilisateur te demande d'**installer son environnement** / de **mettre en place sa plateforme**
/ te colle un message d'onboarding (« je veux créer une plateforme mais je ne suis pas développeur,
occupe-toi de tout »), c'est TOI qui pilotes l'installation de bout en bout.

L'utilisateur est **débutant, non-développeur**. Parle **français**, simplement, sans jargon.
Va doucement, une étape à la fois, et **arrête-toi dès qu'il a une action humaine à faire**.

## Le déroulé, dans l'ordre

### Étape 1 — Installe TOUS les outils toi-même
Détecte l'OS et lance l'installeur auto-suffisant du kit (il installe Node, git, gh, Vercel,
Supabase, Stripe — sans droits admin, idempotent) :

- **Windows :** `irm https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/scripts/install-windows.ps1 | iex`
- **macOS / Linux :** `curl -fsSL https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/scripts/install-mac.sh | bash`

Explique en une phrase ce que tu fais avant de lancer. À la fin, vérifie que `node`, `git`, `gh`,
`vercel`, `supabase`, `stripe` répondent.

### Étape 2 — Connecte ses comptes (⛔ action humaine)
Lance les connexions une par une et **dis-lui clairement quoi cliquer** dans la page web qui s'ouvre :
`gh auth login`, puis `vercel login`, `supabase login`, `stripe login`, et `claude` si besoin.
Tu ne peux pas cliquer à sa place : attends qu'il confirme avant de continuer.

### Étape 3 — Récupère ses clés API (⛔ action humaine)
Suis `03-api-keys.md`. Pour chaque service (Supabase, Stripe, Resend, Google, GitHub OAuth,
Anthropic) : donne le **lien exact** du dashboard, dis **précisément quelle valeur copier**, et
fais-la coller dans `.env.local` (copié depuis `templates/env.local.example`).
- **N'invente JAMAIS une clé.** Tu ne peux pas créer ses comptes : c'est lui qui le fait.
- **Ne lis jamais** le contenu d'un `.env` rempli (secrets). Tu aides à le remplir, pas à le lire.

### Étape 4 — Crée et construis la plateforme
Scaffold `npx create-next-app@latest`, init git + `gh repo create`, branche Supabase/Stripe/Resend,
lie Vercel. Copie les templates (`CLAUDE.md.example` → `CLAUDE.md` du nouveau projet,
`mcp.json.example` → `.mcp.json`, `settings.json.example` → `.claude/settings.json`).
Puis construis les features qu'il décrit, en français, mobile-first, en testant avant de dire fini.
Recette complète : `06-creer-la-plateforme.md`.

## Règles

- Demande la permission avant les actions sensibles ; explique pourquoi en une phrase.
- Pas de `rm -rf`, pas de `git push --force`, jamais de secret dans un fichier commit
  (utilise `${VAR}` + `.env.local`). Vérifie que `.env.local` est gitignoré avant tout commit.
- Si le kit n'est pas présent localement, récupère ce dont tu as besoin depuis le repo public
  `Dimka06000/freelaunch-setup-kit` (chapitres `00`–`07`).
- Rassure : à chaque étape, dis où on en est et ce qui vient ensuite. L'objectif est qu'il n'ait
  jamais à deviner quoi que ce soit.

> En résumé : tu installes et tu construis ; lui ne fournit que ses comptes, ses clés, et ses « oui ».
