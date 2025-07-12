#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"
curl -fsSL "https://api.github.com/repos/akiyosi/goneovim/releases/latest" \
  | jq '{
    version: (.tag_name | ltrimstr("v")),
    hashes: [
      .assets[]
      | select(.content_type == "application/x-bzip2" and (.name | startswith("goneovim-")))
      | {(.name): (.digest)}
    ] | add
  }' \
  > "$file"
