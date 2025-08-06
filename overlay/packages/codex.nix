# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.13.0";
    src = prevAttrs.src.override {
      hash = "sha256-A9o6qsw0f3v0nSCjyHaMIsm+udz/S4TR10K48vFR7Cc=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-oPWkxEMnffDZ7cmjWmmYGurYnHn4vYu64BhG7NhrxhE=";
    };
  }
)
