# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.23.0";
    src = prevAttrs.src.override {
      hash = "sha256-JS2nRh3/MNQ0mfdr2/Q10sAB38yWBLpw2zFf0dJORuM=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-HbhOiTO7qFp64v+Bb62V1LxPH7qeTnWwkJKPEN4Vx6c=";
    };
    doCheck = false;
  }
)
