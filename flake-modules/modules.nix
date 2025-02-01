{
  specialModuleArgs,
  moduleArgs,
  nixpkgsArgs,
  inputs,
  ...
}:
let
  homeModule = {
    imports = [
      ../home/mlenz
      ../home/options
      inputs.vscode-server.homeModules.default
      inputs.cosmic-manager.homeManagerModules.cosmic-manager
    ];
    _module.args = moduleArgs;
  };
in
{
  flake.configModules = {
    home =
      { pkgs, ... }:
      {
        nixpkgs = nixpkgsArgs;
        _module.args.osConfig = { };
        imports = [ homeModule ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
      };

    system =
      { channel, os, ... }:
      {
        nixpkgs = nixpkgsArgs;
        _module.args = moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialModuleArgs // {
            inherit channel os;
          };
          users.mlenz = homeModule;
        };
      };
  };
}
