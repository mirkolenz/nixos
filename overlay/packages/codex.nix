# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.12.0";
    src = prevAttrs.src.override {
      hash = "sha256-Mo/dg1Y8BzcZ2DyIAAQTX8bXlzqp1CtNld4PRFfSejo=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-v893fvSWsQrhes4aAv5EZf4Mo2WE2zo9N4p2zIAmSDQ=";
    };
  }
)
