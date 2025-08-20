{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  lib,
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

  installer-raspi = mkInstaller {
    system = "aarch64-linux";
    channel = "unstable"; # todo: change to "stable" for nixos 25.05
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
    x86_64-linux.installers.apple-t2 = inputs.apple-t2-iso.packages.x86_64-linux.installers.t2-iso-minimal;
  };
  perSystem =
    { system, ... }:
    lib.optionalAttrs (lib.hasSuffix "-linux" system) {
      # TODO: add stable variant for nixos 25.05
      legacyPackages.installers = lib.genAttrs [ "unstable" ] (
        channel:
        (mkInstaller {
          inherit system channel;
        }).config.system.build.images
      );
    };
}
