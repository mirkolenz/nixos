{
  inputs,
  lib',
  self,
  ...
}:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  os = lib'.self.systemOs system;
  importArgs = {
    inherit system;
    config = self.nixpkgsConfig;
  };
in
{
  inherit prev;
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
}
