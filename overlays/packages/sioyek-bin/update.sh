#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
curl -fsSL "https://api.github.com/repos/ahrm/sioyek/releases?per_page=1" \
  | jq '.[0] | {
    version: (.tag_name | ltrimstr("sioyek")),
    hashes: [
      .assets[]
      | select(.content_type == "application/zip" and (.name | startswith("sioyek-release-mac")))
      | {(.name): (.digest)}
    ] | add
  }' \
  > "$file"
