{ lib, self, ... }:
{
  flake.hydraJobs = {
    darwinConfigurations = lib.mapAttrs (
      name: module: module.config.system.build.toplevel
    ) self.darwinConfigurations;
    homeConfigurations = lib.mapAttrs (name: module: module.activationPackage) self.homeConfigurations;
  };
  perSystem =
    { system, ... }:
    let
      currentSystem = name: value: value.pkgs.stdenv.hostPlatform.system == system;

      nixosConfigs = lib.mapAttrs' (name: value: {
        name = "nixos-config-${name}";
        value = value.config.system.build.toplevel;
      }) (lib.filterAttrs currentSystem self.nixosConfigurations);

      darwinConfigs = lib.mapAttrs' (name: value: {
        name = "darwin-config-${name}";
        value = value.config.system.build.toplevel;
      }) (lib.filterAttrs currentSystem self.darwinConfigurations);

      homeConfigs = lib.mapAttrs' (name: value: {
        name = "home-config-${name}";
        value = value.activationPackage;
      }) (lib.filterAttrs currentSystem self.homeConfigurations);

    in
    {
      packages = lib.mkMerge [
        nixosConfigs
        darwinConfigs
        homeConfigs
      ];
    };
}
