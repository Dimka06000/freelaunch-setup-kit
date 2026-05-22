# Setup Kit — bootstrap one-liner (Windows)
# Telecharge le kit depuis GitHub, puis lance le guide (dev serveur + navigateur).
# Usage (une seule commande) :
#   irm https://raw.githubusercontent.com/<USER>/<REPO>/main/bootstrap.ps1 | iex

$ErrorActionPreference = "Stop"

$repo   = "Dimka06000/freelaunch-setup-kit"   # <-- a adapter au repo public reel
$branch = "main"
$dest   = Join-Path $HOME "setup-kit"

Write-Host "`n  Telechargement du Setup Kit ($repo)..." -ForegroundColor Cyan
$tmpZip = Join-Path $env:TEMP "setup-kit.zip"
$tmpDir = Join-Path $env:TEMP ("skb_" + [guid]::NewGuid().ToString("N"))

Invoke-WebRequest "https://github.com/$repo/archive/refs/heads/$branch.zip" -OutFile $tmpZip
Expand-Archive $tmpZip -DestinationPath $tmpDir -Force
$inner = Get-ChildItem $tmpDir | Select-Object -First 1   # <repo>-<branch>

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Move-Item $inner.FullName $dest
Set-Location $dest

Write-Host "  Kit installe dans : $dest" -ForegroundColor Green
if (Get-Command node -ErrorAction SilentlyContinue) {
  node "$dest\serve.js"
} else {
  Write-Host "  Node pas encore installe -> ouverture du guide (mode fichier)." -ForegroundColor Yellow
  Start-Process (Join-Path $dest "index.html")
}
