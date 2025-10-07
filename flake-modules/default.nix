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
      config,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      legacyPackages = pkgs // {
        ci = pkgs.releaseTools.aggregate {
          name = "ci";
          constituents = lib.attrValues (
            lib.filterAttrs (name: pkg: lib.elem system (pkg.meta.hydraPlatforms or [ system ])) config.packages
          );
        };
      };
      packages =
        (lib.filterAttrs (
          name: value: lib.meta.availableOn { inherit system; } value && !(value.meta.broken or false)
        ) pkgs.drvs)
        // {
          default = pkgs.writeShellScriptBin "builder" ''
            exec ${lib.getExe pkgs.builder} --flake ${self.outPath} "$@"
          '';
        };
    };
  flake = {
    lib = lib';
    overlays.default = import ../pkgs self.overlayArgs;
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
