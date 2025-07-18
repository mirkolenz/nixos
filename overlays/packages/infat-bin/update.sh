#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
output="$(gh api repos/philocalyst/infat/releases/latest \
  | jq '{
    version: (.tag_name | ltrimstr("v")),
    hashes: [
      .assets[]
      | select(.content_type == "application/gzip" and (.name | startswith("infat-")))
      | {(.name): (.digest)}
    ] | add
  }')"
echo "$output" > "$file"
