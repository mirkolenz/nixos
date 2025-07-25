# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.348.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-9/siCM0pJv+Cdaqw7ZYAQIpp7cwEo/HeLJAeTC70m0I=";
    stripRoot = false;
  };
})
