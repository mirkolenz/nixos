#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
curl -fsSL "https://api.github.com/repos/philocalyst/infat/releases/latest" \
  | jq '{
    version: (.tag_name | ltrimstr("v")),
    hashes: [
      .assets[]
      | select(.content_type == "application/gzip" and (.name | startswith("infat-")))
      | {(.name): (.digest)}
    ] | add
  }' \
  > "$file"
