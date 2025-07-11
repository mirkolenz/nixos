# https://nixos.wiki/wiki/Packaging/Binaries
{
  lib,
  fetchzip,
  stdenvNoCC,
  autoPatchelfHook,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hkknx";
  version = "3.1.2";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${finalAttrs.version}/hkknx-${finalAttrs.version}_darwin_arm64.tar.gz";
      aarch64-linux = "https://github.com/brutella/hkknx-public/releases/download/${finalAttrs.version}/hkknx-${finalAttrs.version}_linux_arm64.tar.gz";
      x86_64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${finalAttrs.version}/hkknx-${finalAttrs.version}_darwin_amd64.tar.gz";
      x86_64-linux = "https://github.com/brutella/hkknx-public/releases/download/${finalAttrs.version}/hkknx-${finalAttrs.version}_linux_amd64.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-DEiFoW6+MDR0+GKI8IVv+cYddk3Yvp4YsRA+WGfYeEA=";
      aarch64-linux = "sha256-Vw9Nnvpkhlg45pjQeIgaVf87nDNqXsayDP08zD0ErE4=";
      x86_64-darwin = "sha256-deN7bstlAhvh7bwdWFr9oiiZ60T5gLgzfYlOKTOj1Z8=";
      x86_64-linux = "sha256-wUg3NG427AnFX512cSZ7+SxN9uYrsKt/tvElaXM/NGc=";
    };
  };

  src = fetchzip {
    url = finalAttrs.passthru.urls.${system};
    hash = finalAttrs.passthru.hashes.${system};
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D hkknx $out/bin/hkknx

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "HomeKit Bridge for KNX";
    homepage = "https://hochgatterer.me/hkknx";
    downloadPage = "https://github.com/brutella/hkknx-public/releases";
    mainProgram = "hkknx";
    platforms = lib.attrNames finalAttrs.passthru.urls;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
  };
})
