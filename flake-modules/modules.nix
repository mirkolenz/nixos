{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  ...
}: let
  nixpkgs = {
    config = import ../nixpkgs-config.nix;
    overlays = import ../overlays inputs;
  };
  homeModule = {
    pkgs,
    lib,
    ...
  }: {
    imports = [../home/mlenz];
    options = {
      programs.nixvim = lib.mkOption {
        type = lib.types.submodule (import ../vim lib');
      };
    };
    config = {
      _module.args = moduleArgs;
    };
  };
in {
  flake.configModules = {
    home = {pkgs, ...}: {
      inherit nixpkgs;
      _module.args = moduleArgs // {osConfig = {};};
      imports = [homeModule];
      targets.genericLinux.enable = pkgs.stdenv.isLinux;
    };

    system = {...}: {
      inherit nixpkgs;
      _module.args = moduleArgs;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialModuleArgs;
        users.mlenz = homeModule;
      };
    };
  };
}
