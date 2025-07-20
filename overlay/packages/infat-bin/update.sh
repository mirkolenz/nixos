#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"

output="$(gh api repos/philocalyst/infat/releases/latest \
  | jq '{
    version: .tag_name | ltrimstr("v"),
    hashes: [
      .assets[]
      | select(.name | test("^infat-(arm64|x86_64)-apple-macos\\.tar\\.gz$"))
      | { key: .name, value: .digest }
    ] | from_entries
    }')"

echo "$output" > "$file"
