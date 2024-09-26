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
  homeModule =
    {
      lib,
      channel,
      os,
      ...
    }:
    {
      imports = [
        ../home/mlenz
        ../home/options
      ];
      options = {
        # https://github.com/nix-community/nixvim/blob/main/wrappers/hm.nix
        programs.nixvim = lib.mkOption {
          type = lib.types.submoduleWith {
            specialArgs = specialModuleArgs // {
              inherit channel os;
            };
            modules = [
              ../vim
              { _module.args = moduleArgs; }
            ];
          };
          # nixvim = lib'.self.systemInput {
          #   inherit inputs channel os;
          #   name = "nixvim";
          # };
          # nixvimConfig = nixvim.lib.modules.evalNixvim {
          #   extraSpecialArgs = specialModuleArgs // {
          #     inherit channel os;
          #   };
          #   modules = [
          #     ../vim
          #     { _module.args = moduleArgs; }
          #   ];
          #   check = false;
          # };
          # inherit (nixvimConfig) type;
        };
      };
      config = {
        _module.args = moduleArgs;
      };
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
