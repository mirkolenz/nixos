# https://nixos.wiki/wiki/Packaging/Binaries
{
  lib,
  fetchzip,
  stdenv,
  autoPatchelfHook,
}:
let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  pname = "hkknx";
  version = "3.1.2";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_arm64.tar.gz";
      aarch64-linux = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_arm64.tar.gz";
      x86_64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_amd64.tar.gz";
      x86_64-linux = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_amd64.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-DEiFoW6+MDR0+GKI8IVv+cYddk3Yvp4YsRA+WGfYeEA=";
      aarch64-linux = "sha256-Vw9Nnvpkhlg45pjQeIgaVf87nDNqXsayDP08zD0ErE4=";
      x86_64-darwin = "sha256-deN7bstlAhvh7bwdWFr9oiiZ60T5gLgzfYlOKTOj1Z8=";
      x86_64-linux = "sha256-wUg3NG427AnFX512cSZ7+SxN9uYrsKt/tvElaXM/NGc=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
    stripRoot = false;
  };

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D hkknx $out/bin/hkknx

    runHook postInstall
  '';

  meta = with lib; {
    description = "HomeKit Bridge for KNX";
    homepage = "https://hochgatterer.me/hkknx";
    downloadPage = "https://github.com/brutella/hkknx-public/releases";
    mainProgram = pname;
    platforms = attrNames passthru.urls;
    maintainers = with maintainers; [ mirkolenz ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
