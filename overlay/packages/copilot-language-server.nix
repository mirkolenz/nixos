# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.349.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-U7t7ckalYisMPS2WBS7yGn7cOxQTCALXMTHfge36XJM=";
    stripRoot = false;
  };
})
