{
  inputs,
  lib',
  config,
  ...
}:
final: prev:
let
  inherit (final.pkgs) system;
  os = lib'.self.systemOs system;
  importArgs = {
    inherit system config;
  };
in
{
  nixpkgs = import inputs.nixpkgs importArgs;
  stable = import (lib'.self.systemInput {
    inherit inputs os;
    name = "nixpkgs";
    channel = "stable";
  }) importArgs;
  unstable = import (lib'.self.systemInput {
    inherit inputs os;
    name = "nixpkgs";
    channel = "unstable";
  }) importArgs;
  unstable-small = import inputs.nixpkgs-unstable-small importArgs;
  stable-small = import inputs.nixpkgs-stable-small importArgs;
}
