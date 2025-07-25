#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

# https://claude.ai/install.sh
file="$(dirname "$BASH_SOURCE")/manifest.json"
gcsBucket="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
version="$(curl -fsSL "$gcsBucket/stable")"
output="$(curl -fsSL "$gcsBucket/$version/manifest.json" \
  | jq '{
    version: .version,
    hashes: .platforms | with_entries(
      select(.key | test("^(darwin|linux)-(x64|arm64)$"))
      | .value = "sha256:" + .value.checksum
    )
  }')"
echo "$output" > "$file"
