# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.9.0";
    src = prevAttrs.src.override {
      hash = "sha256-TaayWKkS4LZDBOCCUPlBg3AdiQjxZvcA9csLqV+h+Dc=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-gNdviz64qe5oX34pJUrPsIEc1N0xPucsZp6+UkBtOwM=";
    };
  }
)
