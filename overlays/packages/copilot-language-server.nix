# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.323.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-3+B2IKQxEUxgV1z/cgrJVvoA8at2CBHr1IpmdRnxOe0=";
    stripRoot = false;
  };
})
