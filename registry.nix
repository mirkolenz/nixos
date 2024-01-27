# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
{
  inputs,
  lib',
  os,
  channel,
  ...
}:
let
  mkEntry =
    channel:
    lib'.self.systemInput {
      inherit inputs os channel;
      name = "nixpkgs";
    };
in
{
  stable.flake = mkEntry "stable";
  unstable.flake = mkEntry "unstable";
  pkgs.flake = mkEntry channel;
  nixpkgs.flake = mkEntry channel;
  self.flake = inputs.self;
}
