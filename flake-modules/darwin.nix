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
      inherit system;
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
    { ... }:
    {
      packages = lib.mapAttrs' (name: module: {
        name = "darwin-config-${name}";
        value = module.config.system.build.toplevel;
      }) self.darwinConfigurations;
    };
}
