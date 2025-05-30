# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.326.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-q88EpdOcU+3iSS1oH9RvdSxukO6WeFg5cB7x4yL/Xtg=";
    stripRoot = false;
  };
})
