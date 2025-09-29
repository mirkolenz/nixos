{
  writeShellScript,
  lib,
  fetchurl,
  stdenv,
  installShellFiles,
  autoPatchelfHook,
}:
args@{
  # custom args
  owner,
  repo,
  file,
  getAsset,
  getHash ? getAsset,
  binaryNames ? [ pname ],
  assetsPattern ? ".*",
  assetsReplace ? "",
  versionPrefix ? "",
  versionSuffix ? "",
  allowPrereleases ? false,
  # mkDerivation args
  pname ? repo,
  nativeBuildInputs ? [ ],
  passthru ? { },
  meta ? { },
  ...
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

  fileContents = lib.importJSON file;
  version = fileContents.version or "unstable";
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (
  (lib.removeAttrs args [
    "owner"
    "repo"
    "file"
    "getAsset"
    "getHash"
    "binaryNames"
    "assetsPattern"
    "assetsReplace"
    "versionPrefix"
    "versionSuffix"
    "allowPrereleases"
  ])
  // {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/${owner}/${repo}/releases/download/${versionPrefix}${version}${versionSuffix}/${
        getAsset { inherit version system; }
      }";
      hash = fileContents.hashes.${getHash { inherit version system; }} or lib.fakeHash;
    };

    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs =
      nativeBuildInputs ++ [ installShellFiles ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);

    installPhase = ''
      runHook preInstall

      ${lib.optionalString (binaryNames != [ ]) "installBin ${toString binaryNames}"}

      runHook postInstall
    '';

    passthru = passthru // {
      updateScript = writeShellScript "github-binaries-${owner}-${repo}" ''
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

        echo "$output" > "${toString file}"
      '';
    };

    meta = meta // {
      maintainers = with lib.maintainers; [ mirkolenz ];
      sourceProvenance = lib.sourceTypes.binaryNativeCode;
      mainProgram = pname;
    };
  }
)
