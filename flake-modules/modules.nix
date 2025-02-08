{
  specialModuleArgs,
  moduleArgs,
  nixpkgsArgs,
  inputs,
  self,
  lib',
  ...
}:
{
  flake = {
    systemModules.default =
      { channel, os, ... }:
      {
        imports = [
          ../system/common
        ];
        nixpkgs = nixpkgsArgs;
        _module.args = moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialModuleArgs // {
            inherit channel os;
          };
        };
      };
    homeModules.default = {
      imports = [
        inputs.nix-index-database.hmModules.nix-index
        inputs.catppuccin.homeManagerModules.catppuccin
        ../home/mlenz/common
        ../home/options
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
        nixpkgs = nixpkgsArgs;
        imports = [ self.homeModules.linux ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
      };
    homeModules.darwin-standalone = {
      nixpkgs = nixpkgsArgs;
      imports = [ self.homeModules.darwin ];
    };
    nixosModules.default =
      { channel, os, ... }:
      let
        homeManager = lib'.self.systemInput {
          inherit inputs channel os;
          name = "home-manager";
        };
      in
      {
        imports = [
          self.systemModules.default
          homeManager.nixosModules.default
          inputs.quadlet-nix.nixosModules.default
          inputs.nixos-cosmic.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
          ../system/linux
          {
            home-manager.users.mlenz = self.homeModules.linux;
          }
        ];
      };
    darwinModules.default =
      { channel, os, ... }:
      let
        homeManager = lib'.self.systemInput {
          inherit inputs channel os;
          name = "home-manager";
        };
      in
      {
        imports = [
          self.systemModules.default
          homeManager.darwinModules.default
          ../system/darwin
          {
            home-manager.users.mlenz = self.homeModules.darwin;
          }
        ];
      };
  };
}
