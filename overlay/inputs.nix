{
  inputs,
  self,
  lib',
  ...
}:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  fromInput = input: package: inputs.${input}.packages.${system}.${package} or final.empty;
  os = lib'.self.systemOs system;
  nixpkgsArgs = {
    inherit system;
    config = self.nixpkgsConfig;
  };
in
{
  inherit prev;
  nixpkgs = import inputs.nixpkgs nixpkgsArgs;
  stable = import (lib'.self.systemInput {
    inherit inputs os;
    name = "nixpkgs";
    channel = "stable";
  }) nixpkgsArgs;
  unstable = import (lib'.self.systemInput {
    inherit inputs os;
    name = "nixpkgs";
    channel = "unstable";
  }) nixpkgsArgs;

  inherit (self.packages.${system})
    nixvim-full
    nixvim-minimal
    treefmt-nix
    ;
  determinate-nix = inputs.determinate.inputs.nix.packages."${system}".default;

  cosmic-manager = fromInput "cosmic-manager" "cosmic-manager";
  disko = fromInput "disko" "disko";
  disko-install = fromInput "disko" "disko-install";
  nix-converter = fromInput "nix-converter" "default";
  nix-sweep = fromInput "nix-sweep" "default";

}
