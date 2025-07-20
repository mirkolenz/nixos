# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.8.0";
    src = prevAttrs.src.override {
      hash = "sha256-BBVP/7XhJa2B9eTRnD7Q0FhsoHonilOc4Rua8jqq18Y=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-LWH/2ZXp/U8H9yveZyUWZP2vj9YLIkLkoufafanXeNQ=";
    };
  }
)
