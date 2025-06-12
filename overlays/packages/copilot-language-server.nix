# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.333.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-NqwzhZyHbQ1YO3xVxHyKPyd48DRd4/Awj6j6P7HXb6Y=";
    stripRoot = false;
  };
})
