{
  inputs,
  specialModuleArgs,
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
      system = null;
      specialArgs = specialModuleArgs // {
        os = "linux";
      };
      modules = [
        extraModule
        self.nixosModules.installer
        {
          nixpkgs.hostPlatform = system;
        }
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

  # https://github.com/t2linux/nixos-t2-iso/blob/main/nix/t2-iso-minimal.nix
  installer-apple-t2 = mkInstaller {
    system = "x86_64-linux";
    extraModule = {
      imports = [
        "${inputs.nixos-hardware}/apple/t2"
      ];
    };
  };
in
{
  flake.legacyPackages = {
    aarch64-linux.installers.raspi = installer-raspi.config.system.build.images.sd-card;
    x86_64-linux.installers.apple-t2 = installer-apple-t2.config.system.build.images.isoImage;
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
