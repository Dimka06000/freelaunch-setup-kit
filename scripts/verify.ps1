# Setup Kit — Verification (Windows)
# Usage : ./scripts/verify.ps1

function Check($name, $cmd) {
  $exists = [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
  if ($exists) {
    $ver = & $cmd --version 2>$null | Select-Object -First 1
    Write-Host ("[OK]   {0,-12} {1}" -f $name, $ver) -ForegroundColor Green
  } else {
    Write-Host ("[MANQ] {0,-12} introuvable" -f $name) -ForegroundColor Red
  }
}

Write-Host "`n--- Verification de l'environnement ---`n" -ForegroundColor Cyan
Check "node"     "node"
Check "npm"      "npm"
Check "git"      "git"
Check "gh"       "gh"
Check "vercel"   "vercel"
Check "supabase" "supabase"
Check "stripe"   "stripe"
Check "claude"   "claude"
Write-Host "`nTout en vert ? Passe a 02-github.md`n" -ForegroundColor Cyan
