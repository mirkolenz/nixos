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
      channel,
      system,
      computerName,
      extraModule ? { },
    }:
    let
      os = "darwin";
      nixDarwin = lib'.self.systemInput {
        inherit inputs channel os;
        name = "nix";
      };
    in
    nixDarwin.lib.darwinSystem {
      inherit system;
      specialArgs = specialModuleArgs // {
        inherit channel os;
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
        channel = "unstable";
        system = "x86_64-darwin";
        computerName = "Mirkos MacBook";
        extraModule = {
          custom.profile.isDesktop = true;
        };
      };
      mirkos-unibook = {
        channel = "unstable";
        system = "aarch64-darwin";
        computerName = "Mirkos UniBook";
        extraModule = {
          custom.profile.isDesktop = true;
        };
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
