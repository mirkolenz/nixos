{ writeShellScript, lib }:
{
  owner,
  repo,
  outputFile,
  assetsPattern ? ".*",
  assetsReplace ? "",
  versionPrefix ? "",
  versionSuffix ? "",
  allowPrereleases ? false,
}:
let
  jqSelector = if allowPrereleases then ".[0]" else ".";
  ghCall =
    if allowPrereleases then
      "gh api repos/${owner}/${repo}/releases --method GET --raw-field per_page=1"
    else
      "gh api repos/${owner}/${repo}/releases/latest";

  versionFilter = toString [
    (lib.optionalString (versionPrefix != "") "| ltrimstr(\"${versionPrefix}\")")
    (lib.optionalString (versionSuffix != "") "| rtrimstr(\"${versionSuffix}\")")
  ];

  assetsFilter = lib.optionalString (
    assetsReplace != ""
  ) "| sub(\"${assetsPattern}\"; \"${assetsReplace}\")";
in
writeShellScript "github-binaries-${owner}-${repo}" ''
  #!/usr/bin/env nix-shell
  #!nix-shell -i bash -p gh jq

  set -euo pipefail

  output="$(
    ${ghCall} \
    | jq '${jqSelector} | . as $release | {
      version: .tag_name ${versionFilter},
      hashes: [
        .assets[]
        | select(.name | test("${assetsPattern}"))
        | { key: .name ${assetsFilter}, value: .digest }
      ] | from_entries
    }'
  )"

  echo "$output" > "${toString outputFile}"
''
