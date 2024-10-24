{
  inputs,
  specialModuleArgs,
  self,
  lib',
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
      homeManager = lib'.self.systemInput {
        inherit inputs channel os;
        name = "home-manager";
      };
    in
    nixDarwin.lib.darwinSystem {
      inherit system;
      specialArgs = specialModuleArgs // {
        inherit channel os;
      };
      modules = [
        extraModule
        self.configModules.system
        homeManager.darwinModules.default
        inputs.determinate.darwinModules.default
        ../system/darwin
        ../hosts/${hostName}
        {
          networking = {
            inherit hostName computerName;
          };
        }
      ];
    };
in
{
  flake = {
    checks.x86_64-darwin = {
      mirkos-macbook = self.darwinConfigurations.mirkos-macbook.config.system.build.toplevel;
    };
    darwinConfigurations = builtins.mapAttrs mkDarwinSystem {
      mirkos-macbook = {
        channel = "unstable";
        system = "x86_64-darwin";
        computerName = "Mirkos MacBook";
      };
      mirkos-unibook = {
        channel = "unstable";
        system = "x86_64-darwin";
        computerName = "Mirkos UniBook";
      };
    };
  };
}
