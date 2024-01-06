{
  inputs,
  specialArgs,
  self,
  ...
}: let
  mkLinuxSystem = hostName: {
    channel,
    system,
  }:
    inputs."nixpkgs-linux-${channel}".lib.nixosSystem {
      inherit specialArgs system;
      modules = [
        self.configModules.system
        inputs."home-manager-linux-${channel}".nixosModules.home-manager
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
