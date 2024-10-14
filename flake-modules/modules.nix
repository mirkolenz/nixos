{
  specialModuleArgs,
  moduleArgs,
  ...
}:
let
  nixpkgs = {
    config = import ../nixpkgs-config.nix;
    overlays = import ../overlays specialModuleArgs;
  };
  homeModule = {
    imports = [
      ../home/mlenz
      ../home/options
    ];
    _module.args = moduleArgs;
  };
in
{
  flake.configModules = {
    home =
      { pkgs, ... }:
      {
        inherit nixpkgs;
        _module.args.osConfig = { };
        imports = [ homeModule ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
      };

    system =
      { channel, os, ... }:
      {
        inherit nixpkgs;
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
