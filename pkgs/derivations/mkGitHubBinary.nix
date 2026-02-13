{
  writeScript,
  lib,
  fetchurl,
  stdenv,
  installShellFiles,
  autoPatchelfHook,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "owner"
    "repo"
    "file"
    "platforms"
    "getAsset"
    "binaries"
    "versionPrefix"
    "versionSuffix"
    "allowPrereleases"
  ];
  extendDrvArgs =
    finalAttrs:
    args@{
      owner,
      repo,
      file,
      platforms,
      getAsset,
      pname ? repo,
      binaries ? [ finalAttrs.pname ],
      versionPrefix ? "",
      versionSuffix ? "",
      allowPrereleases ? false,
      ...
    }:
    let
      jqSelector = if allowPrereleases then ".[0]" else ".";
      ghCall =
        if allowPrereleases then
          "gh api repos/${owner}/${repo}/releases --method GET --raw-field per_page=1"
        else
          "gh api repos/${owner}/${repo}/releases/latest";

      release = lib.importJSON file;
      assetName = getAsset {
        platform = platforms.${stdenv.hostPlatform.system};
        inherit (finalAttrs) version;
      };

      # jq binding that strips versionPrefix/Suffix from tag_name
      versionJqPipeline = lib.concatStringsSep " | " (
        [ ".tag_name" ]
        ++ lib.optional (versionPrefix != "") "ltrimstr(\"${versionPrefix}\")"
        ++ lib.optional (versionSuffix != "") "rtrimstr(\"${versionSuffix}\")"
      );

      # Generates a jq regex pattern matching all asset names across platforms.
      # Concrete asset names for each platform (e.g., "uv-aarch64-apple-darwin.tar.gz")
      allAssetNames = lib.mapAttrsToList (
        _: plat:
        getAsset {
          platform = plat;
          inherit (finalAttrs) version;
        }
      ) platforms;
      # Replaces the version with jq interpolation \($version) so the pattern matches future releases,
      # and escapes dots so that e.g. .tar.gz only matches literal dots in the regex.
      assetToRegex =
        builtins.replaceStrings
          [
            finalAttrs.version
            "."
          ]
          [
            "\\($version)"
            "\\\\."
          ];
      # Joins all regex alternatives into ^(alt1|alt2|...)$
      pattern = "^(${lib.concatStringsSep "|" (map assetToRegex allAssetNames)})$";
    in
    {
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
        (args.nativeBuildInputs or [ ])
        ++ [ installShellFiles ]
        ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

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
            | jq '${jqSelector} | (${versionJqPipeline}) as $version | {
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
      // args.passthru or { };

      strictDeps = args.strictDeps or true;

      meta = {
        homepage = "https://github.com/${owner}/${repo}";
        downloadPage = "https://github.com/${owner}/${repo}/releases";
        maintainers = with lib.maintainers; [ mirkolenz ];
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        mainProgram = finalAttrs.pname;
        platforms = lib.attrNames platforms;
      }
      // args.meta or { };
    };
}
