# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.350.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-JUpyzXThGivZdIUwpzd71L5zdmGJabPf2kTn0oQQxlA=";
    stripRoot = false;
  };
})
