{ writeShellScript }:
{
  owner,
  repo,
  outputFile,
  assetsPattern ? ".*",
  versionPrefix ? "v",
  allowPrereleases ? false,
}:
let
  jqSelector = if allowPrereleases then ".[0]" else ".";
  ghCall =
    if allowPrereleases then
      "gh api repos/${owner}/${repo}/releases --method GET --raw-field per_page=1"
    else
      "gh api repos/${owner}/${repo}/releases/latest";
in
writeShellScript "github-binaries-${owner}-${repo}" ''
  #!/usr/bin/env nix-shell
  #!nix-shell -i bash -p gh jq

  set -euo pipefail

  output="$(
    ${ghCall} \
    | jq '${jqSelector} | . as $release | {
      version: .tag_name | ltrimstr("${versionPrefix}"),
      hashes: [
        .assets[]
        | select(.name | test("${assetsPattern}"))
        | { key: .name, value: .digest }
      ] | from_entries
    }'
  )"

  echo "$output" > "${toString outputFile}"
''
