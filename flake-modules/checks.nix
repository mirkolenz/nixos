{ lib, self, ... }:
{
  flake.hydraJobs = {
    darwinConfigurations = lib.mapAttrs (
      name: module: module.config.system.build.toplevel
    ) self.darwinConfigurations;
    homeConfigurations = lib.mapAttrs (name: module: module.activationPackage) self.homeConfigurations;
  };
}
