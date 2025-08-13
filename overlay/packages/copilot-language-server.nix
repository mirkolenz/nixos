# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.355.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-UeysOGTrbs5HmzBabPuY+EXnAhJ/vHQ0xHnu1kLkzGI=";
    stripRoot = false;
  };
})
