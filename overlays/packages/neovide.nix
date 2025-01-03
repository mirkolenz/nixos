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
  pname = "neovide";
  version = "0.13.3";
  appname = "Neovide";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/neovide/neovide/releases/download/${version}/${appname}-aarch64-apple-darwin.dmg";
      x86_64-darwin = "https://github.com/neovide/neovide/releases/download/${version}/${appname}-x86_64-apple-darwin.dmg";
    };
    hashes = {
      aarch64-darwin = "sha256-0XiDoasWlMJNZwmGzU9YVt/t6RNMu0kEJg5+duYU3qA=";
      x86_64-darwin = "sha256-zlQLwhdgly4za5KVDjKtQtV5yNtXY84zxRX4d/Qs4LQ=";
    };
  };

  src = fetchurl {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };
  sourceRoot = ".";
  wrapperPath = "Contents/MacOS/${pname}";

  meta = with lib; {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    downloadPage = "https://github.com/neovide/neovide/releases";
    license = licenses.mit;
    platforms = attrNames passthru.urls;
  };
}
