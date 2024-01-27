{
  inputs,
  specialModuleArgs,
  moduleArgs,
  ...
}: let
  mkInstaller = {
    system,
    format,
    module,
  }:
    inputs.nixos-generators.nixosGenerate {
      inherit system format;
      specialArgs =
        specialModuleArgs
        // {
          channel = "stable";
          os = "linux";
        };
      customFormats = import ../installer/formats.nix inputs.nixos-generators.inputs.nixpkgs;
      modules = [
        {_module.args = moduleArgs;}
        module
      ];
    };
in {
  flake.packages = {
    aarch64-linux.installer-raspi = mkInstaller {
      system = "aarch64-linux";
      format = "custom-sd";
      module = ../installer/raspi.nix;
    };
    aarch64-linux.installer-iso = mkInstaller {
      system = "aarch64-linux";
      format = "custom-iso";
      module = ../installer/iso.nix;
    };
    x86_64-linux.installer-iso = mkInstaller {
      system = "x86_64-linux";
      format = "custom-iso";
      module = ../installer/iso.nix;
    };
  };
}
