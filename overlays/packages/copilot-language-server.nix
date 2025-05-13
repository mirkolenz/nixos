# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.319.0";
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-PN0MONsAeUAlRUeSxyRV6vg4cJmILpeaCw4yW1ZA5Mk=";
    stripRoot = false;
  };
})
