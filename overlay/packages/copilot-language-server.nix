# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.346.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-61vWcQ6WGXS6vgXLYzSuJ7Ckx9m3ij9hu2JoYHVMRMY=";
    stripRoot = false;
  };
})
