# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.356.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-20+suY6FoI6uDqYJ9wvPoeXO4oKyDndloAw/bzY8LoM=";
    stripRoot = false;
  };
})
