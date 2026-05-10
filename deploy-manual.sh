#!/usr/bin/env bash
# Manual one-shot deploy to GoDaddy via FTP using lftp.
#
# Use this for the FIRST upload (before GitHub Action is wired) or when
# you just want to push from your laptop without a git push.
#
# Setup once:
#   brew install lftp
#
# Run:
#   FTP_HOST=ftp.tomstoursusa.com FTP_USER=xxx FTP_PASSWORD=xxx FTP_REMOTE=/public_html/ ./deploy-manual.sh
#
# What it does:
#   - Mirrors the current directory to the remote
#   - Excludes git, github, archive, lonely, internal docs (CLAUDE.md, README.md)
#   - Uses parallel transfer for speed
#   - Continues incremental sync on re-run (only changed files re-upload)

set -euo pipefail

: "${FTP_HOST:?Set FTP_HOST (e.g. ftp.tomstoursusa.com)}"
: "${FTP_USER:?Set FTP_USER}"
: "${FTP_PASSWORD:?Set FTP_PASSWORD}"
: "${FTP_REMOTE:=/public_html/}"

cd "$(dirname "$0")"

echo "Deploying to ftp://${FTP_USER}@${FTP_HOST}${FTP_REMOTE} ..."

lftp -e "
set ssl:verify-certificate no;
set ftp:ssl-allow yes;
set ftp:ssl-protect-data yes;
set net:max-retries 3;
set net:reconnect-interval-base 5;
mirror --reverse \
  --delete \
  --verbose \
  --parallel=4 \
  --exclude-glob .git/ \
  --exclude-glob .git/* \
  --exclude-glob .github/ \
  --exclude-glob .github/* \
  --exclude-glob .claude/ \
  --exclude-glob .claude/* \
  --exclude-glob _archive_atlas/ \
  --exclude-glob _archive_atlas/* \
  --exclude-glob lonely/ \
  --exclude-glob lonely/* \
  --exclude-glob node_modules/ \
  --exclude-glob node_modules/* \
  --exclude-glob .DS_Store \
  --exclude-glob CLAUDE.md \
  --exclude-glob README.md \
  --exclude-glob .gitignore \
  --exclude-glob deploy-manual.sh \
  ./ ${FTP_REMOTE};
bye
" -u "${FTP_USER},${FTP_PASSWORD}" "${FTP_HOST}"

echo "Done. Visit https://tomstoursusa.com/ (give DNS 5-30 min if just configured)."
