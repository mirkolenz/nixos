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
      isDesktop ? true,
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
          custom.profile.isDesktop = isDesktop;
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
      mirkos-dfkibook = {
        system = "aarch64-darwin";
        computerName = "Mirkos DFKIbook";
      };
    };
    hydraJobs.darwinConfigurations = lib.mapAttrs (
      name: module: module.config.system.build.toplevel
    ) self.darwinConfigurations;
  };
}
