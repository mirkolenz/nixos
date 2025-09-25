{
  specialModuleArgs,
  moduleArgs,
  inputs,
  self,
  user,
  ...
}:
{
  # todo: enable after next disko release
  # imports = [ inputs.disko.flakeModules.default ];
  flake = {
    systemModules.default =
      { os, ... }:
      {
        imports = [
          ../common
          ../system/common
        ];
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        _module.args = moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialModuleArgs // {
            inherit os;
          };
        };
      };
    homeModules.default = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ../home/mlenz/common
        ../home/options
        ../common
      ];
      _module.args = moduleArgs;
    };
    homeModules.linux = {
      imports = [
        ../home/mlenz/linux
        self.homeModules.default
        inputs.vscode-server.homeModules.default
        inputs.cosmic-manager.homeManagerModules.default
      ];
    };
    homeModules.darwin = {
      imports = [
        ../home/mlenz/darwin
        self.homeModules.default
      ];
    };
    homeModules.linux-standalone =
      { pkgs, ... }:
      {
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        imports = [
          self.homeModules.linux
          ../home/mlenz/standalone
        ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
      };
    homeModules.darwin-standalone = {
      nixpkgs = {
        config = self.nixpkgsConfig;
        overlays = [
          self.overlays.default
          ../home/mlenz/darwin
        ];
      };
      imports = [ self.homeModules.darwin ];
    };
    nixosModules.default = {
      imports = [
        self.systemModules.default
        inputs.home-manager.nixosModules.default
        inputs.quadlet-nix.nixosModules.default
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.default
        ../system/linux
        {
          home-manager.users.${user.login} = self.homeModules.linux;
        }
      ];
    };
    nixosModules.installer = ../system/installer.nix;
    darwinModules.default = {
      imports = [
        self.systemModules.default
        inputs.home-manager.darwinModules.default
        inputs.determinate.darwinModules.default
        ../system/darwin
        {
          home-manager.users.${user.login} = self.homeModules.darwin;
        }
      ];
    };
  };
}
