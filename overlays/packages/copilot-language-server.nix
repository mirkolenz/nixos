# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.345.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-lIJkKR7Zq0IRyBAx/DJrU1W34PkXdbqsFUJvu9Uhb8w=";
    stripRoot = false;
  };
})
