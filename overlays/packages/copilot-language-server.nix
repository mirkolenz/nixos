# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.335.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-ZMnbfVLe1ZtYYCaMhSNqeWfHEtKJf8BImiipypa57w0=";
    stripRoot = false;
  };
})
