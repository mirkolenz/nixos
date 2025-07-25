# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.10.0";
    src = prevAttrs.src.override {
      hash = "sha256-ukQG6Ugc4lvJEdPmorNEdVh8XrgjuOO8x/8F+9jcw3U=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-YZHmMRwJgZTPHyoB4GXlt6H2Igw1wh/4vMYt7+3Nz1Y=";
    };
  }
)
