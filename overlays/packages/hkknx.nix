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
  version = "3.0.0";

  passthru.srcs = {
    x86_64-linux = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_amd64.tar.gz";
      hash = "sha256-hL2Jpm2OA1yBH6ttoYY4F9W1t9UiV315l5FNsNyWzys=";
    };
    aarch64-linux = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_arm64.tar.gz";
      hash = "sha256-Q+YjKV6qUdPK2GH9Ihq8LVSg1id4FT7yXoM/DpjAjmQ=";
    };
    x86_64-darwin = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_amd64.tar.gz";
      hash = "sha256-H5/fDzULHEBONMt4qS1kQJB7aP24BowHVS+cVjlnuzQ=";
    };
    aarch64-darwin = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_arm64.tar.gz";
      hash = "sha256-7RV7+8cg+udtBrKxP5tAWda3TeDH/cimeYrm66wKMxM=";
    };
  };

  src = fetchzip (passthru.srcs.${system} // { stripRoot = false; });

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
    platforms = attrNames passthru.srcs;
    maintainers = with maintainers; [ mirkolenz ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
