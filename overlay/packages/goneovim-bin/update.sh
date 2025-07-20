#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gh

set -euo pipefail

file="$(dirname "$BASH_SOURCE")/release.json"

output="$(gh api repos/akiyosi/goneovim/releases/latest \
  | jq '. as $root | {
    version: .tag_name | ltrimstr("v"),
    hashes: [
      .assets[]
      | select(.name | test("^goneovim-" + $root.tag_name + "-((linux)|(macos-(arm64|x86_64)))\\.tar\\.bz2$"))
      | { key: .name, value: .digest }
    ] | from_entries
  }')"

echo "$output" > "$file"
