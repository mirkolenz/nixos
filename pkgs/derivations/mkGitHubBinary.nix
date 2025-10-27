{
  writeScript,
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
  binaries ? [ pname ],
  pattern ? ".*",
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
stdenv.mkDerivation (
  finalAttrs:
  let
    jqSelector = if allowPrereleases then ".[0]" else ".";
    ghCall =
      if allowPrereleases then
        "gh api repos/${owner}/${repo}/releases --method GET --raw-field per_page=1"
      else
        "gh api repos/${owner}/${repo}/releases/latest";

    inherit (stdenv.hostPlatform) system;

    release = lib.importJSON file;
    assetName = getAsset {
      inherit system;
      inherit (finalAttrs) version;
    };
  in
  (
    (lib.removeAttrs args [
      "owner"
      "repo"
      "file"
      "getAsset"
      "binaries"
      "pattern"
      "versionPrefix"
      "versionSuffix"
      "allowPrereleases"
    ])
    // {
      inherit pname;
      version = lib.pipe (release.tag_name or "unstable") [
        (lib.removePrefix versionPrefix)
        (lib.removeSuffix versionSuffix)
      ];

      src = fetchurl {
        url = "https://github.com/${owner}/${repo}/releases/download/${versionPrefix}${finalAttrs.version}${versionSuffix}/${assetName}";
        hash = release.assets.${assetName}.digest;
      };

      dontConfigure = true;
      dontBuild = true;

      nativeBuildInputs =
        nativeBuildInputs ++ [ installShellFiles ] ++ lib.optionals (!stdenv.isDarwin) [ autoPatchelfHook ];

      installPhase = ''
        runHook preInstall

        ${lib.optionalString (binaries != [ ]) "installBin ${toString binaries}"}

        runHook postInstall
      '';

      passthru = {
        updateScript = writeScript "github-binaries-${owner}-${repo}" ''
          #!/usr/bin/env nix-shell
          #!nix-shell --pure --keep GH_TOKEN -i bash -p gh jq

          set -euo pipefail

          output="$(
            ${ghCall} \
            | jq '${jqSelector} | . as $release | {
              tag_name,
              assets: [
                .assets[]
                | select(.name | test("${pattern}"))
                | { key: .name, value: { digest } }
              ] | from_entries
            }'
          )"

          echo "$output" > "${toString file}"
        '';
      }
      // passthru;

      meta = {
        homepage = "https://github.com/${owner}/${repo}";
        downloadPage = "https://github.com/${owner}/${repo}/releases";
        maintainers = with lib.maintainers; [ mirkolenz ];
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        mainProgram = pname;
      }
      // meta;
    }
  )
)
