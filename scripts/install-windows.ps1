# Setup Kit — Installation des CLI (Windows / PowerShell)
# Usage : ./scripts/install-windows.ps1
# Idempotent : ne reinstalle pas ce qui est deja present.

$ErrorActionPreference = "Stop"
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }

Step "Verification de Node.js"
if (Have node) {
  Write-Host "Node: $(node -v)" -ForegroundColor Green
} else {
  Write-Host "Installation de Node.js LTS..." -ForegroundColor Yellow
  winget install --silent --accept-source-agreements --accept-package-agreements OpenJS.NodeJS.LTS
  Write-Host "Node installe. FERME et ROUVRE le terminal, puis relance ce script." -ForegroundColor Yellow
  exit 0
}

Step "Git"
if (Have git) { Write-Host "git: $(git --version)" -ForegroundColor Green }
else { winget install --silent --accept-source-agreements --accept-package-agreements Git.Git }

Step "GitHub CLI (gh)"
if (Have gh) { Write-Host "gh: $(gh --version | Select-Object -First 1)" -ForegroundColor Green }
else { winget install --silent --accept-source-agreements --accept-package-agreements GitHub.cli }

Step "Scoop (pour Supabase + Stripe)"
if (Have scoop) {
  Write-Host "scoop deja installe" -ForegroundColor Green
} else {
  Write-Host "Installation de Scoop..." -ForegroundColor Yellow
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

Step "Supabase CLI"
if (Have supabase) { Write-Host "supabase: $(supabase --version)" -ForegroundColor Green }
else { scoop install supabase }

Step "Stripe CLI"
if (Have stripe) { Write-Host "stripe: $(stripe --version)" -ForegroundColor Green }
else { scoop install stripe }

Step "Vercel CLI (via npm)"
if (Have vercel) { Write-Host "vercel: $(vercel --version)" -ForegroundColor Green }
else { npm install -g vercel }

Step "Claude Code (installeur natif)"
if (Have claude) { Write-Host "claude: deja installe" -ForegroundColor Green }
else { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression }

Write-Host "`nTermine. FERME/ROUVRE le terminal puis lance ./scripts/verify.ps1" -ForegroundColor Green
Write-Host "Prochaines etapes :" -ForegroundColor Cyan
Write-Host "  1) gh auth login          (chapitre 02-github)"
Write-Host "  2) vercel login / supabase login / stripe login"
Write-Host "  3) claude                 (chapitre 04-claude-code)"
