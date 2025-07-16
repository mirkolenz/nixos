# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.344.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-rYxPTFzl6E1p3SWAfWnruHwqFBwUgLj6k2R7VaElabA=";
    stripRoot = false;
  };
})
