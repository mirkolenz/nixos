{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  self,
  ...
}:
let
  mkInstaller =
    {
      system,
      channel,
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
        self.nixosModules.installer
        { _module.args = moduleArgs; }
      ];
    };
in
{
  flake.nixosConfigurations = {
    installer-raspi = mkInstaller {
      system = "aarch64-linux";
      channel = "unstable"; # todo: change to "stable" for nixos 25.05
      extraModule = {
        imports = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];
        boot.tmp = {
          useTmpfs = true;
          tmpfsSize = "16G";
        };
      };
    };
    # TODO: add stable variants for nixos 25.05
    # installer-aarch64-stable = mkInstaller {
    #   system = "aarch64-linux";
    #   channel = "stable";
    # };
    # installer-x86_64-stable = mkInstaller {
    #   system = "x86_64-linux";
    #   channel = "stable";
    # };
    installer-aarch64-unstable = mkInstaller {
      system = "aarch64-linux";
      channel = "unstable";
    };
    installer-x86_64-unstable = mkInstaller {
      system = "x86_64-linux";
      channel = "unstable";
    };
  };
}
