# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.354.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-UlqAzpRyWkZZv3r6tjYtvl5QE7LfENsAyNKN2cZLaR0=";
    stripRoot = false;
  };
})
