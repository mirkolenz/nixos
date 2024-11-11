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
  version = "3.1.0";

  passthru.srcs = {
    x86_64-linux = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_amd64.tar.gz";
      hash = "sha256-SQXBwqzcAA9z4+tyCF1tKdwpQqeGEIPPmPLUIwWM0B8=";
    };
    aarch64-linux = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_linux_arm64.tar.gz";
      hash = "sha256-UIhP+OMZYZ2tRG0a2IwXMH5s9bMoGGSr/nFe6X0uC+4=";
    };
    x86_64-darwin = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_amd64.tar.gz";
      hash = "sha256-i27DW5lHMqdPgOT2SqGqUOy3ixiR4KSaMbNyOfC7AVU=";
    };
    aarch64-darwin = {
      url = "https://github.com/brutella/hkknx-public/releases/download/${version}/${pname}-${version}_darwin_arm64.tar.gz";
      hash = "sha256-GcRykKZC+X8uCQSe2vH8vK3ep3qhKpfkDQj9Firsr7o=";
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
