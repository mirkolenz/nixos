{
  inputs,
  specialModuleArgs,
  self,
  lib',
  lib,
  ...
}:
let
  mkDarwinSystem =
    hostName:
    {
      system,
      computerName,
      extraModule ? { },
    }:
    inputs.nix-darwin.lib.darwinSystem {
      system = null;
      specialArgs = specialModuleArgs // {
        os = "darwin";
      };
      modules = [
        extraModule
        self.darwinModules.default
        {
          networking = {
            inherit hostName computerName;
          };
          nixpkgs.hostPlatform = system;
        }
      ]
      ++ lib'.flocken.optionalPath ../hosts/${hostName};
    };
in
{
  flake = {
    darwinConfigurations = lib.mapAttrs mkDarwinSystem {
      mirkos-macbook = {
        system = "x86_64-darwin";
        computerName = "Mirkos MacBook";
      };
      mirkos-unibook = {
        system = "aarch64-darwin";
        computerName = "Mirkos UniBook";
      };
    };
  };
  perSystem =
    { system, ... }:
    let
      mkDarwinJob = name: module: module.config.system.build.toplevel;
      filterDarwinJob = name: module: module.config.nixpkgs.hostPlatform.system == system;
    in
    {
      hydraJobs.darwinConfigurations = lib.mapAttrs mkDarwinJob (
        lib.filterAttrs filterDarwinJob self.darwinConfigurations
      );
    };
}
