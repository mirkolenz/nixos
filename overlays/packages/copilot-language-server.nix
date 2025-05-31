# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (oldAttrs: {
  version = "1.327.0";
  # nix-update --flake copilot-language-server
  src = fetchzip {
    inherit (oldAttrs.src) url;
    hash = "sha256-Fl1EtWYluC9zvkrK92tQepv6fzo5ETMiOZBgLmADie4=";
    stripRoot = false;
  };
})
