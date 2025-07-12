# https://nixos.wiki/wiki/Packaging/Binaries
{
  lib,
  fetchurl,
  stdenvNoCC,
  autoPatchelfHook,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    x86_64-darwin = "darwin_amd64";
    aarch64-darwin = "darwin_arm64";
  };
  platform = systemToPlatform.${system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hkknx";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/brutella/hkknx-public/releases/download/${finalAttrs.version}/hkknx-${finalAttrs.version}_${platform}.tar.gz";
    hash = release.hashes."hkknx-${finalAttrs.version}_${platform}.tar.gz";
  };

  sourceRoot = ".";
  dontBuild = true;

  nativeBuildInputs = lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D hkknx $out/bin/hkknx

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # TODO: enable after next release (currently digest is missing)
  # passthru.updateScript = ./update.sh;

  meta = {
    description = "HomeKit Bridge for KNX";
    homepage = "https://hochgatterer.me/hkknx";
    downloadPage = "https://github.com/brutella/hkknx-public/releases";
    mainProgram = "hkknx";
    platforms = lib.attrNames systemToPlatform;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
})
