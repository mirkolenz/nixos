{
  fetchurl,
  lib,
  stdenvNoCC,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "infat";
  version = "2.4.0";
  # prefetch-attrs .#infat-bin.passthru.urls

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-arm64-apple-macos.tar.gz";
      x86_64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-x86_64-apple-macos.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-4r0SatEclupqFvEpnfMd001rQlX3r/FT9K4lKSDYcJ8=";
      x86_64-darwin = "sha256-4fA8L4WqxDvjHcOoySQn+p514lYVBhyDw3GvoVNY9gE=";
    };
  };

  src = fetchurl {
    url = finalAttrs.passthru.urls.${system};
    hash = finalAttrs.passthru.hashes.${system};
  };

  # unpacking produces a single file, so we don't want to cd into it
  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D infat $out/bin/infat

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    license = lib.licenses.mit;
    mainProgram = "infat";
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.attrNames finalAttrs.passthru.urls;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
