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
    "versionRegex"
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
      versionRegex ? "(.+)",
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
      assetName = assets.${stdenv.hostPlatform.system};

      # Generates a jq regex pattern matching all asset names across platforms.
      # Escapes dots first, then replaces the escaped version with .+ so the pattern matches future releases.
      escapeRegex = builtins.replaceStrings [ "." ] [ "\\\\." ];
      assetToRegex =
        name:
        builtins.replaceStrings [ (escapeRegex finalAttrs.version) ] [ ".+" ] (escapeRegex name);
      pattern = "^(${lib.concatStringsSep "|" (map assetToRegex (lib.attrValues assets))})$";
    in
    {
      inherit pname;
      version =
        let
          m = builtins.match versionRegex (release.tag_name or "unstable");
        in
        if m == null then "unstable" else builtins.head m;

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
            | jq '${jqSelector} | {
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
        platforms = lib.attrNames assets;
      }
      // args.meta or { };
    };
}
