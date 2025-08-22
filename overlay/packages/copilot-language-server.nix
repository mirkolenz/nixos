# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.361.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-QIyhihr6HSpZRFRkIkhaP6PajMSZR4x5lv/WKi7bKeQ=";
    stripRoot = false;
  };
})
