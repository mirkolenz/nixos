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
  version = "1.0.5";
  appname = "NeoHtop";

  passthru.srcs = {
    x86_64-darwin = {
      url = "https://github.com/Abdenasser/neohtop/releases/download/v${version}/${appname}-intel.dmg";
      hash = "sha256-8psDjmT5xzw/dWAE8teYsgexCePCcPBPFiZpJHzPSbs=";
    };
    aarch64-darwin = {
      url = "https://github.com/Abdenasser/neohtop/releases/download/v${version}/${appname}-silicon.dmg";
      hash = "sha256-7qm/KhEtwM+Xin0a6HYI2Y1ezMJI8QV0aZWc/WMPC0Y=";
    };
  };

  src = fetchurl passthru.srcs.${system};
  sourceRoot = ".";
  wrapperPath = "Contents/MacOS/${appname}";

  meta = with lib; {
    description = "htop on steroids";
    homepage = "https://abdenasser.github.io/neohtop/";
    downloadPage = "https://github.com/Abdenasser/neohtop/releases";
    license = licenses.mit;
    platforms = attrNames passthru.srcs;
  };
}
