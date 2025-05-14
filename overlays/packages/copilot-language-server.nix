# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.320.0";
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-mRRg1KUpBdL134Rhtv/q/z7Ss6RKyb+HJYklIvNgo0o=";
    stripRoot = false;
  };
})
