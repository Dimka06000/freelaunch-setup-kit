# Setup Kit — Installation AUTOMATIQUE de tous les CLI (Windows / PowerShell)
# Tout via Scoop (aucun admin / aucun UAC) : git, Node, gh, supabase, stripe, vercel, Claude Code.
# Idempotent : ne reinstalle pas ce qui est deja la. Rafraichit le PATH en live (pas besoin de rouvrir le terminal).

$ErrorActionPreference = "Continue"
function Have($c){ [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Step($m){ Write-Host "`n=== $m ===" -ForegroundColor Cyan }
function RefreshPath {
  $parts = @(
    [Environment]::GetEnvironmentVariable("Path","Machine"),
    [Environment]::GetEnvironmentVariable("Path","User"),
    (Join-Path $HOME "scoop\shims"),
    (Join-Path $env:APPDATA "npm")
  )
  $env:Path = ($parts | Where-Object { $_ }) -join ';'
}

Step "Scoop (gestionnaire de paquets, sans admin)"
if (Have scoop) {
  Write-Host "scoop deja installe" -ForegroundColor Green
} else {
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
  RefreshPath
}

Step "git, Node.js (LTS), GitHub CLI"
if (-not (Have git))  { scoop install git }
RefreshPath
if (-not (Have node)) { scoop install nodejs-lts }
if (-not (Have gh))   { scoop install gh }
RefreshPath

Step "Supabase CLI"
if (-not (Have supabase)) {
  scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
  scoop install supabase
}
RefreshPath

Step "Stripe CLI"
if (-not (Have stripe)) {
  scoop bucket add stripe https://github.com/stripe/scoop-stripe-cli.git
  scoop install stripe
}
RefreshPath

Step "Vercel CLI (via npm)"
if (-not (Have vercel)) { npm install -g vercel }
RefreshPath

Step "Claude Code (installeur natif, auto-update)"
if (-not (Have claude)) { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression }
RefreshPath

Step "Verification"
foreach ($t in "node","git","gh","vercel","supabase","stripe","claude") {
  if (Have $t) { Write-Host ("[OK]   {0}" -f $t) -ForegroundColor Green }
  else { Write-Host ("[A REVOIR] {0} (rouvre le terminal et relance si besoin)" -f $t) -ForegroundColor Yellow }
}
Write-Host "`nOutils installes. Il reste les etapes qui demandent TES comptes :" -ForegroundColor Cyan
Write-Host "  - connexions : gh auth login / vercel login / supabase login / stripe login / claude"
Write-Host "  - cles API : voir le guide (chapitre 03)."
