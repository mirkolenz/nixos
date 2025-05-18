# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.322.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-3AJTC4TI+sqTi1/B1XQZght7CClplWwIxjGmrt1E2ME=";
    stripRoot = false;
  };
})
