# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.332.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-4ouWwdeoS2p7kGZ3nTb1g+uzvh5SSb7GBbici/A7KGA=";
    stripRoot = false;
  };
})
