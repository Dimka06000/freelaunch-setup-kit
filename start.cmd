@echo off
REM Setup Kit — lance le guide interactif (Windows). Double-clique ce fichier.
cd /d "%~dp0"
where node >nul 2>nul
if %errorlevel%==0 (
  node "%~dp0serve.js"
) else (
  echo.
  echo Node.js n'est pas encore installe.
  echo Ouverture du guide en mode fichier ^(les boutons "Copier" marchent mieux avec le serveur^).
  echo Installe Node ^(chapitre 0 du guide^) puis relance ce fichier pour le dev serveur.
  echo.
  start "" "%~dp0index.html"
  pause
)
