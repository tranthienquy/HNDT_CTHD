#!/usr/bin/env bash
# One-command deploy: copies the latest content into cf-pages-deploy/ and
# pushes it to Cloudflare. Run from anywhere: ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

# Pick up a saved token from .env (git-ignored, never committed) if present.
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

echo "==> Copying latest files into cf-pages-deploy/"
cp "HNDT 2026 - ban chia se.dc.html" cf-pages-deploy/index.html
cp -r media/. cf-pages-deploy/media/
cp -r slides/. cf-pages-deploy/slides/
cp support.js deck-stage.js cf-pages-deploy/

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  read -r -s -p "Cloudflare API token: " CLOUDFLARE_API_TOKEN
  echo
  export CLOUDFLARE_API_TOKEN
fi

echo "==> Deploying to Cloudflare"
npx wrangler pages deploy cf-pages-deploy --project-name=hndt-2026
