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
        {
          networking = {
            inherit hostName computerName;
          };
        }
      ] ++ lib'.flocken.optionalPath ../hosts/${hostName};
    };
in
{
  flake = {
    darwinConfigurations = lib.mapAttrs mkDarwinSystem {
      mirkos-macbook = {
        channel = "unstable";
        system = "x86_64-darwin";
        computerName = "Mirkos MacBook";
      };
      mirkos-macbook-arm = {
        channel = "unstable";
        system = "x86_64-darwin";
        computerName = "Mirkos MacBook Apple Silicon";
      };
    };
  };
}
