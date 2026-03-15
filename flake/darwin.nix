{
  inputs,
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
      darwinModule ? "default",
    }:
    inputs.nix-darwin.lib.darwinSystem {
      system = null;
      specialArgs = self.specialModuleArgs // {
        os = "darwin";
      };
      modules = [
        extraModule
        self.darwinModules.${darwinModule}
        {
          networking = {
            inherit hostName computerName;
          };
          nixpkgs.hostPlatform = system;
          custom.features = {
            withDisplay = lib.mkDefault true;
            withOptionals = lib.mkDefault true;
          };
        }
      ]
      ++ lib'.flocken.optionalPath ../hosts/${hostName};
    };
in
{
  imports = [ inputs.nix-darwin.flakeModules.default ];
  flake.darwinConfigurations = lib.mapAttrs mkDarwinSystem {
    mirkos-macbook = {
      system = "aarch64-darwin";
      computerName = "Mirkos MacBook";
    };
  };
}
