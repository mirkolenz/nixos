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
  src = fetchurl {
    url = "https://github.com/neovide/neovide/releases/download/${version}/${appname}-${platform}.dmg";
    hash = "sha256-zlQLwhdgly4za5KVDjKtQtV5yNtXY84zxRX4d/Qs4LQ=";
  };
  # undmg cannot handle APFS dmg files, so we need to mount it manually
  # unpackCmd = ''
  #   /usr/bin/hdiutil mount "$curSrc/${pname}.dmg"
  #   cp -R /Volumes/${pname}/${appname}.app .
  #   /usr/bin/hdiutil unmount /Volumes/${pname}
  # '';
  postInstall = ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/${appname}.app/Contents/MacOS/neovide" "$out/bin/${pname}"
  '';
  meta = {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    downloadPage = "https://github.com/neovide/neovide/releases";
    license = with lib.licenses; [ mit ];
  };
}
