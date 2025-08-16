# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.22.0";
    src = prevAttrs.src.override {
      hash = "sha256-JTwtydW8LLBH/55+8a/BbqlZtkXsFKbT8dGoDEAjk1c=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-3PljlyPfDsnjGmR/0iM7Fu1TnyDj31pKVcOU/izsL30=";
    };
    doCheck = false;
  }
)
