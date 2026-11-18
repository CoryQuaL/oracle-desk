#!/usr/bin/env bash
# Publish THE ORACLE LITE desk to GitHub Pages.
# Validates oracle-feed.json, copies the lite feed and index.html, then
# commits and pushes only when something changed.
set -euo pipefail
cd "$(dirname "$0")"

if ! python3 -c "import json; json.load(open('oracle-feed.json'))"; then
  echo "ERROR: oracle-feed.json is not valid JSON" >&2
  exit 1
fi

cp -f oracle-feed.json oracle-feed-lite.json
cp -f oracle-desk.html index.html

git add -A

if git diff --cached --quiet; then
  echo "No changes to publish."
  exit 0
fi

if git rev-parse --verify HEAD >/dev/null 2>&1; then
  msg="Update Oracle Lite desk"
else
  msg="Initial Oracle Lite hosted desk"
fi
git commit -m "$msg"

if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git push
else
  git push -u origin HEAD
fi
