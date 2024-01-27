{
  inputs,
  specialModuleArgs,
  moduleArgs,
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
        type = lib.types.submoduleWith {
          specialArgs = specialModuleArgs;
          modules = [
            ../vim
            {_module.args = moduleArgs;}
          ];
          # If set to false (default), the following error is thrown:
          # A submoduleWith option is declared multiple times with conflicting shorthandOnlyDefinesConfig values
          # Reason: HM uses the type `submodule` where this is set to true by default
          shorthandOnlyDefinesConfig = true;
        };
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
      _module.args.osConfig = {};
      imports = [homeModule];
      targets.genericLinux.enable = pkgs.stdenv.isLinux;
    };

    system = {
      channel,
      os,
      ...
    }: {
      inherit nixpkgs;
      _module.args = moduleArgs;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs =
          specialModuleArgs
          // {
            inherit channel os;
          };
        users.mlenz = homeModule;
      };
    };
  };
}
