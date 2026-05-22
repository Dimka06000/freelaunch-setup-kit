# Setup Kit — bootstrap one-liner (Windows)
# UNE commande qui : telecharge le kit -> INSTALLE TOUS LES CLI -> ouvre le guide pour la suite.
# Usage :
#   irm https://raw.githubusercontent.com/Dimka06000/freelaunch-setup-kit/main/bootstrap.ps1 | iex

$ErrorActionPreference = "Stop"

$repo   = "Dimka06000/freelaunch-setup-kit"
$branch = "main"
$dest   = Join-Path $HOME "setup-kit"

Write-Host "`n  [1/3] Telechargement du Setup Kit ($repo)..." -ForegroundColor Cyan
$tmpZip = Join-Path $env:TEMP "setup-kit.zip"
$tmpDir = Join-Path $env:TEMP ("skb_" + [guid]::NewGuid().ToString("N"))
Invoke-WebRequest "https://github.com/$repo/archive/refs/heads/$branch.zip" -OutFile $tmpZip
Expand-Archive $tmpZip -DestinationPath $tmpDir -Force
$inner = Get-ChildItem $tmpDir | Select-Object -First 1
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Move-Item $inner.FullName $dest
Set-Location $dest

Write-Host "`n  [2/3] Installation de tous les outils (quelques minutes, sans admin)..." -ForegroundColor Cyan
& "$dest\scripts\install-windows.ps1"

# Rafraichit le PATH pour que node soit dispo dans cette session
$env:Path = @(
  [Environment]::GetEnvironmentVariable("Path","Machine"),
  [Environment]::GetEnvironmentVariable("Path","User"),
  (Join-Path $HOME "scoop\shims"),
  (Join-Path $env:APPDATA "npm")
) -join ';'

Write-Host "`n  [3/3] Ouverture du guide (connexions + cles API)..." -ForegroundColor Cyan
if (Get-Command node -ErrorAction SilentlyContinue) { node "$dest\serve.js" }
else { Start-Process (Join-Path $dest "index.html") }
