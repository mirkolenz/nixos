args@{ inputs, ... }:
[
  (import ./channels args)
  (import ./packages.nix args)
  inputs.nix-darwin-unstable.overlays.default
]
