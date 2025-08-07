# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.14.0";
    src = prevAttrs.src.override {
      hash = "sha256-qpYkD8fpnlTJ7RLAQrfswLFc58l/KY0x8NgGl/msG/I=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-oPWkxEMnffDZ7cmjWmmYGurYnHn4vYu64BhG7NhrxhE=";
    };
  }
)
