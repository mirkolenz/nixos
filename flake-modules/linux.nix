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
      channel,
      system,
      extraModule ? { },
    }:
    let
      os = "linux";
      nixpkgs = lib'.self.systemInput {
        inherit inputs channel os;
        name = "nixpkgs";
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialModuleArgs // {
        inherit channel os;
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
      channel = "unstable";
      system = "x86_64-linux";
    };
    macpro = {
      channel = "stable";
      system = "x86_64-linux";
    };
    raspi = {
      channel = "stable";
      system = "aarch64-linux";
    };
    macbook-9-1 = {
      channel = "unstable";
      system = "x86_64-linux";
    };
    macbook-11-3 = {
      channel = "unstable";
      system = "x86_64-linux";
    };
  };
}
