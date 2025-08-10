{
  lib',
  inputs,
  self,
  lib,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      customPackagesPerSystem = lib.filterAttrs (
        name: value: lib.meta.availableOn { inherit system; } value && lib.isDerivation value
      ) pkgs.customPackages;
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      legacyPackages = pkgs;
      packages = customPackagesPerSystem // {
        default = pkgs.writeShellScriptBin "builder" ''
          exec ${lib.getExe pkgs.builder} --flake ${self.outPath} "$@"
        '';
      };
    };
  flake = {
    lib = lib'.self;
    overlays.default = import ../overlay self.overlayArgs;
    nixpkgsConfig = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    overlayArgs = {
      inherit
        self
        inputs
        lib'
        ;
    };
  };
}
