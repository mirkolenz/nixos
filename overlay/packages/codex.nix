# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/co/codex/package.nix
{ nixpkgs, rustPlatform }:
nixpkgs.codex.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0.11.0";
    src = prevAttrs.src.override {
      hash = "sha256-t7FgR84alnJGhN/dsFtUySFfOpGoBlRfP+D/Q6JPz5M=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src sourceRoot;
      hash = "sha256-SNl6UXzvtVR+ep7CIoCcpvET8Hs7ew1fmHqOXbzN7kU=";
    };
  }
)
