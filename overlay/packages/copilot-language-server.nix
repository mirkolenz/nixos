# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/copilot-language-server/package.nix
{ nixpkgs, fetchzip }:
nixpkgs.copilot-language-server.overrideAttrs (prevAttrs: {
  version = "1.351.0";
  src = fetchzip {
    inherit (prevAttrs.src) url;
    hash = "sha256-/ohvUK5jNLpV3G+xGH2ZPsY44ZnIgsvgKp5KqSjk5VI=";
    stripRoot = false;
  };
})
