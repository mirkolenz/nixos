# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.19.0";
    src = prevAttrs.src.override {
      hash = "sha256-s7gN1fsk/PRiVVzlrtmAUd2Vu8hhKtlCesLOVrzJ/58=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-zgmiWyWB08v1WQVFzxpC/LGwF+XXbs8iW1d7i9Iw0Q4=";
    };
    doCheck = false;
  }
)
