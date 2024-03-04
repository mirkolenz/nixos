args@{ lib', inputs, ... }:
[ inputs.poetry2nix.overlays.default ]
++ (map (value: import value args) (lib'.flocken.getModules ./.))
