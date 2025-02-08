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
  version = "3.1.1";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_arm64.tar.gz";
      aarch64-linux = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_arm64.tar.gz";
      x86_64-darwin = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_amd64.tar.gz";
      x86_64-linux = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_amd64.tar.gz";
    };
    hashes = {
      aarch64-darwin = "sha256-YuFdI1+NjYUe7ygFtWIe7xXpmROs+Kyz9SSmZFVzBSs=";
      aarch64-linux = "sha256-YKU/xpQBSEqCJTTQKd22YsddQpyh3IK0b3JO838ZIoE=";
      x86_64-darwin = "sha256-wll3cIk3Oqy+wQ+08H33IWad/kBzkeMx4RHqj4e4aoM=";
      x86_64-linux = "sha256-XbNCNi/v0N96NCWQ6H/gXV+UVn/dAUjG9iUu8ZiBpPc=";
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
