# https://github.com/NixOS/nixpkgs/pull/222451
{
  mkApp,
  fetchurl,
  lib,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
in
mkApp rec {
  pname = "neohtop";
  version = "1.1.2";
  appname = "NeoHtop";

  passthru = {
    urls = {
      x86_64-darwin = "https://github.com/Abdenasser/neohtop/releases/download/v${version}/intel-${appname}_${version}_x64.dmg";
      aarch64-darwin = "https://github.com/Abdenasser/neohtop/releases/download/v${version}/silicon-${appname}_${version}_aarch64.dmg";
    };
    hashes = {
      aarch64-darwin = "sha256-Qbjo64qdiX2EhXYKbaNPLhNZAnVsTV7c7fVNCUEKXXc=";
      x86_64-darwin = "sha256-FSYyA1G5GZuljWnTRFBmEmK75CJk+8P6zH3N3SDOe7g=";
    };
  };

  src = fetchurl {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };
  sourceRoot = ".";
  wrapperPath = "Contents/MacOS/${appname}";

  meta = with lib; {
    description = "htop on steroids";
    homepage = "https://abdenasser.github.io/neohtop/";
    downloadPage = "https://github.com/Abdenasser/neohtop/releases";
    license = licenses.mit;
    platforms = attrNames passthru.urls;
  };
}
