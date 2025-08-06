# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.353.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-XpK7RDUp0o2QOMA/XYHFgBVUYyTgSZNP3XayxldAOTA=";
    stripRoot = false;
  };
})
