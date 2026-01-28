{
  lib,
  stdenv,
  fetchurl,
  addDriverRunpath,
  autoPatchelfHook,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeScript,
  libxcrypt-legacy,
  appVariant ? "full",
  manifestFile ? ./manifest.json,
}:
let
  manifest = lib.importJSON manifestFile;
  versionParts = lib.splitString "-" manifest.version;
  version = lib.head versionParts;
  # build = lib.last versionParts;
  platforms = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x64";
  };
  platform = platforms.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "llmster";
  inherit version;

  src = fetchurl {
    url = "https://llmster.lmstudio.ai/download/${manifest.version}-${platform}.${appVariant}.tar.gz";
    sha512 = manifest.checksums.${platform};
  };

  sourceRoot = ".";

  dontBuild = true;
  dontStrip = true;

  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    stdenv.cc.cc
    libxcrypt-legacy
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    addDriverRunpath
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    mv llmster .bundle $out/libexec/
    makeWrapper $out/libexec/llmster $out/bin/llmster
    makeWrapper $out/libexec/.bundle/lms $out/bin/lms

    runHook postInstall
  '';

  # autoAddDriverRunpath uses patchelf on all ELF files
  # but llmster/lms use bun which get corrupted by this.
  postFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    find $out/libexec/.bundle -type f \( -name '*.so' -o -name '*.so.*' -o -name '*.node' \) | while read -r lib; do
      addDriverRunpath "$lib"
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgram = "${placeholder "out"}/bin/llmster";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  strictDeps = true;

  passthru.updateScript = writeScript "update-llmster" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure -i bash -p curl jq cacert gawk

    set -euo pipefail

    version="$(curl -fsSL "https://lmstudio.ai/install.sh" | awk -F'"' '/^APP_VERSION=/ {print $2; exit}')"
    manifest="$(jq -n --arg v "$version" '{version: $v, checksums: {}}')"

    for platform in ${toString (lib.attrValues platforms)}; do
      checksum="$(curl -fsSL "https://llmster.lmstudio.ai/download/$version-$platform.${appVariant}.sha512" 2>/dev/null)" || continue
      manifest="$(echo "$manifest" | jq --arg p "$platform" --arg c "$checksum" '.checksums[$p] = $c')"
    done

    echo "$manifest" > "${toString manifestFile}"
  '';

  meta = {
    description = "CLI tool for LM Studio - discover, download, and run local LLMs";
    homepage = "https://lmstudio.ai";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "lms";
    platforms = lib.attrNames platforms;
    hydraPlatforms = [ ];
  };
})
