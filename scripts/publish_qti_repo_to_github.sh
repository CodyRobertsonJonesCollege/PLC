#!/usr/bin/env bash
set -euo pipefail

# Publishes the standalone /workspace/qti-converter repo to GitHub.
# Requirements:
#   1) A GitHub Personal Access Token in GITHUB_TOKEN
#   2) Repo owner in GITHUB_OWNER (user/org)
# Optional:
#   - GITHUB_REPO (defaults to qti-converter)
#   - VISIBILITY (public|private, defaults to private)

: "${GITHUB_TOKEN:?Set GITHUB_TOKEN to a token with repo create/push access}"
: "${GITHUB_OWNER:?Set GITHUB_OWNER to your GitHub user/org}"

GITHUB_REPO="${GITHUB_REPO:-qti-converter}"
VISIBILITY="${VISIBILITY:-private}"
LOCAL_REPO="/workspace/qti-converter"

if [[ ! -d "$LOCAL_REPO/.git" ]]; then
  echo "Local standalone repo not found at $LOCAL_REPO"
  exit 1
fi

echo "Creating GitHub repository $GITHUB_OWNER/$GITHUB_REPO ($VISIBILITY)..."
HTTP_CODE=$(curl -sS -o /tmp/create_repo_resp.json -w "%{http_code}" \
  -X POST https://api.github.com/user/repos \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"name\":\"$GITHUB_REPO\",\"private\":$([[ "$VISIBILITY" == "private" ]] && echo true || echo false)}")

if [[ "$HTTP_CODE" != "201" && "$HTTP_CODE" != "422" ]]; then
  echo "GitHub API repo creation failed (HTTP $HTTP_CODE):"
  cat /tmp/create_repo_resp.json
  exit 1
fi

cd "$LOCAL_REPO"
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "https://github.com/$GITHUB_OWNER/$GITHUB_REPO.git"

echo "Pushing standalone repo to GitHub..."
git push -u "https://$GITHUB_OWNER:$GITHUB_TOKEN@github.com/$GITHUB_OWNER/$GITHUB_REPO.git" HEAD:main

echo "Done: https://github.com/$GITHUB_OWNER/$GITHUB_REPO"
