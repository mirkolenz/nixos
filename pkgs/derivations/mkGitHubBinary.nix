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
    "versionPrefix"
    "versionSuffix"
    "allowPrereleases"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      # custom
      owner,
      repo,
      file,
      assets,
      binaries ? [ finalAttrs.pname ],
      versionPrefix ? "",
      versionSuffix ? "",
      allowPrereleases ? false,
      # upstream
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

      release = lib.importJSON file;

      # Assets can be an attrset or a function of version.
      resolvedAssets = if lib.isFunction assets then assets finalAttrs.version else assets;

      # Derive prefix/suffix pairs for the update script's jq asset filter.
      # When assets is a function, evaluate it with a sentinel to find where the
      # version appears; when it is a plain attrset, the sentinel won't appear
      # so each name becomes both prefix and suffix (exact match).
      sentinel = "__NIXPKGS_VERSION__";
      sentinelAssets = if lib.isFunction assets then assets sentinel else assets;
      assetFilters = lib.toJSON (
        map (
          name:
          let
            parts = lib.splitString sentinel name;
          in
          {
            prefix = lib.head parts;
            suffix = lib.last parts;
          }
        ) (lib.attrValues sentinelAssets)
      );

      assetName = resolvedAssets.${stdenv.hostPlatform.system};
    in
    {
      inherit pname;
      version = lib.pipe (release.tag_name or "unstable") [
        (lib.removePrefix versionPrefix)
        (lib.removeSuffix versionSuffix)
      ];

      src = fetchurl {
        url = "https://github.com/${owner}/${repo}/releases/download/${release.tag_name}/${assetName}";
        hash = release.assets.${assetName}.digest;
      };

      dontConfigure = true;
      dontBuild = true;
      strictDeps = true;

      nativeBuildInputs =
        nativeBuildInputs
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
                  $filters[] as $f | .assets[]
                  | select(.name | startswith($f.prefix) and endswith($f.suffix))
                  | { key: .name, value: { digest } }
                ] | from_entries
              }
            '
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
        mainProgram = finalAttrs.pname;
        platforms = lib.attrNames resolvedAssets;
      }
      // meta;
    };
}
