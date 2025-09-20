{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib,
  self,
  ...
}:
let
  mkInstaller =
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
        self.nixosModules.installer
        { _module.args = moduleArgs; }
      ];
    };

  installer-raspi = mkInstaller {
    system = "aarch64-linux";
    extraModule = {
      imports = [
        "${inputs.nixos-hardware}/raspberry-pi/4"
      ];
      boot.tmp = {
        useTmpfs = true;
        tmpfsSize = "16G";
      };
    };
  };
in
{
  flake.legacyPackages = {
    aarch64-linux.installers.raspi = installer-raspi.config.system.build.images.sd-card;
    x86_64-linux.installers.apple-t2 =
      inputs.apple-t2-iso.packages.x86_64-linux.installers.t2-iso-minimal;
  };
  perSystem =
    { system, ... }:
    lib.optionalAttrs (lib.hasSuffix "-linux" system) {
      legacyPackages.installers.default =
        (mkInstaller {
          inherit system;
        }).config.system.build.images;
    };
}
