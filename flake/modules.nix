{
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake = {
    systemModules.base =
      { os, ... }:
      {
        imports = [
          ../common
          ../system/common-base
        ];
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        _module.args = self.moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          sharedModules = [ self.homeModules.base ];
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = self.specialModuleArgs // {
            inherit os;
          };
        };
      };
    homeModules.base = {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
        inputs.nixvim.homeModules.nixvim
        ../home/options
        ../common
      ];
      _module.args = self.moduleArgs;
    };
    homeModules.linux = {
      imports = [
        ../home/mlenz/common
        ../home/mlenz/linux
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
      { pkgs, lib, ... }:
      {
        nixpkgs = {
          config = self.nixpkgsConfig;
          overlays = [ self.overlays.default ];
        };
        imports = [ self.homeModules.base ];
        targets.genericLinux.enable = lib.mkDefault pkgs.stdenv.isLinux;
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
    nixosModules.installer = {
      imports = [
        inputs.determinate.nixosModules.default
        ../system/linux-installer
      ];
      nixpkgs = {
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      _module.args = self.moduleArgs;
    };
    nixosModules.base = {
      imports = [
        self.systemModules.base
        ../system/linux-base
        inputs.home-manager.nixosModules.default
        inputs.quadlet-nix.nixosModules.default
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.default
      ];
    };
    nixosModules.default = {
      imports = [
        self.nixosModules.base
        ../system/linux
      ];
      home-manager.users.${self.moduleArgs.user.login} = self.homeModules.linux;
    };
    nixosModules.children = {
      imports = [
        self.nixosModules.base
        ../system/linux-children
      ];
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
        ../system/darwin
      ];
      home-manager.users.${self.moduleArgs.user.login} = self.homeModules.darwin;
    };
  };
}
