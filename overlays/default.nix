args@{ inputs, ... }:
[
  (import ./channels args)
  (import ./packages args)
  inputs.poetry2nix.overlays.default
  inputs.caddy-nix.overlays.default
  inputs.nix-darwin-unstable.overlays.default
]
