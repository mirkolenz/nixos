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
        nixpkgs = nixpkgsArgs;
        _module.args = moduleArgs;
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialModuleArgs // {
            inherit channel os;
          };
          users.mlenz = self.homeModules.default;
        };
      };
    homeModules.default = {
      imports = [
        ../home/mlenz
        ../home/options
        inputs.vscode-server.homeModules.default
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
      _module.args = moduleArgs;
    };
    homeModules.standalone =
      { pkgs, ... }:
      {
        nixpkgs = nixpkgsArgs;
        _module.args.osConfig = { };
        imports = [ self.homeModules.default ];
        targets.genericLinux.enable = pkgs.stdenv.isLinux;
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
          ../system/linux
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
        ];
      };
  };
}
