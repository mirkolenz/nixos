{
  fetchzip,
  lib,
  stdenvNoCC,
  testers,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "infat";
  version = "2.0.1";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-arm64-apple-macos.tar.gz";
      x86_64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-x86_64-apple-macos.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-8PCKxZ6vB061SWPO0QmaoaMVtT8HpYBO1hoOVXXAsoM=";
      x86_64-darwin = "sha256-xhnycBSCxLjp2Yln4EF/GYLTDG9uf2+OE01qgt0zXRQ=";
    };
  };

  src = fetchzip {
    url = finalAttrs.passthru.urls.${system};
    hash = finalAttrs.passthru.hashes.${system};
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D infat $out/bin/infat

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "infat --version";
    };
  };

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
