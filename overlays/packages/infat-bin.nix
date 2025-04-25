{
  lib,
  fetchzip,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  pname = "infat";
  version = "1.1.0";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/philocalyst/infat/releases/download/v${version}/infat-arm64-apple-macos.tar.gz";
      x86_64-darwin = "https://github.com/philocalyst/infat/releases/download/v${version}/infat-x86_64-apple-macos.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-tEpUUOJVAgUrpBtBN7dpw+jrqMU1Ww/PGsNc8BjIIkg=";
      x86_64-darwin = "sha256-QUijXYiqeZueR0wcGQPFgv01RYjA/+06aAg9yx9PMiQ=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D infat-* $out/bin/infat

    runHook postInstall
  '';

  meta = {
    description = "Command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    license = lib.licenses.mit;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.attrNames passthru.urls;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
