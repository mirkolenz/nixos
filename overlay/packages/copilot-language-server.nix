# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.357.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-uVfQk26a/huFxsAtYKPfaJyYSWH17+8PqDh/HFecsdA=";
    stripRoot = false;
  };
})
