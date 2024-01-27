{
  inputs,
  specialModuleArgs,
  self,
  lib',
  ...
}: let
  mkLinuxSystem = hostName: {
    channel,
    system,
  }: let
    os = "linux";
    nixpkgs = lib'.self.systemInput {
      inherit inputs channel os;
      name = "nixpkgs";
    };
    homeManager = lib'.self.systemInput {
      inherit inputs channel os;
      name = "home-manager";
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs =
        specialModuleArgs
        // {
          inherit channel os;
        };
      modules = [
        self.configModules.system
        homeManager.nixosModules.home-manager
        ../system/linux
        ../hosts/${hostName}
        {
          networking.hostName = hostName;
        }
      ];
    };
in {
  flake.nixosConfigurations = builtins.mapAttrs mkLinuxSystem {
    vm = {
      channel = "unstable";
      system = "x86_64-linux";
    };
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
