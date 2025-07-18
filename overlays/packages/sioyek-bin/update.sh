#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
gh api repos/ahrm/sioyek/releases \
  --method GET \
  --raw-field per_page=1 \
  | jq '.[0] | {
    version: (.tag_name | ltrimstr("sioyek")),
    hashes: [
      .assets[]
      | select(.content_type == "application/zip" and (.name | startswith("sioyek-release-mac")))
      | {(.name): (.digest)}
    ] | add
  }' \
  > "$file"
