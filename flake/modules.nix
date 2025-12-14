{
  specialModuleArgs,
  moduleArgs,
  inputs,
  self,
  ...
}:
{
  # todo: enable after next disko release
  # imports = [ inputs.disko.flakeModules.default ];
  flake = {
    systemModules.base =
      { os, ... }:
      {
        imports = [ ../common ];
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        _module.args = moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          sharedModules = [ self.homeModules.base ];
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialModuleArgs // {
            inherit os;
          };
        };
      };
    homeModules.base = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        ../home/options
        ../common
      ];
      _module.args = moduleArgs;
    };
    homeModules.linux = {
      imports = [
        ../home/mlenz/common
        ../home/mlenz/linux
        inputs.vscode-server.homeModules.default
        inputs.cosmic-manager.homeManagerModules.default
      ];
    };
    homeModules.darwin = {
      imports = [
        ../home/mlenz/common
        ../home/mlenz/darwin
        # inputs.plist-manager.homeManagerModules.default
      ];
    };
    homeModules.base-standalone =
      { pkgs, ... }:
      {
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        imports = [ self.homeModules.base ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
      };
    homeModules.linux-standalone = {
      imports = [
        self.homeModules.base-standalone
        self.homeModules.linux
        ../home/mlenz/standalone
      ];
    };
    homeModules.darwin-standalone = {
      imports = [
        self.homeModules.base-standalone
        self.homeModules.darwin
        ../home/mlenz/standalone
      ];
    };
    nixosModules.installer = ../system/installer.nix;
    nixosModules.base = {
      imports = [
        self.systemModules.base
        inputs.home-manager.nixosModules.default
        inputs.quadlet-nix.nixosModules.default
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.default
      ];
    };
    nixosModules.default = {
      imports = [
        self.nixosModules.base
        ../system/common
        ../system/linux
      ];
      home-manager.users.${moduleArgs.user.login} = self.homeModules.linux;
    };
    darwinModules.base = {
      imports = [
        self.systemModules.base
        inputs.home-manager.darwinModules.default
        inputs.determinate.darwinModules.default
        # inputs.plist-manager.darwinModules.default
      ];
    };
    darwinModules.default = {
      imports = [
        self.darwinModules.base
        ../system/common
        ../system/darwin
      ];
      home-manager.users.${moduleArgs.user.login} = self.homeModules.darwin;
    };
  };
}
