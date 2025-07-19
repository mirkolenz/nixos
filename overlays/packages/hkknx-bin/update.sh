#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh jq

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"

output="$(gh api repos/brutella/hkknx-public/releases/latest \
  | jq '. as $root | {
    version: .tag_name | ltrimstr("v"),
    hashes: [
      .assets[]
      | select(.name | test("^hkknx-" + $root.tag_name + "_(darwin|linux)_(amd64|arm64)\\.tar\\.gz$"))
      | { key: .name, value: .digest }
    ] | from_entries
  }')"

echo "$output" > "$file"
