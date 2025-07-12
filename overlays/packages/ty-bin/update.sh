#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
curl -fsSL "https://api.github.com/repos/astral-sh/ty/releases?per_page=1" \
  | jq '.[0] | {
    version: (.tag_name | ltrimstr("v")),
    hashes: [
      .assets[]
      | select(.content_type == "application/x-gtar" and (.name | startswith("ty-")))
      | {(.name): (.digest)}
    ] | add
  }' \
  > "$file"
