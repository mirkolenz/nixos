# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.21.0";
    src = prevAttrs.src.override {
      hash = "sha256-9hwDAkrMW0llcYJdkrUCSdh3guRcUCmx8MDkHLyY6v0=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-ykG3howLyA4kA7cjP8Gx+usRcgQoVHW0ECQzTUigG8A=";
    };
    doCheck = false;
  }
)
