args@{ inputs, ... }:
[
  (import ./channels args)
  (import ./packages args)
  inputs.nix-darwin-unstable.overlays.default
]
