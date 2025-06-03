# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.328.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-98rgtOMF/ixfp0vYZj5IWAaPrKnlWU0oHcX1rDU/tNc=";
    stripRoot = false;
  };
})
