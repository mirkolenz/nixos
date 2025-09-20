{
  inputs,
  specialModuleArgs,
  self,
  lib',
  lib,
  ...
}:
let
  mkLinuxSystem =
    hostName:
    {
      system,
      extraModule ? { },
    }:
    inputs.nixpkgs-linux-unstable.lib.nixosSystem {
      inherit system;
      specialArgs = specialModuleArgs // {
        os = "linux";
      };
      modules = [
        extraModule
        self.nixosModules.default
        { networking.hostName = hostName; }
      ]
      ++ lib'.flocken.optionalPath ../hosts/${hostName};
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs mkLinuxSystem {
    orbstack = {
      system = "x86_64-linux";
    };
    macpro = {
      system = "x86_64-linux";
    };
    raspi = {
      system = "aarch64-linux";
    };
    macbook-91 = {
      system = "x86_64-linux";
    };
    macbook-113 = {
      system = "x86_64-linux";
    };
    macbook-161 = {
      system = "x86_64-linux";
    };
  };
}
