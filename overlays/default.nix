args@{ lib', inputs, ... }:
[
  inputs.poetry2nix.overlays.default
  inputs.nix-darwin-unstable.overlays.default
]
++ (map (value: import value args) (lib'.flocken.getModules ./.))
