#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
output="$(gh api repos/brutella/hkknx-public/releases/latest \
  | jq '{
    version: (.tag_name | ltrimstr("v")),
    hashes: [
      .assets[]
      | select(.content_type == "application/x-gtar" and (.name | startswith("hkknx-")))
      | {(.name): (.digest)}
    ] | add
  }')"
echo "$output" > "$file"
