#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"

output="$(gh api repos/astral-sh/ty/releases \
  --method GET \
  --raw-field per_page=1 \
  | jq '.[0] | {
    version: .tag_name | ltrimstr("v"),
    hashes: [
      .assets[]
      | select(.name | test("^ty-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$"))
      | { key: .name, value: .digest }
    ] | from_entries
  }')"

echo "$output" > "$file"
