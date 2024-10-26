# https://github.com/NixOS/nixpkgs/pull/222451
{
  mkApp,
  fetchurl,
  lib,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
  platforms = {
    x86_64-darwin = "x86_64-apple-darwin";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  platform = platforms.${system};
in
mkApp rec {
  pname = "neovide";
  version = "0.13.3";
  appname = "Neovide";
  sourceRoot = "${appname}.app";
  src = fetchurl {
    url = "https://github.com/neovide/neovide/releases/download/${version}/${appname}-${platform}.dmg";
    hash = "sha256-zlQLwhdgly4za5KVDjKtQtV5yNtXY84zxRX4d/Qs4LQ=";
  };
  wrapperPath = "Contents/MacOS/${pname}";
  meta = with lib; {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    downloadPage = "https://github.com/neovide/neovide/releases";
    license = licenses.mit;
  };
}
