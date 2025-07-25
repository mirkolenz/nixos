{
  fetchurl,
  lib,
  stdenvNoCC,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-darwin = "x86_64-apple-macos";
    aarch64-darwin = "arm64-apple-macos";
  };
  platform = systemToPlatform.${system};
  assetName = "infat-${platform}.tar.gz";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "infat";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/${assetName}";
    hash = release.hashes.${assetName};
  };

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D infat $out/bin/infat

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # TODO: enable after next release (currently digest is missing)
  # passthru.updateScript = ./update.sh;

  meta = {
    description = "Command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    license = lib.licenses.mit;
    mainProgram = "infat";
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.attrNames systemToPlatform;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
