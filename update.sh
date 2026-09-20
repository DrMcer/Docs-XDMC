#!/usr/bin/env bash
set -euo pipefail
REPO=/srv/xducraft-docs
cd "$REPO"
git fetch --depth 1 origin main >/dev/null 2>&1 || { echo "$(date '+%F %T') fetch failed"; exit 1; }
NEW=$(git rev-parse FETCH_HEAD)
OLD=$(git rev-parse HEAD 2>/dev/null || echo none)
if [ "$NEW" = "$OLD" ]; then echo "$(date '+%F %T') up-to-date ($NEW)"; exit 0; fi
echo "$(date '+%F %T') updating $OLD -> $NEW"
git reset --hard "$NEW"
HASH=$(md5sum package-lock.json | awk '{print $1}')
NEED_INSTALL=0
if [ ! -d node_modules ] || [ ! -f .lockhash ] || [ "$HASH" != "$(cat .lockhash 2>/dev/null)" ]; then NEED_INSTALL=1; fi
docker rm -f xduco-docs-sync >/dev/null 2>&1 || true
if [ "$NEED_INSTALL" = "1" ]; then
  CMD="apk add --no-cache libc6-compat && npm config set registry https://registry.npmmirror.com && npm ci && echo $HASH > .lockhash && npm run build"
else
  CMD="apk add --no-cache libc6-compat && npm run build"
fi
docker run --rm --name xduco-docs-sync --memory=1000m --memory-swap=1600m --cpus=1.5 \
  -v "$REPO":/app -w /app -e NODE_OPTIONS=--max-old-space-size=768 \
  node:22-alpine sh -c "$CMD"
mkdir -p /www/wwwroot/docs.xducraft.cn
rsync -a --delete "$REPO/dist/" /www/wwwroot/docs.xducraft.cn/ 2>/dev/null || cp -rf "$REPO/dist/." /www/wwwroot/docs.xducraft.cn/
chown -R www:www /www/wwwroot/docs.xducraft.cn 2>/dev/null || true
echo "$(date '+%F %T') rebuilt OK"
