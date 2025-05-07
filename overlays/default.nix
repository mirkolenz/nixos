args@{ inputs, ... }:
[
  inputs.nix-darwin-unstable.overlays.default
  (import ./by-name.nix args)
  (import ./channels.nix args)
  (import ./imports.nix args)
  (import ./overrides.nix args)
]
