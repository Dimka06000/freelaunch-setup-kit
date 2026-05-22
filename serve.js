#!/usr/bin/env node
// Setup Kit — petit dev serveur (zero dependance, Node natif).
// Sert index.html + ouvre le navigateur automatiquement.
// Usage : node serve.js   (ou via start.cmd / start.sh)

const http = require("http");
const fs = require("fs");
const path = require("path");
const { execFile } = require("child_process");

const ROOT = __dirname;
const START_PORT = 4321;

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".md": "text/markdown; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".ico": "image/x-icon",
  ".txt": "text/plain; charset=utf-8",
};

const server = http.createServer((req, res) => {
  let urlPath = decodeURIComponent(req.url.split("?")[0]);
  if (urlPath === "/" || urlPath === "") urlPath = "/index.html";

  // Securite : on reste a l'interieur du dossier du kit.
  const filePath = path.join(ROOT, path.normalize(urlPath));
  if (!filePath.startsWith(ROOT)) {
    res.writeHead(403).end("Forbidden");
    return;
  }

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { "Content-Type": "text/html; charset=utf-8" });
      res.end("<h1>404</h1><p>Fichier introuvable. <a href='/'>Retour au guide</a></p>");
      return;
    }
    const ext = path.extname(filePath).toLowerCase();
    res.writeHead(200, { "Content-Type": MIME[ext] || "application/octet-stream" });
    res.end(data);
  });
});

// Ouvre le navigateur via execFile (pas de shell -> pas d'injection).
// L'URL est un localhost fixe, jamais une entree utilisateur.
function openBrowser(url) {
  const p = process.platform;
  if (p === "win32") execFile("cmd", ["/c", "start", "", url], () => {});
  else if (p === "darwin") execFile("open", [url], () => {});
  else execFile("xdg-open", [url], () => {});
}

function listen(port) {
  server.once("error", (e) => {
    if (e.code === "EADDRINUSE" && port < START_PORT + 20) {
      listen(port + 1); // port occupe -> on essaie le suivant
    } else {
      console.error("Erreur serveur:", e.message);
      process.exit(1);
    }
  });
  server.listen(port, () => {
    const url = `http://localhost:${port}`;
    console.log("\n  🚀 Setup Kit — guide ouvert sur " + url);
    console.log("  (Ctrl+C pour arreter)\n");
    openBrowser(url);
  });
}

listen(START_PORT);
