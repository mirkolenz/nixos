#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

# file="$(dirname "$BASH_SOURCE")/manifest.nix"
file="overlays/packages/claude-code-bin/manifest.nix"
gcsBucket="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
version="$(curl -fsSL "$gcsBucket/stable")"

echo "{" > "$file";
echo "  version = \"$version\";" >> "$file"
echo "  hashes = {" >> "$file"

curl -fsSL "$gcsBucket/$version/manifest.json" \
  | jq -r '.platforms | to_entries[] | "\(.key) \(.value.checksum)"' \
  | while read -r key value; do
    echo "    $key = \"$value\";" >> "$file"
  done

echo "  };" >> "$file";
echo "}" >> "$file";
