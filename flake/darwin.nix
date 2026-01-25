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
      darwinModule ? "default",
      isDesktop ? true,
    }:
    inputs.nix-darwin.lib.darwinSystem {
      system = null;
      specialArgs = specialModuleArgs // {
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
          custom.profile.isDesktop = isDesktop;
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
