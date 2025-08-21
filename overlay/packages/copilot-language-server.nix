# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.360.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-WLCiAIUp1g/PHCc8tOsZpv6FzFnTE5yVP0LgEcuZcdU=";
    stripRoot = false;
  };
})
