args@{ inputs, ... }:
[
  (import ./channels args)
  (import ./packages args)
  (final: prev: inputs.caddy-nix.overlays.default final.nixpkgs prev.nixpkgs)
  inputs.nix-darwin-unstable.overlays.default
]
