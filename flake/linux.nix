{
  inputs,
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
      nixosModule ? "default",
    }:
    inputs.nixpkgs-linux-unstable.lib.nixosSystem {
      system = null;
      specialArgs = self.specialModuleArgs // {
        os = "linux";
      };
      modules = [
        extraModule
        self.nixosModules.${nixosModule}
        {
          networking = { inherit hostName; };
          nixpkgs.hostPlatform = system;
        }
      ]
      ++ lib'.flocken.optionalPath ../hosts/${hostName};
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs mkLinuxSystem {
    orbstack = {
      system = "aarch64-linux";
    };
    orbstack-intel = {
      system = "x86_64-linux";
      extraModule = ../hosts/orbstack;
    };
    utm = {
      system = "aarch64-linux";
    };
    utm-intel = {
      system = "x86_64-linux";
      extraModule = ../hosts/utm;
    };
    wsl = {
      system = "x86_64-linux";
    };
    macpro = {
      system = "x86_64-linux";
    };
    raspi = {
      system = "aarch64-linux";
    };
    hetzner-cloud = {
      system = "x86_64-linux";
    };
    macbook-91 = {
      system = "x86_64-linux";
      nixosModule = "children";
    };
    macbook-113 = {
      system = "x86_64-linux";
    };
    macbook-161 = {
      system = "x86_64-linux";
    };
  };
}
