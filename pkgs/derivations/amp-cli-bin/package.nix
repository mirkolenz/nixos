{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  makeBinaryWrapper,
  installShellFiles,
  writeScript,
  manifestFile ? ./manifest.json,
}:
let
  gcsBucket = "https://storage.googleapis.com/amp-public-assets-prod-0/cli";
  manifest = lib.importJSON manifestFile;
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = platforms.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "amp-cli";
  version = manifest.version or "unstable";

  src = fetchurl {
    url = "${gcsBucket}/${finalAttrs.version}/amp-${platform}";
    sha256 = manifest.checksums.${platform};
  };

  dontUnpack = true;
  dontBuild = true;

  # otherwise the bun runtime is executed instead of the binary (on linux)
  dontStrip = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ]
  ++ lib.optionals (!stdenvNoCC.isDarwin) [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    cp $src amp
    installBin amp
    wrapProgram $out/bin/amp \
      --set AMP_SKIP_UPDATE_CHECK 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = !stdenvNoCC.isDarwin;

  passthru.updateScript = writeScript "update-amp-cli" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure -i bash -p curl jq cacert

    set -euo pipefail

    version="$(curl -fsSL "${gcsBucket}/cli-version.txt")"

    get_checksum() {
      curl -fsSL "${gcsBucket}/$version/$1-amp.sha256"
    }

    manifest="$(jq -n \
      --arg version "$version" \
      --arg darwin_arm64 "$(get_checksum darwin-arm64)" \
      --arg linux_arm64 "$(get_checksum linux-arm64)" \
      --arg linux_x64 "$(get_checksum linux-x64)" \
      '{
        version: $version,
        checksums: {
          "darwin-arm64": $darwin_arm64,
          "linux-arm64": $linux_arm64,
          "linux-x64": $linux_x64
        }
      }'
    )"
    echo "$manifest" > "${toString manifestFile}"
  '';

  meta = {
    description = "Agentic coding assistant by Sourcegraph";
    homepage = "https://ampcode.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "amp";
    platforms = lib.attrNames platforms;
  };
})
