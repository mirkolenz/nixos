# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.330.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-/Em00UVEg46gEI52fG7aQo2rqKwqrF3V1tAVx2hpyMc=";
    stripRoot = false;
  };
})
