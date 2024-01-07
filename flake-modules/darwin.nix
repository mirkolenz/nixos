{
  inputs,
  specialModuleArgs,
  self,
  ...
}: let
  mkDarwinSystem = hostName: {
    channel,
    system,
    computerName,
  }:
    inputs."nix-darwin-${channel}".lib.darwinSystem {
      inherit system;
      specialArgs = specialModuleArgs;
      modules = [
        self.configModules.system
        inputs."home-manager-darwin-${channel}".darwinModules.home-manager
        ../system/darwin
        ../hosts/${hostName}
        {
          networking = {
            inherit hostName computerName;
          };
        }
      ];
    };
in {
  flake.darwinConfigurations = builtins.mapAttrs mkDarwinSystem {
    mirkos-macbook = {
      channel = "unstable";
      system = "x86_64-darwin";
      computerName = "Mirkos MacBook";
    };
  };
}
