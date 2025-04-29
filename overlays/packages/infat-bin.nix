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
  version = "2.3.1";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-arm64-apple-macos.tar.gz";
      x86_64-darwin = "https://github.com/philocalyst/infat/releases/download/v${finalAttrs.version}/infat-x86_64-apple-macos.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-J1HccjIIDG2oCdh7jJNHI9iXweSCanxS4svgRak1tJk=";
      x86_64-darwin = "sha256-AcJ9Cvbq8IE3+M5BZtT8Udp5d0dpre2dr2HsIspdoZQ=";
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
