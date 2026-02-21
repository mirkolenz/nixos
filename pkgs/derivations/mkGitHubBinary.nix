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
    "assets"
    "binaries"
    "tagTemplate"
    "allowPrereleases"
  ];
  extendDrvArgs =
    finalAttrs:
    args@{
      owner,
      repo,
      file,
      assets,
      pname ? repo,
      binaries ? [ finalAttrs.pname ],
      tagTemplate ? "{version}",
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

      # Split a template on {version} to get its static prefix and suffix.
      splitVersion = template: rec {
        parts = lib.splitString "{version}" template;
        prefix = lib.head parts;
        suffix = lib.last parts;
      };

      # Resolve {version} placeholders in a string.
      resolveVersion = lib.replaceStrings [ "{version}" ] [ finalAttrs.version ];

      tagParts = splitVersion tagTemplate;
      assetName = resolveVersion assets.${stdenv.hostPlatform.system};

      # For the update script: prefix/suffix pairs for matching assets across versions.
      assetFilters = lib.toJSON (map splitVersion (lib.attrValues assets));
    in
    {
      inherit pname;
      version = lib.pipe (release.tag_name or "unstable") [
        (lib.removePrefix tagParts.prefix)
        (lib.removeSuffix tagParts.suffix)
      ];

      src = fetchurl {
        url = "https://github.com/${owner}/${repo}/releases/download/${release.tag_name}/${assetName}";
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
            | jq --argjson filters '${assetFilters}' '
              ${jqSelector} | {
                tag_name,
                assets: [
                  .assets[]
                  | select(.name as $n | any(
                      $filters[];
                      $n | startswith(.prefix) and endswith(.suffix)
                    ))
                  | { key: .name, value: { digest } }
                ] | from_entries
              }
            '
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
        platforms = lib.attrNames assets;
      }
      // args.meta or { };
    };
}
