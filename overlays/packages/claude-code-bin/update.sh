#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/manifest.json"
gcsBucket="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
version="$(curl -fsSL "$gcsBucket/stable")"
curl -fsSL -o "$file" "$gcsBucket/$version/manifest.json"
