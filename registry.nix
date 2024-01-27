# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
{
  inputs,
  lib',
  os,
  channel,
  ...
}: let
  name = "nixpkgs";
in {
  stable.flake = lib'.self.systemInput {
    inherit inputs os name;
    channel = "stable";
  };
  unstable.flake = lib'.self.systemInput {
    inherit inputs os name;
    channel = "unstable";
  };
  pkgs.flake = lib'.self.systemInput {
    inherit inputs os channel name;
  };
  nixpkgs.flake = lib'.self.systemInput {
    inherit inputs os name;
    channel = "unstable";
  };
  self.flake = inputs.self;
}
