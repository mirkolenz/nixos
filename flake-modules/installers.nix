{
  inputs,
  specialModuleArgs,
  moduleArgs,
  ...
}:
let
  mkInstaller =
    {
      system,
      format,
      module,
    }:
    inputs.nixos-generators.nixosGenerate {
      inherit system format;
      specialArgs = specialModuleArgs // {
        channel = "stable";
        os = "linux";
      };
      modules = [
        module
        { _module.args = moduleArgs; }
      ];
    };
in
{
  flake.packages = {
    aarch64-linux.installer-raspi = mkInstaller {
      system = "aarch64-linux";
      format = "sd-aarch64";
      module = ../installer/raspi.nix;
    };
    aarch64-linux.installer-iso = mkInstaller {
      system = "aarch64-linux";
      format = "install-iso";
      module = ../installer/iso.nix;
    };
    x86_64-linux.installer-iso = mkInstaller {
      system = "x86_64-linux";
      format = "install-iso";
      module = ../installer/iso.nix;
    };
  };
}
