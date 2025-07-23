# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.347.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-Ni7HgW/VhdXGreIdKenU5IO0iSeTqhvVv2IBC7t0IzE=";
    stripRoot = false;
  };
})
